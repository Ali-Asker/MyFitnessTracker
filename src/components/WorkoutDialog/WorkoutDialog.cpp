// file author: Josh
#include "WorkoutDialog.h"
#include "CardioWorkout.h"
#include "StrengthWorkout.h"
#include "YogaWorkout.h"
#include "ui_WorkoutDialog.h"
#include <string>
#include <Quuid>
#include <QDebug>

WorkoutDialog::WorkoutDialog(QWidget *parent)
    : QDialog(parent), ui(new Ui::WorkoutDialog)
{
    ui->setupUi(this);

    // change workout type stacked widget
    connect(ui->workoutTypeCombo, &QComboBox::currentIndexChanged, this, &WorkoutDialog::onTypeChanged);
    
    // toggle cardio type stacked widget
    connect(ui->distBasedRadio, &QRadioButton::toggled,
            this, &WorkoutDialog::onCardioTypeChanged);
    connect(ui->repBasedRadio, &QRadioButton::toggled,
            this, &WorkoutDialog::onCardioTypeChanged);

    
    // update default name to reflect type and date 
    connect(ui->workoutTypeCombo, &QComboBox::currentIndexChanged,
            this, &WorkoutDialog::updateDefaultName);
    connect(ui->workoutDateTime, &QDateTimeEdit::dateTimeChanged,
            this, &WorkoutDialog::updateDefaultName);

    // set the default datetime to now 
    ui->workoutDateTime->setDateTime(QDateTime::currentDateTime());
}

WorkoutDialog::~WorkoutDialog()
{
    delete ui;
}

void WorkoutDialog::onTypeChanged(int index)
{
    ui->stackedWidget->setCurrentIndex(index);
    updateDefaultName();
}

void WorkoutDialog::onCardioTypeChanged() 
{
    if (ui->distBasedRadio->isChecked()) {
        ui->cardioInnerStack->setCurrentIndex(0);
    } else {
        ui->cardioInnerStack->setCurrentIndex(1);
    }
}

void WorkoutDialog::updateDefaultName()
{
    std::string type = ui->workoutTypeCombo->currentText().toStdString();
    std::string date = ui->workoutDateTime->date().toString("MMM dd yyyy").toStdString();
    ui->name->setPlaceholderText(QString::fromStdString(type + " - " + date));
}

Workout* WorkoutDialog::getWorkout() const
{
    std::string id = QUuid::createUuid().toString().toStdString();
    std::string description = ui->description->toPlainText().toStdString();
    double duration = ui->durationInput->value();
    double calories = ui->caloriesInput->text().toDouble();
    QDateTime dateTime = ui->workoutDateTime->dateTime();

    int typeIndex = ui->workoutTypeCombo->currentIndex();
    WorkoutType type = static_cast<WorkoutType>(typeIndex);

    if (type == WorkoutType::Cardio) {
        if (ui->distBasedRadio->isChecked()) {
            double distance = ui->distanceInput->text().toDouble();
            double pace = ui->paceInput->text().toDouble();
            return new CardioWorkout(id, dateTime, description, duration, calories, distance, pace, CardioType::Distance);
        } else {
            int sets = ui->setsInput->value();
            int reps = ui->repsInput->value();
            return new CardioWorkout(id, dateTime, description, duration, calories, sets, reps, CardioType::RepBased);
        }
    } else if (type == WorkoutType::Strength) {
        int sets = ui->setsInput->value();
        int reps = ui->repsInput->value();
        double weight = ui->weightInput->text().toDouble();
        return new StrengthWorkout(id, dateTime, description, duration, calories, sets, reps, weight);
    } else if (type == WorkoutType::Yoga) {
        std::string style = ui->yogaStyleInput->text().toStdString();
        std::string intensity = ui->yogaIntensityInput->text().toStdString();
        return new YogaWorkout(id, dateTime, description, duration, calories, style, intensity);
    }

    return nullptr;
}