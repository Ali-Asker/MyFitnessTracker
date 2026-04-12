// WorkoutsTab.cpp
// Table of all workouts + Add / Delete buttons + live search.

#include "WorkoutsTab.h"
#include "Workouts/CardioWorkout.h"
#include "Workouts/StrengthWorkout.h"
#include "Workouts/YogaWorkout.h"

#include <QComboBox>
#include <QDateTimeEdit>
#include <QDialog>
#include <QDialogButtonBox>
#include <QDoubleSpinBox>
#include <QFormLayout>
#include <QFrame>
#include <QHBoxLayout>
#include <QHeaderView>
#include <QLabel>
#include <QMessageBox>
#include <QSpinBox>
#include <QUuid>
#include <QVBoxLayout>

// ── Helper: generate a short unique 6-char log ID ────────────────────────────
static std::string newID()
{
    return QUuid::createUuid().toString(QUuid::WithoutBraces).left(6).toStdString();
}

WorkoutsTab::WorkoutsTab(LogManager &lm, QWidget *parent)
    : QWidget(parent)
    , logManager(lm)
{
    setupUI();
}

void WorkoutsTab::setupUI()
{
    auto *root = new QVBoxLayout(this);
    root->setContentsMargins(20, 20, 20, 16);
    root->setSpacing(12);

    // ── Heading + search bar on the same row ──────────────────────────────────
    auto *topRow = new QHBoxLayout;

    auto *heading = new QLabel("WORKOUT LOG");
    heading->setObjectName("heading");
    topRow->addWidget(heading);
    topRow->addStretch();

    // Search filters the table in real-time as the user types
    searchBar = new QLineEdit;
    searchBar->setPlaceholderText("Search description...");
    searchBar->setFixedWidth(240);
    connect(searchBar, &QLineEdit::textChanged, this, &WorkoutsTab::refresh);
    topRow->addWidget(searchBar);

    root->addLayout(topRow);

    // Thin separator line under the heading
    auto *sep = new QFrame;
    sep->setFrameShape(QFrame::HLine);
    sep->setStyleSheet("color:#333;");
    root->addWidget(sep);

    // ── Table ─────────────────────────────────────────────────────────────────
    // Columns: ID | Date | Description | Duration | Type | Calories | Extra info
    table = new QTableWidget(0, 7, this);
    table->setHorizontalHeaderLabels(
        {"ID", "Date", "Description", "Duration", "Type", "Calories", "Details"});
    table->horizontalHeader()->setSectionResizeMode(QHeaderView::Stretch);
    table->horizontalHeader()->setSectionResizeMode(0, QHeaderView::ResizeToContents);
    table->setSelectionBehavior(QAbstractItemView::SelectRows); // whole row selected
    table->setEditTriggers(QAbstractItemView::NoEditTriggers);  // read-only
    table->setAlternatingRowColors(true);
    table->verticalHeader()->setVisible(false);
    table->setShowGrid(false);
    root->addWidget(table);

    // ── Add / Delete buttons (bottom-right) ───────────────────────────────────
    auto *btnRow = new QHBoxLayout;
    btnRow->addStretch();

    addBtn = new QPushButton("+ Add Workout");
    connect(addBtn, &QPushButton::clicked, this, &WorkoutsTab::onAdd);
    btnRow->addWidget(addBtn);

    deleteBtn = new QPushButton("Delete");
    deleteBtn->setObjectName("danger"); // red style from stylesheet
    connect(deleteBtn, &QPushButton::clicked, this, &WorkoutsTab::onDelete);
    btnRow->addWidget(deleteBtn);

    root->addLayout(btnRow);

    refresh();
}

