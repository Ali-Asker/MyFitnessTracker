// file author: Josh
#pragma once
#include <Workout.h>
#include <QDialog>
#include <QDateTime>

namespace Ui {
class WorkoutDialog;
}

class WorkoutDialog : public QDialog {
    Q_OBJECT
public:
    Workout* getWorkout() const;
    explicit WorkoutDialog(QWidget *parent = nullptr);
        ~WorkoutDialog();

private slots:
    void onTypeChanged(int index);
    void onCardioTypeChanged();
    void updateDefaultName();

private:
    Ui::WorkoutDialog *ui;
};