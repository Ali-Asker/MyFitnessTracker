// file author: Josh
#pragma once
#include <QWidget>
#include <string>
#include <QLabel>
#include <QVBoxLayout>
#include "Workout.h"

class WorkoutCard : public QWidget {
    Q_OBJECT
public:
    explicit WorkoutCard(Workout *workout, QWidget *parent = nullptr);
protected:
    QVBoxLayout *layout;
    QLabel *nameLabel;
    QLabel *dateLabel;
};