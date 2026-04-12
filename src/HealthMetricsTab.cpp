// HealthMetricsTab.cpp
// Table of all health metrics + Add / Edit / Delete
// + live name search + date-range filter.
//
// Filter architecture:
//   1. Name keyword  — client-side string match on metric name
//   2. Date range    — LogManager::filterByDate(), result converted to ID set
// Both are ANDed: a row must pass every active filter to appear.

#include "HealthMetricsTab.h"
#include "HealthMetric.h"

#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QHeaderView>
#include <QLabel>
#include <QFrame>
#include <QDialog>
#include <QFormLayout>
#include <QLineEdit>
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

HealthMetricsTab::HealthMetricsTab(LogManager &lm, QWidget *parent)
    : QWidget(parent), logManager(lm)
{
    setupUI();
}

void HealthMetricsTab::setupUI()
{
    auto *root = new QVBoxLayout(this);
    root->setContentsMargins(20, 20, 20, 16);
    root->setSpacing(10);

    // Row 1: Heading + name search 
    auto *topRow = new QHBoxLayout;

    auto *heading = new QLabel("HEALTH METRICS");
    heading->setObjectName("heading");
    topRow->addWidget(heading);
    topRow->addStretch();

    searchBar = new QLineEdit;
    searchBar->setPlaceholderText("Search metric name...");
    searchBar->setFixedWidth(220);
    connect(searchBar, &QLineEdit::textChanged, this, &HealthMetricsTab::refresh);
    topRow->addWidget(searchBar);
    root->addLayout(topRow);

    auto *sep1 = new QFrame;
    sep1->setFrameShape(QFrame::HLine);
    sep1->setStyleSheet("color:#333;");
    root->addWidget(sep1);

    auto *filterRow = new QHBoxLayout;
    filterRow->setSpacing(8);

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
    connect(fromDate, &QDateEdit::dateChanged, this, &HealthMetricsTab::refresh);
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
    connect(toDate, &QDateEdit::dateChanged, this, &HealthMetricsTab::refresh);
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
        useDateFilter->blockSignals(true);
        fromDate->blockSignals(true);
        toDate->blockSignals(true);

        searchBar->clear();
        useDateFilter->setChecked(false);
        fromDate->setDate(QDate::currentDate().addMonths(-1));
        toDate->setDate(QDate::currentDate());
        fromDate->setEnabled(false);
        toDate->setEnabled(false);

        searchBar->blockSignals(false);
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

    table = new QTableWidget(0, 4, this);
    table->setHorizontalHeaderLabels({"ID", "Metric Name", "Date", "Value"});
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

    addBtn = new QPushButton("+ Add Metric");
    connect(addBtn, &QPushButton::clicked, this, &HealthMetricsTab::onAdd);
    btnRow->addWidget(addBtn);

    editBtn = new QPushButton("Edit");
    connect(editBtn, &QPushButton::clicked, this, &HealthMetricsTab::onEdit);
    btnRow->addWidget(editBtn);

    deleteBtn = new QPushButton("Delete");
    deleteBtn->setObjectName("danger");
    connect(deleteBtn, &QPushButton::clicked, this, &HealthMetricsTab::onDelete);
    btnRow->addWidget(deleteBtn);

    root->addLayout(btnRow);

    refresh();
}

void HealthMetricsTab::refresh()
{
    table->setRowCount(0);

    const QString keyword    = searchBar->text().trimmed();
    const bool    dateActive = useDateFilter->isChecked();

    // Build date-range ID set when active.
    // HealthMetric is NOT a Log subclass so we cannot use LogManager::filterByDate()
    // directly — we apply the date range manually below.
    QDate from = fromDate->date();
    QDate to   = toDate->date();

    for (const auto &m : logManager.getMetrics()) {
        // 1. Date filter
        if (dateActive) {
            QDate metricDate = m->getDate().date();
            if (metricDate < from || metricDate > to) continue;
        }

        // 2. Keyword filter on metric name
        if (!keyword.isEmpty()) {
            QString name = QString::fromStdString(m->getName());
            if (!name.contains(keyword, Qt::CaseInsensitive)) continue;
        }

        int row = table->rowCount();
        table->insertRow(row);

        auto cell = [&](int col, const QString &text) {
            auto *item = new QTableWidgetItem(text);
            item->setTextAlignment(Qt::AlignCenter);
            table->setItem(row, col, item);
        };

        cell(0, QString::fromStdString(m->getMetricID()));
        cell(1, QString::fromStdString(m->getName()));
        cell(2, m->getDate().toString("yyyy-MM-dd"));
        cell(3, QString::number(m->getValue(), 'f', 2));
    }
}

