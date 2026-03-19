#include "GUI.h"
#include "ui_GUI.h"
#include "WorkoutDialog.h"
#include "WorkoutCard.h"
#include <QPushButton>
#include <QDebug>

GUI::GUI(QWidget* parent)
    : QMainWindow(parent), ui(new Ui::GUIClass)
{
    ui->setupUi(this);
    connect(ui->createWorkout, &QPushButton::clicked, this, &GUI::onCreateWorkout);
}

void GUI::onCreateWorkout() {
    WorkoutDialog dialog(this);
    if (dialog.exec() == QDialog::Accepted) {
        Workout* workout = dialog.getWorkout();
        if (workout) {
            auto* card = new WorkoutCard(workout, this);
            int count = ui->gridLayout->count();
            int col = count % 3;
            int row = count / 3;
            ui->gridLayout->addWidget(card, row, col);
        }
    }
}

GUI::~GUI() {}