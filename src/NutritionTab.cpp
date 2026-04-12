// NutritionTab.cpp
// Table of all nutrition logs + Add / Edit / Delete + live search
// + MealType filter + date-range filter.
//
// Filter architecture (mirrors WorkoutsTab exactly):
//   1. Description keyword  — client-side string match
//   2. MealType filter      — client-side enum comparison
//   3. Date range           — LogManager::filterByDate(), result converted to ID set
// All three are ANDed: a row must pass every active filter to appear.

#include "NutritionTab.h"
#include "Nutrition.h"

#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QHeaderView>
#include <QLabel>
#include <QFrame>
#include <QDialog>
#include <QFormLayout>
#include <QComboBox>
#include <QDoubleSpinBox>
#include <QDateEdit>
#include <QDateTimeEdit>
#include <QDialogButtonBox>
#include <QMessageBox>
#include <QCheckBox>
#include <QUuid>
#include <unordered_set>

static std::string newID()
{
    return QUuid::createUuid().toString(QUuid::WithoutBraces).left(6).toStdString();
}

NutritionTab::NutritionTab(LogManager &lm, QWidget *parent)
    : QWidget(parent), logManager(lm)
{
    setupUI();
}

void NutritionTab::setupUI()
{
    auto *root = new QVBoxLayout(this);
    root->setContentsMargins(20, 20, 20, 16);
    root->setSpacing(10);

    auto *topRow = new QHBoxLayout;

    auto *heading = new QLabel("NUTRITION LOG");
    heading->setObjectName("heading");
    topRow->addWidget(heading);
    topRow->addStretch();

    searchBar = new QLineEdit;
    searchBar->setPlaceholderText("Search description...");
    searchBar->setFixedWidth(220);
    connect(searchBar, &QLineEdit::textChanged, this, &NutritionTab::refresh);
    topRow->addWidget(searchBar);
    root->addLayout(topRow);

    auto *sep1 = new QFrame;
    sep1->setFrameShape(QFrame::HLine);
    sep1->setStyleSheet("color:#333;");
    root->addWidget(sep1);

    auto *filterRow = new QHBoxLayout;
    filterRow->setSpacing(8);

    // MealType filter
    auto *mealLabel = new QLabel("Meal:");
    mealLabel->setStyleSheet("color:#aaa; font-size:12px;");
    filterRow->addWidget(mealLabel);

    mealFilter = new QComboBox;
    mealFilter->addItems({"All Types", "Breakfast", "Lunch", "Dinner", "Snack"});
    mealFilter->setFixedWidth(120);
    connect(mealFilter, QOverload<int>::of(&QComboBox::currentIndexChanged),
            this, &NutritionTab::refresh);
    filterRow->addWidget(mealFilter);

    filterRow->addSpacing(16);

    // Date range checkbox
    useDateFilter = new QCheckBox("Date Range:");
    useDateFilter->setStyleSheet("color:#aaa; font-size:12px;");
    connect(useDateFilter, &QCheckBox::toggled, this, [this](bool checked) {
        fromDate->setEnabled(checked);
        toDate->setEnabled(checked);
        refresh();
    });
    filterRow->addWidget(useDateFilter);

    // From date
    fromDate = new QDateEdit(QDate::currentDate().addMonths(-1));
    fromDate->setDisplayFormat("yyyy-MM-dd");
    fromDate->setCalendarPopup(true);
    fromDate->setEnabled(false);
    fromDate->setFixedWidth(110);
    connect(fromDate, &QDateEdit::dateChanged, this, &NutritionTab::refresh);
    filterRow->addWidget(fromDate);

    auto *arrow = new QLabel("→");
    arrow->setStyleSheet("color:#aaa;");
    filterRow->addWidget(arrow);

    // To date
    toDate = new QDateEdit(QDate::currentDate());
    toDate->setDisplayFormat("yyyy-MM-dd");
    toDate->setCalendarPopup(true);
    toDate->setEnabled(false);
    toDate->setFixedWidth(110);
    connect(toDate, &QDateEdit::dateChanged, this, &NutritionTab::refresh);
    filterRow->addWidget(toDate);

    filterRow->addSpacing(8);

    // Clear filters button
    auto *clearBtn = new QPushButton("Clear Filters");
    clearBtn->setFixedWidth(100);
    clearBtn->setStyleSheet(
        "QPushButton { background:#2d2d2d; color:#aaa; border:1px solid #444;"
        "              border-radius:4px; padding:5px 10px; font-size:12px; }"
        "QPushButton:hover { background:#3a3a3a; color:#ddd; }");
    connect(clearBtn, &QPushButton::clicked, this, [this]() {
        searchBar->blockSignals(true);
        mealFilter->blockSignals(true);
        useDateFilter->blockSignals(true);
        fromDate->blockSignals(true);
        toDate->blockSignals(true);

        searchBar->clear();
        mealFilter->setCurrentIndex(0);
        useDateFilter->setChecked(false);
        fromDate->setDate(QDate::currentDate().addMonths(-1));
        toDate->setDate(QDate::currentDate());
        fromDate->setEnabled(false);
        toDate->setEnabled(false);

        searchBar->blockSignals(false);
        mealFilter->blockSignals(false);
        useDateFilter->blockSignals(false);
        fromDate->blockSignals(false);
        toDate->blockSignals(false);

        refresh();
    });
    filterRow->addWidget(clearBtn);
    filterRow->addStretch();
    root->addLayout(filterRow);

    auto *sep2 = new QFrame;
    sep2->setFrameShape(QFrame::HLine);
    sep2->setStyleSheet("color:#333;");
    root->addWidget(sep2);

    // Columns: ID | Date | Title | Description | Meal Type | Calories | Macros
    table = new QTableWidget(0, 7, this);
    table->setHorizontalHeaderLabels({
        "ID", "Date", "Title", "Description", "Meal Type", "Calories", "Macros (P/C/F/S g)"
    });
    table->horizontalHeader()->setSectionResizeMode(QHeaderView::Stretch);
    table->horizontalHeader()->setSectionResizeMode(0, QHeaderView::ResizeToContents);
    table->setSelectionBehavior(QAbstractItemView::SelectRows);
    table->setEditTriggers(QAbstractItemView::NoEditTriggers);
    table->setAlternatingRowColors(true);
    table->verticalHeader()->setVisible(false);
    table->setShowGrid(false);
    root->addWidget(table);

    auto *btnRow = new QHBoxLayout;
    btnRow->addStretch();

    addBtn = new QPushButton("+ Add Meal");
    connect(addBtn, &QPushButton::clicked, this, &NutritionTab::onAdd);
    btnRow->addWidget(addBtn);

    editBtn = new QPushButton("Edit");
    connect(editBtn, &QPushButton::clicked, this, &NutritionTab::onEdit);
    btnRow->addWidget(editBtn);

    deleteBtn = new QPushButton("Delete");
    deleteBtn->setObjectName("danger");
    connect(deleteBtn, &QPushButton::clicked, this, &NutritionTab::onDelete);
    btnRow->addWidget(deleteBtn);

    root->addLayout(btnRow);

    refresh();
}

