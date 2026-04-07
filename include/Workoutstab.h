#ifndef WORKOUTSTAB_H
#define WORKOUTSTAB_H

// WorkoutsTab.h
// Displays all workout logs in a table.
// Lets the user add a new workout (via a dialog) or delete a selected row.
// Also supports live search by description keyword.

#pragma once

#include <QWidget>
#include <QTableWidget>
#include <QLineEdit>
#include <QPushButton>

#include "LogManager.h"

class WorkoutsTab : public QWidget
{
    Q_OBJECT

public:
    explicit WorkoutsTab(LogManager &logManager, QWidget *parent = nullptr);

    // Repopulates the table from the current LogManager state.
    // Call this after any add/delete or after loading from file.
    void refresh();

private slots:
    void onAdd();     // Opens the "Add Workout" dialog
    void onDelete();  // Deletes the currently selected row

private:
    void setupUI();

    LogManager   &logManager;  // reference — shared with all other tabs

    QTableWidget *table;
    QLineEdit    *searchBar;
    QPushButton  *addBtn;
    QPushButton  *deleteBtn;
};

#endif // WORKOUTSTAB_H
