#include "FitnessApplication.h"
#include <QPushButton>
#include <QDebug>

FitnessApplication::FitnessApplication(QWidget *parent)
    : QMainWindow(parent)
{
    ui.setupUi(this);

    connect(ui.createWorkout, &QPushButton::clicked, this, &FitnessApplication::onCreateWorkoutClicked);
}

void FitnessApplication::onCreateWorkoutClicked()
{
    qDebug() << "Create Workout clicked";
}

FitnessApplication::~FitnessApplication()
{}