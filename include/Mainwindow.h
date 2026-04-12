// MainWindow.h
// The top-level window. It owns the LogManager and DataManager,
// builds the tab widget, and handles File menu actions (Save / Load).

#pragma once

#include <QMainWindow>
#include <QTabWidget>

#include "LogManager.h"
#include "DataManager.h"

// Forward-declare each tab so we can include their headers only in the .cpp
class WorkoutsTab;
class NutritionTab;
class HealthMetricsTab;
class AnalyticsTab;

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);

private slots:
    void onSave();   
    void onLoad();   
    void onExportSummary(); 


private:
    void buildMenuBar();  // Creates the File menu
    void applyTheme();    // Sets the global dark stylesheet
    QTabWidget       *tabs;
    WorkoutsTab      *workoutsTab;
    NutritionTab     *nutritionTab;
    HealthMetricsTab *metricsTab;
    AnalyticsTab     *analyticsTab;

    // LogManager holds all logs and health metrics in memory.
    // DataManager reads/writes them to a JSON file.
    LogManager  logManager;
    DataManager dataManager;
};