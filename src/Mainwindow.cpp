// MainWindow.cpp
// Wires up the four tabs, applies the visual theme,
// builds the File menu, and handles auto-load on startup.

#include "MainWindow.h"
#include "WorkoutsTab.h"
#include "NutritionTab.h"
#include "HealthMetricsTab.h"
#include "AnalyticsTab.h"

#include <QApplication>
#include <QMenuBar>
#include <QStatusBar>
#include <QMessageBox>
#include <QFileDialog>
#include <QDir>
#include <QStandardPaths>

MainWindow::MainWindow(QWidget *parent) : QMainWindow(parent)
{
    setWindowTitle("MyFitnessTracker");
    setMinimumSize(900, 600);
    resize(1366, 768);

    // Apply the dark theme before any widgets are created
    applyTheme();
    buildMenuBar();

    // ── Build each tab, passing a reference to the shared LogManager ─────────
    // All tabs read/write the same LogManager so data stays in sync.
    tabs         = new QTabWidget(this);
    workoutsTab  = new WorkoutsTab(logManager, tabs);
    nutritionTab = new NutritionTab(logManager, tabs);
    metricsTab   = new HealthMetricsTab(logManager, tabs);
    analyticsTab = new AnalyticsTab(logManager, tabs);

    tabs->addTab(workoutsTab,  "Workouts");
    tabs->addTab(nutritionTab, "Nutrition");
    tabs->addTab(metricsTab,   "Health Metrics");
    tabs->addTab(analyticsTab, "Analytics");

    setCentralWidget(tabs);
    statusBar()->showMessage("Ready");

    // Refresh the Analytics tab each time the user switches to it,
    // so numbers always reflect the latest data
    connect(tabs, &QTabWidget::currentChanged, this, [this](int idx) {
        if (tabs->widget(idx) == analyticsTab)
            analyticsTab->refresh();
    });

    statusBar()->showMessage("Ready — use File > Save / Load to manage your data.");
}

// ── File menu ─────────────────────────────────────────────────────────────────

void MainWindow::buildMenuBar()
{
    QMenu *file = menuBar()->addMenu("&File");

    auto *saveAct = file->addAction("&Save");
    saveAct->setShortcut(QKeySequence::Save);
    connect(saveAct, &QAction::triggered, this, &MainWindow::onSave);

    auto *loadAct = file->addAction("&Load");
    loadAct->setShortcut(QKeySequence::Open);
    connect(loadAct, &QAction::triggered, this, &MainWindow::onLoad);

    file->addSeparator();

    auto *quitAct = file->addAction("&Quit");
    quitAct->setShortcut(QKeySequence::Quit);
    connect(quitAct, &QAction::triggered, qApp, &QApplication::quit);
}

void MainWindow::onSave()
{
    // Open the native Save dialog, starting in the user's Documents folder.
    // getSaveFileName returns an empty string if the user cancels — we bail out.
    QString path = QFileDialog::getSaveFileName(
        this,
        "Save Fitness Data",                              // dialog title
        QStandardPaths::writableLocation(                  // default directory
            QStandardPaths::DocumentsLocation) + "/fitness_logs.json",
        "JSON Files (*.json);;All Files (*)"              // file type filter
        );

    if (path.isEmpty())
        return;  // user cancelled — do nothing

    try {
        dataManager.saveData(path.toStdString(), logManager);
        statusBar()->showMessage("Saved to " + path);
    } catch (const std::exception &e) {
        QMessageBox::critical(this, "Save Error", e.what());
    }
}

void MainWindow::onLoad()
{
    // Open the native Open dialog, starting in the user's Documents folder.
    // getOpenFileName returns an empty string if the user cancels.
    QString path = QFileDialog::getOpenFileName(
        this,
        "Load Fitness Data",                              // dialog title
        QStandardPaths::writableLocation(                  // default directory
            QStandardPaths::DocumentsLocation),
        "JSON Files (*.json);;All Files (*)"              // file type filter
        );

    if (path.isEmpty())
        return;  // user cancelled — do nothing

    try {
        dataManager.loadData(path.toStdString(), logManager);
        // Refresh all tabs so they show the newly loaded data
        workoutsTab->refresh();
        nutritionTab->refresh();
        metricsTab->refresh();
        analyticsTab->refresh();
        statusBar()->showMessage("Loaded from " + path);
    } catch (const std::exception &e) {
        QMessageBox::critical(this, "Load Error", e.what());
    }
}

// ── Theme ─────────────────────────────────────────────────────────────────────
// One stylesheet applied to the whole app via qApp.
// Uses Fusion style as the base (cross-platform, clean) then overrides colours.