// ── Repopulate the table ──────────────────────────────────────────────────────
void WorkoutsTab::refresh()
{
    table->setRowCount(0);

    const QString keyword = searchBar->text().trimmed();

    for (const auto &log : logManager.getLogs()) {
        // Only show Workout-derived logs (skip Nutrition entries)
        Workout *w = dynamic_cast<Workout *>(log.get());
        if (!w)
            continue;

        // Filter by keyword if one is entered
        if (!keyword.isEmpty()) {
            QString desc = QString::fromStdString(w->getDescription());
            if (!desc.contains(keyword, Qt::CaseInsensitive))
                continue;
        }

        int row = table->rowCount();
        table->insertRow(row);

        // Helper lambda: create a centered, non-editable cell
        auto cell = [&](int col, const QString &text) {
            auto *item = new QTableWidgetItem(text);
            item->setTextAlignment(Qt::AlignCenter);
            table->setItem(row, col, item);
        };

        cell(0, QString::fromStdString(w->getLogID()));
        cell(1, w->getDate().toString("yyyy-MM-dd"));
        cell(2, QString::fromStdString(w->getDescription()));
        cell(3, QString::number(w->getDuration(), 'f', 0) + " min");
        cell(5, QString::number(w->getCaloriesBurned(), 'f', 0) + " kcal");

        // Fill Type and Details columns based on the concrete subtype
        if (auto *c = dynamic_cast<CardioWorkout *>(w)) {
            cell(4, "Cardio");
            if (c->getCardioType() == CardioType::Distance)
                cell(6,
                     QString::number(c->getDistance(), 'f', 1) + " km  |  "
                         + QString::number(c->getPace(), 'f', 1) + " min/km");
            else
                cell(6,
                     QString::number(c->getSets()) + " sets  x  " + QString::number(c->getReps())
                         + " reps");

        } else if (auto *s = dynamic_cast<StrengthWorkout *>(w)) {
            cell(4, "Strength");
            cell(6,
                 QString::number(s->getSets()) + "x" + QString::number(s->getReps()) + "  @  "
                     + QString::number(s->getWeight(), 'f', 1) + " kg");

        } else if (auto *y = dynamic_cast<YogaWorkout *>(w)) {
            cell(4, "Yoga");
            cell(6,
                 QString::fromStdString(y->getStyle()) + "  /  "
                     + QString::fromStdString(y->getIntensity()));
        }
    }
}

// ── Delete selected row ───────────────────────────────────────────────────────
void WorkoutsTab::onDelete()
{
    int row = table->currentRow();
    if (row < 0) {
        QMessageBox::information(this, "Delete", "Please select a row first.");
        return;
    }

    QString id = table->item(row, 0)->text();
    auto btn = QMessageBox::question(this, "Confirm", "Delete workout " + id + "?");
    if (btn == QMessageBox::Yes) {
        logManager.deleteLog(id.toStdString());
        refresh();
    }
}

