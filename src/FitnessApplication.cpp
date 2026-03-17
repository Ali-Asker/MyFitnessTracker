#include "FitnessApplication.h"
#include "ui_FitnessApplication.h"
#include "WorkoutDialog.h"
#include "WorkoutCard.h"
#include <QPushButton>
#include <QDebug>

FitnessApplication::FitnessApplication(QWidget *parent)
    : QMainWindow(parent), ui(new Ui::FitnessApplicationClass)
{
    ui->setupUi(this);

    connect(ui->createWorkout, &QPushButton::clicked, this, &FitnessApplication::onCreateWorkout);
}

void FitnessApplication::onCreateWorkout() {
    WorkoutDialog dialog(this);
    if (dialog.exec() == QDialog::Accepted) {
        Workout *workout = dialog.getWorkout();
        if (workout) {
            auto *card = new WorkoutCard(workout, this);
            int count = ui->gridLayout->count();
            int col = count % 3; // 3 cards per row
            int row = count / 3;
            ui->gridLayout->addWidget(card, row, col);
        }
    }
}

FitnessApplication::~FitnessApplication()
{}