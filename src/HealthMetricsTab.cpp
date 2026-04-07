// HealthMetricsTab.cpp
// Table of all health metrics + Add / Delete.

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
#include <QDateTimeEdit>
#include <QDialogButtonBox>
#include <QMessageBox>
#include <QUuid>

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
    root->setSpacing(12);

    // ── Heading ───────────────────────────────────────────────────────────────
    auto *heading = new QLabel("HEALTH METRICS");
    heading->setObjectName("heading");
    root->addWidget(heading);

    auto *sep = new QFrame;
    sep->setFrameShape(QFrame::HLine);
    sep->setStyleSheet("color:#333;");
    root->addWidget(sep);

    // ── Table ─────────────────────────────────────────────────────────────────
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

    // ── Buttons ───────────────────────────────────────────────────────────────
    auto *btnRow = new QHBoxLayout;
    btnRow->addStretch();

    addBtn = new QPushButton("+ Add Metric");
    connect(addBtn, &QPushButton::clicked, this, &HealthMetricsTab::onAdd);
    btnRow->addWidget(addBtn);

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

    for (const auto &m : logManager.getMetrics()) {
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
    if (QMessageBox::question(this, "Confirm", "Delete metric " + id + "?") == QMessageBox::Yes) {
        logManager.deleteMetric(id.toStdString());
        refresh();
    }
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

    auto *valSpin  = new QDoubleSpinBox;
    valSpin->setRange(0.01, 99999);
    valSpin->setDecimals(2);

    auto *dateEdit = new QDateTimeEdit(QDateTime::currentDateTime());
    dateEdit->setDisplayFormat("yyyy-MM-dd HH:mm");

    form->addRow("Metric Name", nameEdit);
    form->addRow("Value",       valSpin);
    form->addRow("Date",        dateEdit);

    auto *buttons = new QDialogButtonBox(QDialogButtonBox::Ok | QDialogButtonBox::Cancel);
    connect(buttons, &QDialogButtonBox::accepted, &dlg, &QDialog::accept);
    connect(buttons, &QDialogButtonBox::rejected, &dlg, &QDialog::reject);
    form->addRow(buttons);

    if (dlg.exec() != QDialog::Accepted) return;

    // Validate: name must not be empty and value must be positive
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
