// WorkoutsTab.cpp
// Table of all workouts + Add / Edit / Delete + live search + type & date filters.
//
// Filter architecture
// ───────────────────
// Three independent filters are ANDed together in refresh():
//   1. Description keyword  →  plain string::find  (client-side, no helper needed)
//   2. Workout type         →  LogManager::filterByType()  returns vector<Log*>
//   3. Date range           →  LogManager::filterByDate()  returns vector<Log*>
//
// When multiple filters are active we intersect the three result sets so only
// rows that pass every active filter appear in the table.

#include "WorkoutsTab.h"
#include "Workouts/CardioWorkout.h"
#include "Workouts/StrengthWorkout.h"
#include "Workouts/YogaWorkout.h"

#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QGridLayout>
#include <QHeaderView>
#include <QLabel>
#include <QFrame>
#include <QDialog>
#include <QFormLayout>
#include <QComboBox>
#include <QDoubleSpinBox>
#include <QSpinBox>
#include <QDateEdit>
#include <QDateTimeEdit>
#include <QDialogButtonBox>
#include <QMessageBox>
#include <QCheckBox>
#include <QUuid>
#include <unordered_set>

// ── Helper: generate a short unique 6-char log ID ────────────────────────────
static std::string newID()
{
    return QUuid::createUuid().toString(QUuid::WithoutBraces).left(6).toStdString();
}

// ─────────────────────────────────────────────────────────────────────────────
WorkoutsTab::WorkoutsTab(LogManager &lm, QWidget *parent)
    : QWidget(parent), logManager(lm)
{
    setupUI();
}

