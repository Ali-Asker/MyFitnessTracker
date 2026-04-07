// HealthMetricsTab.h
// Displays all health metric entries (weight, heart rate, etc.) in a table.
// Lets the user add a new metric or delete a selected row.

#pragma once

#include <QWidget>
#include <QTableWidget>
#include <QPushButton>

#include "LogManager.h"

class HealthMetricsTab : public QWidget
{
    Q_OBJECT

public:
    explicit HealthMetricsTab(LogManager &logManager, QWidget *parent = nullptr);

    // Repopulates the table from the current LogManager state.
    void refresh();

private slots:
    void onAdd();    // Opens the "Add Metric" dialog
    void onDelete(); // Deletes the currently selected row

private:
    void setupUI();

    LogManager   &logManager;

    QTableWidget *table;
    QPushButton  *addBtn;
    QPushButton  *deleteBtn;
};