// ── Add workout dialog ────────────────────────────────────────────────────────
// The dialog shows different fields depending on the selected workout type.
// Only the relevant fields are visible at any time.
void WorkoutsTab::onAdd()
{
    QDialog dlg(this);
    dlg.setWindowTitle("Add Workout");
    dlg.setFixedWidth(400);

    auto *form = new QFormLayout(&dlg);
    form->setSpacing(10);
    form->setContentsMargins(20, 20, 20, 20);

    // ── Common fields ─────────────────────────────────────────────────────────
    auto *typeCombo = new QComboBox;
    typeCombo->addItems({"Cardio – Distance", "Cardio – Reps", "Strength", "Yoga"});

    auto *descEdit = new QLineEdit;
    descEdit->setPlaceholderText("e.g. Morning run");

    auto *dateEdit = new QDateTimeEdit(QDateTime::currentDateTime());
    dateEdit->setDisplayFormat("yyyy-MM-dd HH:mm");

    auto *durSpin = new QDoubleSpinBox;
    durSpin->setRange(1, 600);
    durSpin->setSuffix(" min");

    auto *calSpin = new QDoubleSpinBox;
    calSpin->setRange(0, 5000);
    calSpin->setSuffix(" kcal");

    form->addRow("Type", typeCombo);
    form->addRow("Description", descEdit);
    form->addRow("Date / Time", dateEdit);
    form->addRow("Duration", durSpin);
    form->addRow("Calories Burned", calSpin);

    // ── Type-specific fields ──────────────────────────────────────────────────
    // Cardio Distance
    auto *distLabel = new QLabel("Distance (km)");
    auto *distSpin = new QDoubleSpinBox;
    distSpin->setRange(0, 500);
    auto *paceLabel = new QLabel("Pace (min/km)");
    auto *paceSpin = new QDoubleSpinBox;
    paceSpin->setRange(0, 60);
    form->addRow(distLabel, distSpin);
    form->addRow(paceLabel, paceSpin);

    // Cardio Reps / Strength (shared sets + reps)
    auto *setsLabel = new QLabel("Sets");
    auto *setsSpin = new QSpinBox;
    setsSpin->setRange(1, 100);
    auto *repsLabel = new QLabel("Reps");
    auto *repsSpin = new QSpinBox;
    repsSpin->setRange(1, 200);
    form->addRow(setsLabel, setsSpin);
    form->addRow(repsLabel, repsSpin);

    // Strength only
    auto *wgtLabel = new QLabel("Weight (kg)");
    auto *wgtSpin = new QDoubleSpinBox;
    wgtSpin->setRange(0, 500);
    form->addRow(wgtLabel, wgtSpin);

    // Yoga only
    auto *styleLabel = new QLabel("Style");
    auto *styleEdit = new QLineEdit;
    styleEdit->setPlaceholderText("e.g. Vinyasa");
    auto *intLabel = new QLabel("Intensity");
    auto *intEdit = new QLineEdit;
    intEdit->setPlaceholderText("e.g. Moderate");
    form->addRow(styleLabel, styleEdit);
    form->addRow(intLabel, intEdit);

    // ── Show/hide fields when the type changes ────────────────────────────────
    auto updateFields = [&](int idx) {
        bool dist = (idx == 0);
        bool rep = (idx == 1);
        bool strength = (idx == 2);
        bool yoga = (idx == 3);

        distLabel->setVisible(dist);
        distSpin->setVisible(dist);
        paceLabel->setVisible(dist);
        paceSpin->setVisible(dist);
        setsLabel->setVisible(rep || strength);
        setsSpin->setVisible(rep || strength);
        repsLabel->setVisible(rep || strength);
        repsSpin->setVisible(rep || strength);
        wgtLabel->setVisible(strength);
        wgtSpin->setVisible(strength);
        styleLabel->setVisible(yoga);
        styleEdit->setVisible(yoga);
        intLabel->setVisible(yoga);
        intEdit->setVisible(yoga);

        dlg.adjustSize();
    };

    connect(typeCombo, QOverload<int>::of(&QComboBox::currentIndexChanged), updateFields);
    updateFields(0); // initialise with first type selected

    // ── OK / Cancel ───────────────────────────────────────────────────────────
    auto *buttons = new QDialogButtonBox(QDialogButtonBox::Ok | QDialogButtonBox::Cancel);
    connect(buttons, &QDialogButtonBox::accepted, &dlg, &QDialog::accept);
    connect(buttons, &QDialogButtonBox::rejected, &dlg, &QDialog::reject);
    form->addRow(buttons);

    if (dlg.exec() != QDialog::Accepted)
        return;

    // ── Basic validation ──────────────────────────────────────────────────────
    if (descEdit->text().trimmed().isEmpty()) {
        QMessageBox::warning(this, "Validation", "Description cannot be empty.");
        return;
    }

    // ── Create the correct subtype and add to LogManager ─────────────────────
    std::string id = newID();
    std::string desc = descEdit->text().trimmed().toStdString();
    QDateTime date = dateEdit->dateTime();
    double dur = durSpin->value();
    double cal = calSpin->value();
    int type = typeCombo->currentIndex();

    try {
        if (type == 0) {
            logManager.addLog(std::make_unique<CardioWorkout>(id,
                                                              date,
                                                              desc,
                                                              dur,
                                                              cal,
                                                              distSpin->value(),
                                                              paceSpin->value(),
                                                              CardioType::Distance));

        } else if (type == 1) {
            logManager.addLog(std::make_unique<CardioWorkout>(id,
                                                              date,
                                                              desc,
                                                              dur,
                                                              cal,
                                                              setsSpin->value(),
                                                              repsSpin->value(),
                                                              CardioType::RepBased));

        } else if (type == 2) {
            logManager.addLog(std::make_unique<StrengthWorkout>(
                id, date, desc, dur, cal, setsSpin->value(), repsSpin->value(), wgtSpin->value()));

        } else {
            logManager.addLog(std::make_unique<YogaWorkout>(id,
                                                            date,
                                                            desc,
                                                            dur,
                                                            cal,
                                                            styleEdit->text().toStdString(),
                                                            intEdit->text().toStdString()));
        }

        refresh();

    } catch (const std::exception &e) {
        QMessageBox::critical(this, "Error", e.what());
    }
}