void MainWindow::applyTheme()
{
    qApp->setStyle("Fusion");

    qApp->setStyleSheet(R"(

        /* ── Window & dialogs ───────────────────────── */
        QMainWindow, QDialog {
            background-color: #1e1e1e;
        }

        /* ── Menu bar ───────────────────────────────── */
        QMenuBar {
            background-color: #2a2a2a;
            color: #dddddd;
            border-bottom: 1px solid #3a3a3a;
            padding: 2px;
            font-size: 13px;
        }
        QMenuBar::item:selected {
            background-color: #39FF14;
            color: #111;
            border-radius: 3px;
        }
        QMenu {
            background-color: #2a2a2a;
            color: #dddddd;
            border: 1px solid #3a3a3a;
        }
        QMenu::item:selected {
            background-color: #39FF14;
            color: #111;
        }

        /* ── Status bar ─────────────────────────────── */
        QStatusBar {
            background-color: #2a2a2a;
            color: #888;
            border-top: 1px solid #3a3a3a;
            font-size: 12px;
        }

        /* ── Tab bar ────────────────────────────────── */
        QTabWidget::pane {
            border: none;
            background-color: #1e1e1e;
        }
        QTabBar::tab {
            background-color: #2a2a2a;
            color: #888;
            padding: 10px 24px;
            border: none;
            border-bottom: 2px solid transparent;
            font-size: 13px;
            font-weight: 500;
        }
        QTabBar::tab:selected {
            color: #39FF14;
            border-bottom: 2px solid #39FF14;
            background-color: #1e1e1e;
        }
        QTabBar::tab:hover:!selected {
            color: #dddddd;
            background-color: #333;
        }

        /* ── Primary button (green) ─────────────────── */
        QPushButton {
            background-color: #39FF14;
            color: #111111;
            border: none;
            border-radius: 5px;
            padding: 8px 20px;
            font-size: 13px;
            font-weight: 600;
            min-width: 90px;
        }
        QPushButton:hover  { background-color: #2ecc71; }
        QPushButton:pressed { background-color: #27ae60; }

        /* ── Danger button (red) — set objectName="danger" ── */
        QPushButton#danger {
            background-color: #c0392b;
            color: #ffffff;
        }
        QPushButton#danger:hover  { background-color: #e74c3c; }

        /* ── Text inputs ────────────────────────────── */
        QLineEdit, QSpinBox, QDoubleSpinBox, QDateTimeEdit, QComboBox {
            background-color: #2d2d2d;
            color: #dddddd;
            border: 1px solid #3a3a3a;
            border-radius: 5px;
            padding: 6px 10px;
            font-size: 13px;
        }
        QLineEdit:focus, QSpinBox:focus, QDoubleSpinBox:focus,
        QDateTimeEdit:focus, QComboBox:focus {
            border: 1px solid #39FF14;
        }
        QComboBox QAbstractItemView {
            background-color: #2a2a2a;
            color: #dddddd;
            border: 1px solid #3a3a3a;
            selection-background-color: #39FF14;
            selection-color: #111;
        }

        /* ── Table ──────────────────────────────────── */
        QTableWidget {
            background-color: #242424;
            color: #dddddd;
            gridline-color: #2e2e2e;
            border: none;
            font-size: 13px;
            alternate-background-color: #2a2a2a;
            selection-background-color: #1a3320;
            selection-color: #39FF14;
        }
        QTableWidget::item { padding: 6px 10px; }
        QHeaderView::section {
            background-color: #2d2d2d;
            color: #39FF14;
            border: none;
            border-bottom: 1px solid #3a3a3a;
            padding: 8px 10px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 1px;
        }
        /* Thin scrollbar */
        QScrollBar:vertical {
            background: #242424;
            width: 6px;
            border: none;
        }
        QScrollBar::handle:vertical {
            background: #3a3a3a;
            border-radius: 3px;
        }
        QScrollBar::handle:vertical:hover { background: #39FF14; }
        QScrollBar::add-line:vertical,
        QScrollBar::sub-line:vertical { height: 0; }

        /* ── Labels ─────────────────────────────────── */
        QLabel { color: #dddddd; font-size: 13px; }

        /* Section heading — set objectName="heading" */
        QLabel#heading {
            color: #39FF14;
            font-size: 16px;
            font-weight: 700;
            letter-spacing: 2px;
        }

        /* Large number inside a stat card — set objectName="statNum" */
        QLabel#statNum {
            color: #39FF14;
            font-size: 30px;
            font-weight: 700;
        }

        /* Small caption — set objectName="caption" */
        QLabel#caption {
            color: #666;
            font-size: 11px;
            letter-spacing: 1px;
        }

        /* ── Stat card (QFrame) — set objectName="card" ── */
        QFrame#card {
            background-color: #242424;
            border: 1px solid #333;
            border-radius: 8px;
        }

        /* ── Progress bar ───────────────────────────── */
        QProgressBar {
            background-color: #2d2d2d;
            border: 1px solid #3a3a3a;
            border-radius: 5px;
            height: 14px;
            text-align: center;
            color: #dddddd;
            font-size: 11px;
        }
        QProgressBar::chunk {
            background-color: #39FF14;
            border-radius: 4px;
        }

        /* ── Form dialog ────────────────────────────── */
        QDialog { background-color: #242424; }
        QFormLayout QLabel { color: #aaa; font-size: 12px; }

    )");
}