// ── setupUI ───────────────────────────────────────────────────────────────────
void WorkoutsTab::setupUI()
{
    auto *root = new QVBoxLayout(this);
    root->setContentsMargins(20, 20, 20, 16);
    root->setSpacing(10);

    // ── Row 1: Heading + description search ───────────────────────────────────
    auto *topRow = new QHBoxLayout;

    auto *heading = new QLabel("WORKOUT LOG");
    heading->setObjectName("heading");
    topRow->addWidget(heading);
    topRow->addStretch();

    searchBar = new QLineEdit;
    searchBar->setPlaceholderText("Search description...");
    searchBar->setFixedWidth(220);
    // Any change to the search bar immediately re-runs the filter
    connect(searchBar, &QLineEdit::textChanged, this, &WorkoutsTab::refresh);
    topRow->addWidget(searchBar);

    root->addLayout(topRow);

    // ── Separator ─────────────────────────────────────────────────────────────
    auto *sep1 = new QFrame;
    sep1->setFrameShape(QFrame::HLine);
    sep1->setStyleSheet("color:#333;");
    root->addWidget(sep1);

    // ── Row 2: Filter bar ─────────────────────────────────────────────────────
    // Layout: [Type label] [combo] [spacing] [checkbox] [From label] [date] [To label] [date] [Apply] [Clear]
    auto *filterRow = new QHBoxLayout;
    filterRow->setSpacing(8);

    // Type filter
    auto *typeLabel = new QLabel("Type:");
    typeLabel->setStyleSheet("color:#aaa; font-size:12px;");
    filterRow->addWidget(typeLabel);

    typeFilter = new QComboBox;
    typeFilter->addItems({"All Types", "Cardio", "Strength", "Yoga"});
    typeFilter->setFixedWidth(120);
    // Changing the combo immediately re-filters
    connect(typeFilter, QOverload<int>::of(&QComboBox::currentIndexChanged),
            this, &WorkoutsTab::refresh);
    filterRow->addWidget(typeFilter);

    filterRow->addSpacing(16);

    // Date range enable checkbox
    useDateFilter = new QCheckBox("Date Range:");
    useDateFilter->setStyleSheet("color:#aaa; font-size:12px;");
    connect(useDateFilter, &QCheckBox::toggled, this, [this](bool checked) {
        // Enable/disable the date pickers depending on the checkbox state
        fromDate->setEnabled(checked);
        toDate->setEnabled(checked);
        refresh();
    });
    filterRow->addWidget(useDateFilter);

    // "From" date picker
    fromDate = new QDateEdit(QDate::currentDate().addMonths(-1));
    fromDate->setDisplayFormat("yyyy-MM-dd");
    fromDate->setCalendarPopup(true);
    fromDate->setEnabled(false); // disabled until checkbox is ticked
    fromDate->setFixedWidth(110);
    connect(fromDate, &QDateEdit::dateChanged, this, &WorkoutsTab::refresh);
    filterRow->addWidget(fromDate);

    auto *toLabel = new QLabel("→");
    toLabel->setStyleSheet("color:#aaa;");
    filterRow->addWidget(toLabel);

    // "To" date picker
    toDate = new QDateEdit(QDate::currentDate());
    toDate->setDisplayFormat("yyyy-MM-dd");
    toDate->setCalendarPopup(true);
    toDate->setEnabled(false);
    toDate->setFixedWidth(110);
    connect(toDate, &QDateEdit::dateChanged, this, &WorkoutsTab::refresh);
    filterRow->addWidget(toDate);

    filterRow->addSpacing(8);

    // Clear-filters button resets every control to its default state
    auto *clearBtn = new QPushButton("Clear Filters");
    clearBtn->setFixedWidth(100);
    clearBtn->setStyleSheet(
        "QPushButton { background:#2d2d2d; color:#aaa; border:1px solid #444;"
        "              border-radius:4px; padding:5px 10px; font-size:12px; }"
        "QPushButton:hover { background:#3a3a3a; color:#ddd; }");
    connect(clearBtn, &QPushButton::clicked, this, [this]() {
        // Block signals while resetting so we don't trigger multiple refreshes
        searchBar->blockSignals(true);
        typeFilter->blockSignals(true);
        useDateFilter->blockSignals(true);
        fromDate->blockSignals(true);
        toDate->blockSignals(true);

        searchBar->clear();
        typeFilter->setCurrentIndex(0);
        useDateFilter->setChecked(false);
        fromDate->setDate(QDate::currentDate().addMonths(-1));
        toDate->setDate(QDate::currentDate());
        fromDate->setEnabled(false);
        toDate->setEnabled(false);

        searchBar->blockSignals(false);
        typeFilter->blockSignals(false);
        useDateFilter->blockSignals(false);
        fromDate->blockSignals(false);
        toDate->blockSignals(false);

        refresh(); // single refresh after all resets
    });
    filterRow->addWidget(clearBtn);

    filterRow->addStretch();
    root->addLayout(filterRow);

    // ── Separator ─────────────────────────────────────────────────────────────
    auto *sep2 = new QFrame;
    sep2->setFrameShape(QFrame::HLine);
    sep2->setStyleSheet("color:#333;");
    root->addWidget(sep2);

    // ── Table ─────────────────────────────────────────────────────────────────
    // Columns: ID | Date | Description | Duration | Type | Calories | Details
    table = new QTableWidget(0, 7, this);
    table->setHorizontalHeaderLabels({
        "ID", "Date", "Description", "Duration", "Type", "Calories", "Details"
    });
    table->horizontalHeader()->setSectionResizeMode(QHeaderView::Stretch);
    table->horizontalHeader()->setSectionResizeMode(0, QHeaderView::ResizeToContents);
    table->setSelectionBehavior(QAbstractItemView::SelectRows);
    table->setEditTriggers(QAbstractItemView::NoEditTriggers);
    table->setAlternatingRowColors(true);
    table->verticalHeader()->setVisible(false);
    table->setShowGrid(false);
    root->addWidget(table);

    // ── Action buttons (bottom-right) ─────────────────────────────────────────
    auto *btnRow = new QHBoxLayout;
    btnRow->addStretch();

    addBtn = new QPushButton("+ Add Workout");
    connect(addBtn, &QPushButton::clicked, this, &WorkoutsTab::onAdd);
    btnRow->addWidget(addBtn);

    // Edit button — only meaningful when a row is selected
    editBtn = new QPushButton("Edit");
    connect(editBtn, &QPushButton::clicked, this, &WorkoutsTab::onEdit);
    btnRow->addWidget(editBtn);

    deleteBtn = new QPushButton("Delete");
    deleteBtn->setObjectName("danger");
    connect(deleteBtn, &QPushButton::clicked, this, &WorkoutsTab::onDelete);
    btnRow->addWidget(deleteBtn);

    root->addLayout(btnRow);

    refresh();
}