// Applies all three filters and repopulates the table.
void NutritionTab::refresh()
{
    table->setRowCount(0);

    const QString keyword    = searchBar->text().trimmed();
    const int     mealIdx    = mealFilter->currentIndex(); // 0 = All
    const bool    dateActive = useDateFilter->isChecked();

    // Build date-range ID set when the date filter is active
    std::unordered_set<std::string> dateSet;
    if (dateActive) {
        std::string start = fromDate->date().toString("yyyy-MM-dd").toStdString() + " 00:00";
        std::string end   = toDate->date().toString("yyyy-MM-dd").toStdString()   + " 23:59";
        for (Log *l : logManager.filterByDate(start, end))
            dateSet.insert(l->getLogID());
    }

    for (const auto &log : logManager.getLogs()) {
        Nutrition *n = dynamic_cast<Nutrition *>(log.get());
        if (!n) continue;

        // 1. Date filter
        if (dateActive && dateSet.find(n->getLogID()) == dateSet.end()) continue;

        // 2. MealType filter
        if (mealIdx != 0) {
            // combo index 1=Breakfast, 2=Lunch, 3=Dinner, 4=Snack
            MealType required;
            switch (mealIdx) {
            case 1:  required = MealType::Breakfast; break;
            case 2:  required = MealType::Lunch;     break;
            case 3:  required = MealType::Dinner;    break;
            default: required = MealType::Snack;     break;
            }
            if (n->getMealType() != required) continue;
        }

        // 3. Keyword filter
        if (!keyword.isEmpty()) {
            QString desc  = QString::fromStdString(n->getDescription());
            QString title = QString::fromStdString(n->getTitle());
            if (!desc.contains(keyword, Qt::CaseInsensitive) &&
                !title.contains(keyword, Qt::CaseInsensitive))
                continue;
        }

        int row = table->rowCount();
        table->insertRow(row);

        auto cell = [&](int col, const QString &text) {
            auto *item = new QTableWidgetItem(text);
            item->setTextAlignment(Qt::AlignCenter);
            table->setItem(row, col, item);
        };

        QString mealStr;
        switch (n->getMealType()) {
        case MealType::Breakfast: mealStr = "Breakfast"; break;
        case MealType::Lunch:     mealStr = "Lunch";     break;
        case MealType::Dinner:    mealStr = "Dinner";    break;
        case MealType::Snack:     mealStr = "Snack";     break;
        }

        // Macro summary: "P:25 C:40 F:10 S:5"
        QString macros = QString("P:%1  C:%2  F:%3  S:%4")
                             .arg(n->getProtein(), 0, 'f', 1)
                             .arg(n->getCarbs(),   0, 'f', 1)
                             .arg(n->getFats(),    0, 'f', 1)
                             .arg(n->getSugar(),   0, 'f', 1);

        cell(0, QString::fromStdString(n->getLogID()));
        cell(1, n->getDate().toString("yyyy-MM-dd"));
        cell(2, QString::fromStdString(n->getTitle()));
        cell(3, QString::fromStdString(n->getDescription()));
        cell(4, mealStr);
        cell(5, QString::number(n->getCaloriesConsumed(), 'f', 0) + " kcal");
        cell(6, macros);
    }
}

