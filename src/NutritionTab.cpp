// NutritionTab.cpp
// Table of all nutrition logs + Add / Delete + live search.

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
#include <QDateTimeEdit>
#include <QDialogButtonBox>
#include <QMessageBox>
#include <QUuid>

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
    root->setSpacing(12);

    // ── Heading + search ──────────────────────────────────────────────────────
    auto *topRow = new QHBoxLayout;

    auto *heading = new QLabel("NUTRITION LOG");
    heading->setObjectName("heading");
    topRow->addWidget(heading);
    topRow->addStretch();

    searchBar = new QLineEdit;
    searchBar->setPlaceholderText("Search description...");
    searchBar->setFixedWidth(240);
    connect(searchBar, &QLineEdit::textChanged, this, &NutritionTab::refresh);
    topRow->addWidget(searchBar);

    root->addLayout(topRow);

    auto *sep = new QFrame;
    sep->setFrameShape(QFrame::HLine);
    sep->setStyleSheet("color:#333;");
    root->addWidget(sep);

    // ── Table ─────────────────────────────────────────────────────────────────
    table = new QTableWidget(0, 5, this);
    table->setHorizontalHeaderLabels({
        "ID", "Date", "Description", "Meal Type", "Calories"
    });
    table->horizontalHeader()->setSectionResizeMode(QHeaderView::Stretch);
    table->horizontalHeader()->setSectionResizeMode(0, QHeaderView::ResizeToContents);
    table->setSelectionBehavior(QAbstractItemView::SelectRows);
    table->setEditTriggers(QAbstractItemView::NoEditTriggers);
    table->setAlternatingRowColors(true);
    table->verticalHeader()->setVisible(false);
    table->setShowGrid(false);
    root->addWidget(table);

    // ── Buttons ───────────────────────────────────────────────────────────────
    auto *btnRow = new QHBoxLayout;
    btnRow->addStretch();

    addBtn = new QPushButton("+ Add Meal");
    connect(addBtn, &QPushButton::clicked, this, &NutritionTab::onAdd);
    btnRow->addWidget(addBtn);

    deleteBtn = new QPushButton("Delete");
    deleteBtn->setObjectName("danger");
    connect(deleteBtn, &QPushButton::clicked, this, &NutritionTab::onDelete);
    btnRow->addWidget(deleteBtn);

    root->addLayout(btnRow);

    refresh();
}

void NutritionTab::refresh()
{
    table->setRowCount(0);
    const QString keyword = searchBar->text().trimmed();

    for (const auto &log : logManager.getLogs()) {
        // Only show Nutrition-derived logs (skip Workout entries)
        Nutrition *n = dynamic_cast<Nutrition *>(log.get());
        if (!n) continue;

        if (!keyword.isEmpty()) {
            QString desc = QString::fromStdString(n->getDescription());
            if (!desc.contains(keyword, Qt::CaseInsensitive)) continue;
        }

        int row = table->rowCount();
        table->insertRow(row);

        auto cell = [&](int col, const QString &text) {
            auto *item = new QTableWidgetItem(text);
            item->setTextAlignment(Qt::AlignCenter);
            table->setItem(row, col, item);
        };

        // Convert the MealType enum to a readable string
        QString mealStr;
        switch (n->getMealType()) {
            case MealType::Breakfast: mealStr = "Breakfast"; break;
            case MealType::Lunch:     mealStr = "Lunch";     break;
            case MealType::Dinner:    mealStr = "Dinner";    break;
            case MealType::Snack:     mealStr = "Snack";     break;
        }

        cell(0, QString::fromStdString(n->getLogID()));
        cell(1, n->getDate().toString("yyyy-MM-dd"));
        cell(2, QString::fromStdString(n->getDescription()));
        cell(3, mealStr);
        cell(4, QString::number(n->getCaloriesConsumed(), 'f', 0) + " kcal");
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
    if (QMessageBox::question(this, "Confirm", "Delete entry " + id + "?") == QMessageBox::Yes) {
        logManager.deleteLog(id.toStdString());
        refresh();
    }
}

void NutritionTab::onAdd()
{
    QDialog dlg(this);
    dlg.setWindowTitle("Add Meal");
    dlg.setFixedWidth(360);

    auto *form = new QFormLayout(&dlg);
    form->setSpacing(10);
    form->setContentsMargins(20, 20, 20, 20);

    auto *descEdit  = new QLineEdit;
    descEdit->setPlaceholderText("e.g. Oatmeal with fruit");

    auto *dateEdit  = new QDateTimeEdit(QDateTime::currentDateTime());
    dateEdit->setDisplayFormat("yyyy-MM-dd HH:mm");

    auto *mealCombo = new QComboBox;
    mealCombo->addItems({"Breakfast", "Lunch", "Dinner", "Snack"});

    auto *calSpin   = new QDoubleSpinBox;
    calSpin->setRange(0, 10000);
    calSpin->setSuffix(" kcal");

    auto *durSpin   = new QDoubleSpinBox;
    durSpin->setRange(0, 120);
    durSpin->setSuffix(" min");
    durSpin->setToolTip("Duration of the meal sitting (optional)");

    form->addRow("Description",       descEdit);
    form->addRow("Date / Time",       dateEdit);
    form->addRow("Meal Type",         mealCombo);
    form->addRow("Calories Consumed", calSpin);
    form->addRow("Duration",          durSpin);

    auto *buttons = new QDialogButtonBox(QDialogButtonBox::Ok | QDialogButtonBox::Cancel);
    connect(buttons, &QDialogButtonBox::accepted, &dlg, &QDialog::accept);
    connect(buttons, &QDialogButtonBox::rejected, &dlg, &QDialog::reject);
    form->addRow(buttons);

    if (dlg.exec() != QDialog::Accepted) return;

    if (descEdit->text().trimmed().isEmpty()) {
        QMessageBox::warning(this, "Validation", "Description cannot be empty.");
        return;
    }

    // Map combo index back to the MealType enum
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
            calSpin->value()));
        refresh();
    } catch (const std::exception &e) {
        QMessageBox::critical(this, "Error", e.what());
    }
}