// ── refresh ───────────────────────────────────────────────────────────────────
// Applies all three filters (keyword, type, date) and repopulates the table.
//
// Strategy:
//   • Start with the full log list from LogManager.
//   • If the type filter is active, ask LogManager for the matching subset and
//     build a set of their IDs — then skip rows whose ID isn't in the set.
//   • Same approach for the date filter.
//   • The keyword filter is applied directly on the description string.
//
// This keeps the filtering logic in LogManager where it belongs, and lets the
// UI just drive when to call it and how to display the results.
void WorkoutsTab::refresh()
{
    table->setRowCount(0);

    const QString keyword = searchBar->text().trimmed();

    // ── Build optional filter sets ────────────────────────────────────────────

    // Type filter: non-zero index means a specific type is chosen
    bool typeActive = (typeFilter->currentIndex() != 0);
    std::unordered_set<std::string> typeSet;
    if (typeActive) {
        // Map combo text to the string key expected by LogManager::filterByType
        // filterByType checks for "Workout" or "Nutrition"; for sub-types we
        // match by WorkoutType enum via dynamic_cast below instead.
        // We collect the IDs from the filtered vector.
        QString chosen = typeFilter->currentText(); // "Cardio" | "Strength" | "Yoga"
        // filterByType("Workout") gives all workouts; we then sub-filter by subtype
        auto workouts = logManager.filterByType("Workout");
        for (Log *l : workouts) {
            if (auto *w = dynamic_cast<Workout *>(l)) {
                QString wType;
                if      (dynamic_cast<CardioWorkout   *>(w)) wType = "Cardio";
                else if (dynamic_cast<StrengthWorkout *>(w)) wType = "Strength";
                else if (dynamic_cast<YogaWorkout     *>(w)) wType = "Yoga";

                if (wType == chosen)
                    typeSet.insert(w->getLogID());
            }
        }
    }

    // Date-range filter: only active when checkbox is ticked
    bool dateActive = useDateFilter->isChecked();
    std::unordered_set<std::string> dateSet;
    if (dateActive) {
        // LogManager::filterByDate expects "yyyy-MM-dd hh:mm" formatted strings.
        // We give midnight for start and end-of-day for finish.
        std::string start = fromDate->date().toString("yyyy-MM-dd").toStdString() + " 00:00";
        std::string end   = toDate->date().toString("yyyy-MM-dd").toStdString()   + " 23:59";
        auto inRange = logManager.filterByDate(start, end);
        for (Log *l : inRange)
            dateSet.insert(l->getLogID());
    }

    // ── Populate table ────────────────────────────────────────────────────────
    for (const auto &log : logManager.getLogs()) {
        // Only show Workout-derived entries
        Workout *w = dynamic_cast<Workout *>(log.get());
        if (!w) continue;

        const std::string &id = w->getLogID();

        // 1. Type filter
        if (typeActive && typeSet.find(id) == typeSet.end()) continue;

        // 2. Date filter
        if (dateActive && dateSet.find(id) == dateSet.end()) continue;

        // 3. Keyword filter (case-insensitive)
        if (!keyword.isEmpty()) {
            QString desc = QString::fromStdString(w->getDescription());
            if (!desc.contains(keyword, Qt::CaseInsensitive)) continue;
        }

        // ── Insert a row ──────────────────────────────────────────────────────
        int row = table->rowCount();
        table->insertRow(row);

        auto cell = [&](int col, const QString &text) {
            auto *item = new QTableWidgetItem(text);
            item->setTextAlignment(Qt::AlignCenter);
            table->setItem(row, col, item);
        };

        cell(0, QString::fromStdString(id));
        cell(1, w->getDate().toString("yyyy-MM-dd"));
        cell(2, QString::fromStdString(w->getDescription()));
        cell(3, QString::number(w->getDuration(), 'f', 0) + " min");
        cell(5, QString::number(w->getCaloriesBurned(), 'f', 0) + " kcal");

        if (auto *c = dynamic_cast<CardioWorkout *>(w)) {
            cell(4, "Cardio");
            if (c->getCardioType() == CardioType::Distance)
                cell(6, QString::number(c->getDistance(), 'f', 1) + " km  |  "
                            + QString::number(c->getPace(), 'f', 1) + " min/km");
            else
                cell(6, QString::number(c->getSets()) + " sets  x  "
                            + QString::number(c->getReps()) + " reps");

        } else if (auto *s = dynamic_cast<StrengthWorkout *>(w)) {
            cell(4, "Strength");
            cell(6, QString::number(s->getSets()) + "x" + QString::number(s->getReps())
                        + "  @  " + QString::number(s->getWeight(), 'f', 1) + " kg");

        } else if (auto *y = dynamic_cast<YogaWorkout *>(w)) {
            cell(4, "Yoga");
            cell(6, QString::fromStdString(y->getStyle()) + "  /  "
                        + QString::fromStdString(y->getIntensity()));
        }
    }
}

