// NutritionTab.h
// Displays all nutrition logs in a table.
// Lets the user add a meal entry or delete a selected row.
// Supports live search by description keyword.

#pragma once

#include <QWidget>
#include <QTableWidget>
#include <QLineEdit>
#include <QPushButton>

#include "LogManager.h"

class NutritionTab : public QWidget
{
    Q_OBJECT

public:
    explicit NutritionTab(LogManager &logManager, QWidget *parent = nullptr);

    // Repopulates the table from the current LogManager state.
    void refresh();

private slots:
    void onAdd();    // Opens the "Add Meal" dialog
    void onDelete(); // Deletes the currently selected row

private:
    void setupUI();

    LogManager   &logManager;

    QTableWidget *table;
    QLineEdit    *searchBar;
    QPushButton  *addBtn;
    QPushButton  *deleteBtn;
};
