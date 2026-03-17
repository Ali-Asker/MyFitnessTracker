#include "WorkoutCard.h"
#include <QLabel>
#include <QVBoxLayout>

WorkoutCard::WorkoutCard(const QString &name, QWidget *parent)
    : QWidget(parent)
{
    auto *layout = new QVBoxLayout(this);
    auto *label = new QLabel(name, this);

    setStyleSheet("background-color: #2a2a2a; border-radius: 8px;");
    setFixedHeight(80);

    layout->addWidget(label);
}