void NutritionTab::onDelete()
{
    int row = table->currentRow();
    if (row < 0) {
        QMessageBox::information(this, "Delete", "Please select a row first.");
        return;
    }
    QString id = table->item(row, 0)->text();
    if (QMessageBox::question(this, "Confirm", "Delete entry " + id + "?")
        == QMessageBox::Yes)
    {
        logManager.deleteLog(id.toStdString());
        refresh();
    }
}

// Pre-fills all fields from the selected Nutrition object and applies changes
// via setters — no re-creation, so the log ID and list position are preserved.
void NutritionTab::onEdit()
{
    int row = table->currentRow();
    if (row < 0) {
        QMessageBox::information(this, "Edit", "Please select a row first.");
        return;
    }

    std::string id = table->item(row, 0)->text().toStdString();

    Nutrition *target = nullptr;
    for (const auto &log : logManager.getLogs()) {
        if (log->getLogID() == id) {
            target = dynamic_cast<Nutrition *>(log.get());
            break;
        }
    }
    if (!target) {
        QMessageBox::warning(this, "Edit", "Could not locate entry " +
                                               QString::fromStdString(id));
        return;
    }

    QDialog dlg(this);
    dlg.setWindowTitle("Edit Meal  [" + QString::fromStdString(id) + "]");
    dlg.setFixedWidth(380);

    auto *form = new QFormLayout(&dlg);
    form->setSpacing(10);
    form->setContentsMargins(20, 20, 20, 20);

    auto *titleEdit = new QLineEdit(QString::fromStdString(target->getTitle()));
    titleEdit->setPlaceholderText("e.g. Post-workout shake");

    auto *descEdit = new QLineEdit(QString::fromStdString(target->getDescription()));
    descEdit->setMaxLength(100);

    auto *dateEdit = new QDateTimeEdit(target->getDate());
    dateEdit->setDisplayFormat("yyyy-MM-dd HH:mm");
    dateEdit->setCalendarPopup(true);

    auto *mealCombo = new QComboBox;
    mealCombo->addItems({"Breakfast", "Lunch", "Dinner", "Snack"});
    // Pre-select the current meal type
    switch (target->getMealType()) {
    case MealType::Breakfast: mealCombo->setCurrentIndex(0); break;
    case MealType::Lunch:     mealCombo->setCurrentIndex(1); break;
    case MealType::Dinner:    mealCombo->setCurrentIndex(2); break;
    case MealType::Snack:     mealCombo->setCurrentIndex(3); break;
    }

    auto *durSpin = new QDoubleSpinBox;
    durSpin->setRange(0, 120); durSpin->setSuffix(" min");
    durSpin->setValue(target->getDuration());

    auto *calSpin = new QDoubleSpinBox;
    calSpin->setRange(0, 10000); calSpin->setSuffix(" kcal");
    calSpin->setValue(target->getCaloriesConsumed());

    // Macro fields
    auto *proteinSpin = new QDoubleSpinBox;
    proteinSpin->setRange(0, 500); proteinSpin->setSuffix(" g");
    proteinSpin->setValue(target->getProtein());

    auto *carbsSpin = new QDoubleSpinBox;
    carbsSpin->setRange(0, 500); carbsSpin->setSuffix(" g");
    carbsSpin->setValue(target->getCarbs());

    auto *fatsSpin = new QDoubleSpinBox;
    fatsSpin->setRange(0, 500); fatsSpin->setSuffix(" g");
    fatsSpin->setValue(target->getFats());

    auto *sugarSpin = new QDoubleSpinBox;
    sugarSpin->setRange(0, 500); sugarSpin->setSuffix(" g");
    sugarSpin->setValue(target->getSugar());

    form->addRow("Title",             titleEdit);
    form->addRow("Description",       descEdit);
    form->addRow("Date / Time",       dateEdit);
    form->addRow("Meal Type",         mealCombo);
    form->addRow("Duration",          durSpin);
    form->addRow("Calories Consumed", calSpin);
    form->addRow("Protein",           proteinSpin);
    form->addRow("Carbs",             carbsSpin);
    form->addRow("Fats",              fatsSpin);
    form->addRow("Sugar",             sugarSpin);

    auto *buttons = new QDialogButtonBox(QDialogButtonBox::Save |
                                         QDialogButtonBox::Cancel);
    connect(buttons, &QDialogButtonBox::accepted, &dlg, &QDialog::accept);
    connect(buttons, &QDialogButtonBox::rejected, &dlg, &QDialog::reject);
    form->addRow(buttons);

    if (dlg.exec() != QDialog::Accepted) return;

    if (descEdit->text().trimmed().isEmpty()) {
        QMessageBox::warning(this, "Validation", "Description cannot be empty.");
        return;
    }

    target->setTitle(titleEdit->text().trimmed().toStdString());
    target->setDescription(descEdit->text().trimmed().toStdString());
    target->setDate(dateEdit->dateTime());
    target->setDuration(durSpin->value());
    target->setCaloriesConsumed(calSpin->value());
    target->setProtein(proteinSpin->value());
    target->setCarbs(carbsSpin->value());
    target->setFats(fatsSpin->value());
    target->setSugar(sugarSpin->value());

    MealType mt;
    switch (mealCombo->currentIndex()) {
    case 0:  mt = MealType::Breakfast; break;
    case 1:  mt = MealType::Lunch;     break;
    case 2:  mt = MealType::Dinner;    break;
    default: mt = MealType::Snack;     break;
    }
    target->setMealType(mt);

    refresh();
}

