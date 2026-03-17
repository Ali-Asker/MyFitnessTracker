// file author: Josh
#include "WorkoutCard.h"
#include <string>
#include <QLabel>
#include <QVBoxLayout>

WorkoutCard::WorkoutCard(Workout *workout, QWidget *parent)
    : QWidget(parent)
{
    layout = new QVBoxLayout(this);
    nameLabel = new QLabel(QString::fromStdString(workout->getDescription()), this);
    dateLabel = new QLabel(workout->getDate().toString("MMM dd yyyy"), this);

    layout->addWidget(nameLabel);
    layout->addWidget(dateLabel);
}