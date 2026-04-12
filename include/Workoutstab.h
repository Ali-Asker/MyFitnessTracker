// WorkoutsTab.h
// Table of all workouts with:
//   - Live description search
//   - Type filter  (All | Cardio | Strength | Yoga)
//   - Date-range filter (From … To)
//   - Add / Edit / Delete actions
//
// Filter logic delegates to LogManager::filterByType() and
// LogManager::filterByDate() so the business logic stays in the manager.

#pragma once

#include "LogManager.h"
#include <QWidget>
#include <QTableWidget>
#include <QLineEdit>
#include <QComboBox>
#include <QDateEdit>
#include <QPushButton>
#include <QCheckBox>

class WorkoutsTab : public QWidget
{
    Q_OBJECT

public:
    explicit WorkoutsTab(LogManager &lm, QWidget *parent = nullptr);

    // Called by MainWindow after a file load so the table reflects new data
    void refresh();

private slots:
    void onAdd();
    void onEdit();     
    void onDelete();

private:
    void setupUI();
    QTableWidget *table      = nullptr;

    // Search / filter bar
    QLineEdit    *searchBar  = nullptr;   // live description search
    QComboBox    *typeFilter = nullptr;   // All | Cardio | Strength | Yoga
    QDateEdit    *fromDate   = nullptr;   // date-range start
    QDateEdit    *toDate     = nullptr;   // date-range end
    QCheckBox    *useDateFilter = nullptr; // enable/disable the date range

    // Action buttons
    QPushButton  *addBtn    = nullptr;
    QPushButton  *editBtn   = nullptr;    
    QPushButton  *deleteBtn = nullptr;
    LogManager &logManager;
};