void HealthMetricsTab::onDelete()
{
    int row = table->currentRow();
    if (row < 0) {
        QMessageBox::information(this, "Delete", "Please select a row first.");
        return;
    }
    QString id = table->item(row, 0)->text();
    if (QMessageBox::question(this, "Confirm", "Delete metric " + id + "?")
        == QMessageBox::Yes)
    {
        logManager.deleteMetric(id.toStdString());
        refresh();
    }
}

// Pre-fills from the selected HealthMetric and applies changes via setters.
// HealthMetric has no subclasses so the dialog is always the same shape.
void HealthMetricsTab::onEdit()
{
    int row = table->currentRow();
    if (row < 0) {
        QMessageBox::information(this, "Edit", "Please select a row first.");
        return;
    }

    std::string id = table->item(row, 0)->text().toStdString();

    // Find the metric in LogManager
    HealthMetric *target = nullptr;
    for (const auto &m : logManager.getMetrics()) {
        if (m->getMetricID() == id) {
            target = m.get();
            break;
        }
    }
    if (!target) {
        QMessageBox::warning(this, "Edit", "Could not locate metric " +
                                               QString::fromStdString(id));
        return;
    }

    QDialog dlg(this);
    dlg.setWindowTitle("Edit Metric  [" + QString::fromStdString(id) + "]");
    dlg.setFixedWidth(320);

    auto *form = new QFormLayout(&dlg);
    form->setSpacing(10);
    form->setContentsMargins(20, 20, 20, 20);

    auto *nameEdit = new QLineEdit(QString::fromStdString(target->getName()));
    nameEdit->setPlaceholderText("e.g. Weight, Heart Rate, Body Fat");

    auto *valSpin = new QDoubleSpinBox;
    valSpin->setRange(0.01, 99999);
    valSpin->setDecimals(2);
    valSpin->setValue(target->getValue());

    auto *dateEdit = new QDateTimeEdit(target->getDate());
    dateEdit->setDisplayFormat("yyyy-MM-dd HH:mm");
    dateEdit->setCalendarPopup(true);

    form->addRow("Metric Name", nameEdit);
    form->addRow("Value",       valSpin);
    form->addRow("Date",        dateEdit);

    auto *buttons = new QDialogButtonBox(QDialogButtonBox::Save |
                                         QDialogButtonBox::Cancel);
    connect(buttons, &QDialogButtonBox::accepted, &dlg, &QDialog::accept);
    connect(buttons, &QDialogButtonBox::rejected, &dlg, &QDialog::reject);
    form->addRow(buttons);

    if (dlg.exec() != QDialog::Accepted) return;

    if (nameEdit->text().trimmed().isEmpty()) {
        QMessageBox::warning(this, "Validation", "Metric name cannot be empty.");
        return;
    }
    if (valSpin->value() <= 0) {
        QMessageBox::warning(this, "Validation", "Value must be greater than zero.");
        return;
    }

    target->setName(nameEdit->text().trimmed().toStdString());
    target->setValue(valSpin->value());
    target->setDate(dateEdit->dateTime());

    refresh();
}

void HealthMetricsTab::onAdd()
{
    QDialog dlg(this);
    dlg.setWindowTitle("Add Health Metric");
    dlg.setFixedWidth(320);

    auto *form = new QFormLayout(&dlg);
    form->setSpacing(10);
    form->setContentsMargins(20, 20, 20, 20);

    auto *nameEdit = new QLineEdit;
    nameEdit->setPlaceholderText("e.g. Weight, Heart Rate, Body Fat");

    auto *valSpin = new QDoubleSpinBox;
    valSpin->setRange(0.01, 99999);
    valSpin->setDecimals(2);

    auto *dateEdit = new QDateTimeEdit(QDateTime::currentDateTime());
    dateEdit->setDisplayFormat("yyyy-MM-dd HH:mm");
    dateEdit->setCalendarPopup(true);

    form->addRow("Metric Name", nameEdit);
    form->addRow("Value",       valSpin);
    form->addRow("Date",        dateEdit);

    auto *buttons = new QDialogButtonBox(QDialogButtonBox::Ok |
                                         QDialogButtonBox::Cancel);
    connect(buttons, &QDialogButtonBox::accepted, &dlg, &QDialog::accept);
    connect(buttons, &QDialogButtonBox::rejected, &dlg, &QDialog::reject);
    form->addRow(buttons);

    if (dlg.exec() != QDialog::Accepted) return;

    if (nameEdit->text().trimmed().isEmpty()) {
        QMessageBox::warning(this, "Validation", "Metric name cannot be empty.");
        return;
    }
    if (valSpin->value() <= 0) {
        QMessageBox::warning(this, "Validation", "Value must be greater than zero.");
        return;
    }

    logManager.addMetric(std::make_unique<HealthMetric>(
        newID(),
        nameEdit->text().trimmed().toStdString(),
        dateEdit->dateTime(),
        valSpin->value()));

    refresh();
}