// AnalyticsTab.h
// Shows four summary stat cards (total workout time, calories burned,
// calories consumed, net calories) and a goal progress bar.
// Call refresh() to recalculate from the current LogManager state.

#pragma once

#include <QWidget>
#include <QLabel>
#include <QPushButton>
#include <QDoubleSpinBox>
#include <QProgressBar>

#include "LogManager.h"
#include "Analytics.h"

class AnalyticsTab : public QWidget
{
    Q_OBJECT

public:
    explicit AnalyticsTab(LogManager &logManager, QWidget *parent = nullptr);

    // Recalculates all stats from the current LogManager state.
    // Called automatically when this tab becomes active.
    void refresh();

private slots:
    void onCalcGoal();  // Calculates goal progress from the spinbox inputs

private:
    void setupUI();

    // Helper: creates a styled card (QFrame) containing a value label and a caption.
    // Returns the value QLabel so the caller can update it later.
    QLabel *makeCard(const QString &caption, QWidget *parent, QLayout *layout);

    LogManager     &logManager;
    Analytics<Log>  analytics;   // template class instantiated with Log base type

    // Stat card value labels — updated by refresh()
    QLabel *totalTimeVal;
    QLabel *burnedVal;
    QLabel *consumedVal;
    QLabel *netVal;

    // Goal progress widgets
    QDoubleSpinBox *currentSpin;
    QDoubleSpinBox *goalSpin;
    QProgressBar   *progressBar;
    QLabel         *progressLabel;
};