// ── onDelete ─────────────────────────────────────────────────────────────────
void WorkoutsTab::onDelete()
{
    int row = table->currentRow();
    if (row < 0) {
        QMessageBox::information(this, "Delete", "Please select a row first.");
        return;
    }

    QString id = table->item(row, 0)->text();
    if (QMessageBox::question(this, "Confirm", "Delete workout " + id + "?")
        == QMessageBox::Yes)
    {
        logManager.deleteLog(id.toStdString());
        refresh();
    }
}

// ── onEdit ────────────────────────────────────────────────────────────────────
// Opens a pre-filled dialog for the selected workout.
// Only the fields that are common to all workouts (date, duration, description,
// calories) are editable here; type-specific fields (distance, weight, etc.)
// are also shown and editable based on the subtype.
//
// The actual mutation is done via the existing setters on the concrete object —
// we don't re-create the object, which preserves its position in the log list
// and avoids changing the log ID.
void WorkoutsTab::onEdit()
{
    int row = table->currentRow();
    if (row < 0) {
        QMessageBox::information(this, "Edit", "Please select a row first.");
        return;
    }

    // Retrieve the log ID from column 0, then find the object in LogManager
    std::string id = table->item(row, 0)->text().toStdString();

    // We search manually because LogManager doesn't expose a findByID helper
    Workout *target = nullptr;
    for (const auto &log : logManager.getLogs()) {
        if (log->getLogID() == id) {
            target = dynamic_cast<Workout *>(log.get());
            break;
        }
    }

    if (!target) {
        QMessageBox::warning(this, "Edit", "Could not locate log ID " +
                                               QString::fromStdString(id));
        return;
    }

    // ── Build the edit dialog ─────────────────────────────────────────────────
    QDialog dlg(this);
    dlg.setWindowTitle("Edit Workout  [" + QString::fromStdString(id) + "]");
    dlg.setFixedWidth(420);

    auto *form = new QFormLayout(&dlg);
    form->setSpacing(10);
    form->setContentsMargins(20, 20, 20, 20);

    // Common fields — pre-filled with current values
    auto *descEdit = new QLineEdit(QString::fromStdString(target->getDescription()));
    descEdit->setMaxLength(100);

    auto *dateEdit = new QDateTimeEdit(target->getDate());
    dateEdit->setDisplayFormat("yyyy-MM-dd HH:mm");
    dateEdit->setCalendarPopup(true);

    auto *durSpin = new QDoubleSpinBox;
    durSpin->setRange(1, 600);
    durSpin->setSuffix(" min");
    durSpin->setValue(target->getDuration());

    auto *calSpin = new QDoubleSpinBox;
    calSpin->setRange(0, 5000);
    calSpin->setSuffix(" kcal");
    calSpin->setValue(target->getCaloriesBurned());

    form->addRow("Description",     descEdit);
    form->addRow("Date / Time",     dateEdit);
    form->addRow("Duration",        durSpin);
    form->addRow("Calories Burned", calSpin);

    // ── Subtype-specific fields ───────────────────────────────────────────────
    // We detect the concrete subtype and add only the relevant fields.

    // Cardio – Distance
    QDoubleSpinBox *distSpin = nullptr;
    QDoubleSpinBox *paceSpin = nullptr;
    // Cardio – RepBased / Strength
    QSpinBox       *setsSpin = nullptr;
    QSpinBox       *repsSpin = nullptr;
    // Strength
    QDoubleSpinBox *wgtSpin  = nullptr;
    // Yoga
    QLineEdit      *styleEdit = nullptr;
    QLineEdit      *intEdit   = nullptr;

    if (auto *c = dynamic_cast<CardioWorkout *>(target)) {
        if (c->getCardioType() == CardioType::Distance) {
            distSpin = new QDoubleSpinBox; distSpin->setRange(0, 500);
            distSpin->setSuffix(" km"); distSpin->setValue(c->getDistance());
            paceSpin = new QDoubleSpinBox; paceSpin->setRange(0, 60);
            paceSpin->setSuffix(" min/km"); paceSpin->setValue(c->getPace());
            form->addRow("Distance", distSpin);
            form->addRow("Pace",     paceSpin);
        } else {
            setsSpin = new QSpinBox; setsSpin->setRange(1, 100);
            setsSpin->setValue(c->getSets());
            repsSpin = new QSpinBox; repsSpin->setRange(1, 200);
            repsSpin->setValue(c->getReps());
            form->addRow("Sets", setsSpin);
            form->addRow("Reps", repsSpin);
        }
    } else if (auto *s = dynamic_cast<StrengthWorkout *>(target)) {
        setsSpin = new QSpinBox; setsSpin->setRange(1, 100);
        setsSpin->setValue(s->getSets());
        repsSpin = new QSpinBox; repsSpin->setRange(1, 200);
        repsSpin->setValue(s->getReps());
        wgtSpin  = new QDoubleSpinBox; wgtSpin->setRange(0, 500);
        wgtSpin->setSuffix(" kg"); wgtSpin->setValue(s->getWeight());
        form->addRow("Sets",        setsSpin);
        form->addRow("Reps",        repsSpin);
        form->addRow("Weight",      wgtSpin);
    } else if (auto *y = dynamic_cast<YogaWorkout *>(target)) {
        styleEdit = new QLineEdit(QString::fromStdString(y->getStyle()));
        intEdit   = new QLineEdit(QString::fromStdString(y->getIntensity()));
        form->addRow("Style",     styleEdit);
        form->addRow("Intensity", intEdit);
    }

    // ── Buttons ───────────────────────────────────────────────────────────────
    auto *buttons = new QDialogButtonBox(QDialogButtonBox::Save |
                                         QDialogButtonBox::Cancel);
    connect(buttons, &QDialogButtonBox::accepted, &dlg, &QDialog::accept);
    connect(buttons, &QDialogButtonBox::rejected, &dlg, &QDialog::reject);
    form->addRow(buttons);

    if (dlg.exec() != QDialog::Accepted) return;

    // ── Validate ──────────────────────────────────────────────────────────────
    if (descEdit->text().trimmed().isEmpty()) {
        QMessageBox::warning(this, "Validation", "Description cannot be empty.");
        return;
    }
    if (durSpin->value() <= 0) {
        QMessageBox::warning(this, "Validation", "Duration must be greater than zero.");
        return;
    }

    // ── Apply changes via setters (no re-creation needed) ─────────────────────
    // Setters are defined in the base Workout/Log classes and all subclasses.
    target->setDescription(descEdit->text().trimmed().toStdString());
    target->setDate(dateEdit->dateTime());
    target->setDuration(durSpin->value());
    target->setCaloriesBurned(calSpin->value());

    // Apply subtype-specific changes
    if (auto *c = dynamic_cast<CardioWorkout *>(target)) {
        if (c->getCardioType() == CardioType::Distance) {
            if (distSpin) c->setDistance(distSpin->value());
            if (paceSpin) c->setPace(paceSpin->value());
        } else {
            if (setsSpin) c->setSets(setsSpin->value());
            if (repsSpin) c->setReps(repsSpin->value());
        }
    } else if (auto *s = dynamic_cast<StrengthWorkout *>(target)) {
        if (setsSpin) s->setSets(setsSpin->value());
        if (repsSpin) s->setReps(repsSpin->value());
        if (wgtSpin)  s->setWeight(wgtSpin->value());
    } else if (auto *y = dynamic_cast<YogaWorkout *>(target)) {
        if (styleEdit) y->setStyle(styleEdit->text().toStdString());
        if (intEdit)   y->setIntensity(intEdit->text().toStdString());
    }

    refresh(); // repaint the table to show updated values
}

