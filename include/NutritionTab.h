// NutritionTab.h
// Displays all nutrition logs in a table.
// Supports:
//   - Live description search
//   - MealType filter  (All | Breakfast | Lunch | Dinner | Snack)
//   - Date-range filter (checkbox + From / To pickers)
//   - Add / Edit / Delete actions
//   - Full macro fields (protein, carbs, fats, sugar, title) in Add/Edit dialogs

#pragma once

#include "LogManager.h"

#include <QWidget>
#include <QTableWidget>
#include <QLineEdit>
#include <QComboBox>
#include <QDateEdit>
#include <QPushButton>
#include <QCheckBox>

class NutritionTab : public QWidget
{
    Q_OBJECT

public:
    explicit NutritionTab(LogManager &logManager, QWidget *parent = nullptr);

    // Repopulates the table from the current LogManager state.
    void refresh();

private slots:
    void onAdd();
    void onEdit();
    void onDelete();

private:
    void setupUI();

    // ── Data ──────────────────────────────────────────────────────────────────
    LogManager &logManager;

    // ── Widgets ───────────────────────────────────────────────────────────────
    QTableWidget *table         = nullptr;

    // Search / filter bar
    QLineEdit    *searchBar     = nullptr;   // live description search
    QComboBox    *mealFilter    = nullptr;   // All | Breakfast | Lunch | Dinner | Snack
    QDateEdit    *fromDate      = nullptr;
    QDateEdit    *toDate        = nullptr;
    QCheckBox    *useDateFilter = nullptr;

    // Action buttons
    QPushButton  *addBtn    = nullptr;
    QPushButton  *editBtn   = nullptr;
    QPushButton  *deleteBtn = nullptr;
};
