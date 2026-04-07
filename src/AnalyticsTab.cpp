// AnalyticsTab.cpp
// Four stat cards + a goal progress section.
// All numbers come from the Analytics<Log> template class methods.

#include "AnalyticsTab.h"

#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QGridLayout>
#include <QFrame>
#include <QLabel>
#include <QPushButton>
#include <QMessageBox>
#include <algorithm>

AnalyticsTab::AnalyticsTab(LogManager &lm, QWidget *parent)
    : QWidget(parent), logManager(lm)
{
    setupUI();
}

// ── makeCard ──────────────────────────────────────────────────────────────────
// Builds a dark rounded card with:
//   - a large green number (the stat value)
//   - a small grey caption below it
// Adds the card directly to the given layout. Returns the value QLabel.
QLabel *AnalyticsTab::makeCard(const QString &caption, QWidget *parent, QLayout *layout)
{
    // The card itself is a QFrame with objectName="card" (styled by stylesheet)
    auto *card = new QFrame(parent);
    card->setObjectName("card");
    card->setMinimumHeight(110);

    auto *vl = new QVBoxLayout(card);
    vl->setContentsMargins(16, 12, 16, 12);
    vl->setSpacing(4);

    auto *val = new QLabel("—");
    val->setObjectName("statNum");
    val->setAlignment(Qt::AlignCenter);

    auto *cap = new QLabel(caption.toUpper());
    cap->setObjectName("caption");
    cap->setAlignment(Qt::AlignCenter);

    vl->addStretch();
    vl->addWidget(val);
    vl->addWidget(cap);
    vl->addStretch();

    // Add the card to whatever layout was passed in
    if (auto *grid = qobject_cast<QGridLayout *>(layout)) {
        // Count existing items to figure out the next row/col position
        int count = grid->count();
        int col   = count % 2;
        int row   = count / 2;
        grid->addWidget(card, row, col);
    } else {
        layout->addWidget(card);
    }

    return val;
}

void AnalyticsTab::setupUI()
{
    auto *root = new QVBoxLayout(this);
    root->setContentsMargins(20, 20, 20, 16);
    root->setSpacing(16);

    // ── Heading ───────────────────────────────────────────────────────────────
    auto *heading = new QLabel("ANALYTICS");
    heading->setObjectName("heading");
    root->addWidget(heading);

    auto *sep = new QFrame;
    sep->setFrameShape(QFrame::HLine);
    sep->setStyleSheet("color:#333;");
    root->addWidget(sep);

    // ── 2x2 grid of stat cards ────────────────────────────────────────────────
    // Each card shows one aggregate number from the Analytics class
    auto *grid = new QGridLayout;
    grid->setSpacing(12);

    totalTimeVal = makeCard("Total Workout Time (min)", this, grid);
    burnedVal    = makeCard("Calories Burned",           this, grid);
    consumedVal  = makeCard("Calories Consumed",         this, grid);
    netVal       = makeCard("Net Calories",              this, grid);

    root->addLayout(grid);

    // ── Separator ─────────────────────────────────────────────────────────────
    auto *sep2 = new QFrame;
    sep2->setFrameShape(QFrame::HLine);
    sep2->setStyleSheet("color:#333;");
    root->addWidget(sep2);

    // ── Goal progress section ─────────────────────────────────────────────────
    auto *goalLabel = new QLabel("GOAL PROGRESS");
    goalLabel->setObjectName("heading");
    root->addWidget(goalLabel);

    // Input row: Current Value | Goal Value | Calculate button
    auto *inputRow = new QHBoxLayout;

    inputRow->addWidget(new QLabel("Current:"));
    currentSpin = new QDoubleSpinBox;
    currentSpin->setRange(0, 99999);
    currentSpin->setDecimals(1);
    currentSpin->setFixedWidth(110);
    inputRow->addWidget(currentSpin);

    inputRow->addSpacing(16);
    inputRow->addWidget(new QLabel("Goal:"));
    goalSpin = new QDoubleSpinBox;
    goalSpin->setRange(0.001, 99999);
    goalSpin->setDecimals(1);
    goalSpin->setFixedWidth(110);
    inputRow->addWidget(goalSpin);

    inputRow->addSpacing(16);
    auto *calcBtn = new QPushButton("Calculate");
    calcBtn->setFixedWidth(110);
    connect(calcBtn, &QPushButton::clicked, this, &AnalyticsTab::onCalcGoal);
    inputRow->addWidget(calcBtn);

    inputRow->addStretch();
    root->addLayout(inputRow);

    // Progress bar + percentage label
    progressBar = new QProgressBar;
    progressBar->setRange(0, 100);
    progressBar->setValue(0);
    progressBar->setFormat("%p%");
    progressBar->setFixedHeight(18);
    root->addWidget(progressBar);

    progressLabel = new QLabel("Enter a current and goal value, then press Calculate.");
    progressLabel->setObjectName("caption");
    root->addWidget(progressLabel);

    root->addStretch();

    // ── Refresh button ────────────────────────────────────────────────────────
    auto *btnRow = new QHBoxLayout;
    btnRow->addStretch();
    auto *refreshBtn = new QPushButton("Refresh Stats");
    connect(refreshBtn, &QPushButton::clicked, this, &AnalyticsTab::refresh);
    btnRow->addWidget(refreshBtn);
    root->addLayout(btnRow);
}

// ── refresh ───────────────────────────────────────────────────────────────────
// Collects all logs from LogManager as raw pointers, then calls the
// Analytics template methods to compute each aggregate value.
void AnalyticsTab::refresh()
{
    // Build a plain vector<Log*> from the unique_ptr vector — Analytics takes raw pointers
    std::vector<Log *> ptrs;
    for (const auto &l : logManager.getLogs())
        ptrs.push_back(l.get());

    double totalTime = analytics.computeTotalWorkoutTime(ptrs);
    double burned    = analytics.computeTotalCaloriesBurned(ptrs);
    double consumed  = analytics.computeTotalCaloriesConsumed(ptrs);
    double net       = analytics.computeNetCalories(consumed, burned);

    totalTimeVal->setText(QString::number(totalTime, 'f', 0));
    burnedVal->setText(QString::number(burned,   'f', 0));
    consumedVal->setText(QString::number(consumed, 'f', 0));
    netVal->setText(QString::number(net, 'f', 0));

    // Net calories: green = deficit (good), orange = surplus
    netVal->setStyleSheet(
        net <= 0
            ? "color:#39FF14; font-size:30px; font-weight:700;"
            : "color:#e67e22; font-size:30px; font-weight:700;");
}

// ── onCalcGoal ────────────────────────────────────────────────────────────────
// Calls Analytics::computeGoalProgress and updates the progress bar.
void AnalyticsTab::onCalcGoal()
{
    double pct = analytics.computeGoalProgress(currentSpin->value(), goalSpin->value());

    if (pct < 0) {
        // computeGoalProgress returns -1 when goal is 0
        QMessageBox::warning(this, "Goal Error", "Goal value cannot be zero.");
        return;
    }

    // Clamp to 100 for the bar; show the real percentage in the label
    progressBar->setValue(static_cast<int>(std::min(pct, 100.0)));
    progressLabel->setText(QString("Progress: %1% of goal").arg(pct, 0, 'f', 1));
}
