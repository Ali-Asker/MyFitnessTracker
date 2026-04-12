// HealthMetricsTab.h
// Displays all health metric entries in a table.
// Supports:
//   - Live metric name search
//   - Date-range filter (checkbox + From / To pickers)
//   - Add / Edit / Delete actions

#pragma once

#include "LogManager.h"

#include <QWidget>
#include <QTableWidget>
#include <QLineEdit>
#include <QDateEdit>
#include <QPushButton>
#include <QCheckBox>

class HealthMetricsTab : public QWidget
{
    Q_OBJECT

public:
    explicit HealthMetricsTab(LogManager &logManager, QWidget *parent = nullptr);
    // Repopulates the table from the current LogManager state.
    void refresh();

private slots:
    void onAdd();
    void onEdit();
    void onDelete();

private:
    void setupUI();
    LogManager &logManager;
    QTableWidget *table         = nullptr;

    // Search / filter bar
    QLineEdit    *searchBar     = nullptr;   
    QDateEdit    *fromDate      = nullptr;
    QDateEdit    *toDate        = nullptr;
    QCheckBox    *useDateFilter = nullptr;
    // Action buttons
    QPushButton  *addBtn    = nullptr;
    QPushButton  *editBtn   = nullptr;
    QPushButton  *deleteBtn = nullptr;
};