void NutritionTab::onAdd()
{
    QDialog dlg(this);
    dlg.setWindowTitle("Add Meal");
    dlg.setFixedWidth(380);

    auto *form = new QFormLayout(&dlg);
    form->setSpacing(10);
    form->setContentsMargins(20, 20, 20, 20);

    auto *titleEdit = new QLineEdit;
    titleEdit->setPlaceholderText("e.g. Post-workout shake");

    auto *descEdit = new QLineEdit;
    descEdit->setPlaceholderText("e.g. Oatmeal with fruit");
    descEdit->setMaxLength(100);

    auto *dateEdit = new QDateTimeEdit(QDateTime::currentDateTime());
    dateEdit->setDisplayFormat("yyyy-MM-dd HH:mm");
    dateEdit->setCalendarPopup(true);

    auto *mealCombo = new QComboBox;
    mealCombo->addItems({"Breakfast", "Lunch", "Dinner", "Snack"});

    auto *durSpin = new QDoubleSpinBox;
    durSpin->setRange(0, 120); durSpin->setSuffix(" min");
    durSpin->setToolTip("Duration of the meal sitting (optional)");

    auto *calSpin = new QDoubleSpinBox;
    calSpin->setRange(0, 10000); calSpin->setSuffix(" kcal");

    // Macro fields — all optional (default 0)
    auto *proteinSpin = new QDoubleSpinBox;
    proteinSpin->setRange(0, 500); proteinSpin->setSuffix(" g");

    auto *carbsSpin = new QDoubleSpinBox;
    carbsSpin->setRange(0, 500); carbsSpin->setSuffix(" g");

    auto *fatsSpin = new QDoubleSpinBox;
    fatsSpin->setRange(0, 500); fatsSpin->setSuffix(" g");

    auto *sugarSpin = new QDoubleSpinBox;
    sugarSpin->setRange(0, 500); sugarSpin->setSuffix(" g");

    form->addRow("Title (optional)",  titleEdit);
    form->addRow("Description",       descEdit);
    form->addRow("Date / Time",       dateEdit);
    form->addRow("Meal Type",         mealCombo);
    form->addRow("Duration",          durSpin);
    form->addRow("Calories Consumed", calSpin);
    form->addRow("Protein",           proteinSpin);
    form->addRow("Carbs",             carbsSpin);
    form->addRow("Fats",              fatsSpin);
    form->addRow("Sugar",             sugarSpin);

    auto *buttons = new QDialogButtonBox(QDialogButtonBox::Ok |
                                         QDialogButtonBox::Cancel);
    connect(buttons, &QDialogButtonBox::accepted, &dlg, &QDialog::accept);
    connect(buttons, &QDialogButtonBox::rejected, &dlg, &QDialog::reject);
    form->addRow(buttons);

    if (dlg.exec() != QDialog::Accepted) return;

    if (descEdit->text().trimmed().isEmpty()) {
        QMessageBox::warning(this, "Validation", "Description cannot be empty.");
        return;
    }

    MealType mt;
    switch (mealCombo->currentIndex()) {
    case 0:  mt = MealType::Breakfast; break;
    case 1:  mt = MealType::Lunch;     break;
    case 2:  mt = MealType::Dinner;    break;
    default: mt = MealType::Snack;     break;
    }

    try {
        logManager.addLog(std::make_unique<Nutrition>(
            newID(),
            dateEdit->dateTime(),
            descEdit->text().trimmed().toStdString(),
            durSpin->value(),
            mt,
            calSpin->value(),
            proteinSpin->value(),
            carbsSpin->value(),
            fatsSpin->value(),
            sugarSpin->value(),
            titleEdit->text().trimmed().toStdString()));
        refresh();
    } catch (const std::exception &e) {
        QMessageBox::critical(this, "Error", e.what());
    }
}