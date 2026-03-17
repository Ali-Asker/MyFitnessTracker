#pragma once
#include <QWidget>

class WorkoutCard : public QWidget {
    Q_OBJECT
public:
    explicit WorkoutCard(const QString &name, QWidget *parent = nullptr);
};