// ── onAdd ─────────────────────────────────────────────────────────────────────
// Dialog shows different fields depending on the selected workout type.
// Only the relevant fields are visible at any time (show/hide on combo change).
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
    descEdit->setMaxLength(100);

    auto *dateEdit = new QDateTimeEdit(QDateTime::currentDateTime());
    dateEdit->setDisplayFormat("yyyy-MM-dd HH:mm");
    dateEdit->setCalendarPopup(true);

    auto *durSpin = new QDoubleSpinBox;
    durSpin->setRange(1, 600);
    durSpin->setSuffix(" min");

    auto *calSpin = new QDoubleSpinBox;
    calSpin->setRange(0, 5000);
    calSpin->setSuffix(" kcal");

    form->addRow("Type",            typeCombo);
    form->addRow("Description",     descEdit);
    form->addRow("Date / Time",     dateEdit);
    form->addRow("Duration",        durSpin);
    form->addRow("Calories Burned", calSpin);

    // ── Type-specific fields ──────────────────────────────────────────────────

    // Cardio – Distance
    auto *distLabel = new QLabel("Distance (km)");
    auto *distSpin  = new QDoubleSpinBox; distSpin->setRange(0, 500);
    auto *paceLabel = new QLabel("Pace (min/km)");
    auto *paceSpin  = new QDoubleSpinBox; paceSpin->setRange(0, 60);
    form->addRow(distLabel, distSpin);
    form->addRow(paceLabel, paceSpin);

    // Cardio – Reps and Strength
    auto *setsLabel = new QLabel("Sets");
    auto *setsSpin  = new QSpinBox; setsSpin->setRange(1, 100);
    auto *repsLabel = new QLabel("Reps");
    auto *repsSpin  = new QSpinBox; repsSpin->setRange(1, 200);
    form->addRow(setsLabel, setsSpin);
    form->addRow(repsLabel, repsSpin);

    // Strength only
    auto *wgtLabel = new QLabel("Weight (kg)");
    auto *wgtSpin  = new QDoubleSpinBox; wgtSpin->setRange(0, 500);
    form->addRow(wgtLabel, wgtSpin);

    // Yoga only
    auto *styleLabel = new QLabel("Style");
    auto *styleEdit  = new QLineEdit; styleEdit->setPlaceholderText("e.g. Vinyasa");
    auto *intLabel   = new QLabel("Intensity");
    auto *intEdit    = new QLineEdit; intEdit->setPlaceholderText("e.g. Moderate");
    form->addRow(styleLabel, styleEdit);
    form->addRow(intLabel,   intEdit);

    // Show/hide fields based on selected type
    auto updateFields = [&](int idx) {
        bool dist     = (idx == 0);
        bool rep      = (idx == 1);
        bool strength = (idx == 2);
        bool yoga     = (idx == 3);

        distLabel->setVisible(dist);    distSpin->setVisible(dist);
        paceLabel->setVisible(dist);    paceSpin->setVisible(dist);
        setsLabel->setVisible(rep || strength); setsSpin->setVisible(rep || strength);
        repsLabel->setVisible(rep || strength); repsSpin->setVisible(rep || strength);
        wgtLabel->setVisible(strength); wgtSpin->setVisible(strength);
        styleLabel->setVisible(yoga);   styleEdit->setVisible(yoga);
        intLabel->setVisible(yoga);     intEdit->setVisible(yoga);

        dlg.adjustSize();
    };

    connect(typeCombo, QOverload<int>::of(&QComboBox::currentIndexChanged), updateFields);
    updateFields(0);

    // ── OK / Cancel ───────────────────────────────────────────────────────────
    auto *buttons = new QDialogButtonBox(QDialogButtonBox::Ok |
                                         QDialogButtonBox::Cancel);
    connect(buttons, &QDialogButtonBox::accepted, &dlg, &QDialog::accept);
    connect(buttons, &QDialogButtonBox::rejected, &dlg, &QDialog::reject);
    form->addRow(buttons);

    if (dlg.exec() != QDialog::Accepted) return;

    // ── Validation ────────────────────────────────────────────────────────────
    if (descEdit->text().trimmed().isEmpty()) {
        QMessageBox::warning(this, "Validation", "Description cannot be empty.");
        return;
    }
    if (durSpin->value() <= 0) {
        QMessageBox::warning(this, "Validation", "Duration must be positive.");
        return;
    }

    // ── Build the concrete subtype and hand it to LogManager ─────────────────
    std::string id   = newID();
    std::string desc = descEdit->text().trimmed().toStdString();
    QDateTime   date = dateEdit->dateTime();
    double      dur  = durSpin->value();
    double      cal  = calSpin->value();
    int         type = typeCombo->currentIndex();

    try {
        if (type == 0) {
            logManager.addLog(std::make_unique<CardioWorkout>(
                id, date, desc, dur, cal,
                distSpin->value(), paceSpin->value(), CardioType::Distance));

        } else if (type == 1) {
            logManager.addLog(std::make_unique<CardioWorkout>(
                id, date, desc, dur, cal,
                setsSpin->value(), repsSpin->value(), CardioType::RepBased));

        } else if (type == 2) {
            logManager.addLog(std::make_unique<StrengthWorkout>(
                id, date, desc, dur, cal,
                setsSpin->value(), repsSpin->value(), wgtSpin->value()));

        } else {
            logManager.addLog(std::make_unique<YogaWorkout>(
                id, date, desc, dur, cal,
                styleEdit->text().toStdString(), intEdit->text().toStdString()));
        }

        refresh();

    } catch (const std::exception &e) {
        QMessageBox::critical(this, "Error", e.what());
    }
}
