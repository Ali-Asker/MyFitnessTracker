// file author: Josh
#include "StrengthWorkout.h"
#include <QDebug>
#include <string>
#include <QDateTime>

StrengthWorkout::StrengthWorkout(
    const std::string& logID,
    const QDateTime& date,
    const std::string& description,
    double duration,
    double caloriesBurned,
    int sets,
    int reps,
    double weight
) : Workout(logID, date, description, duration, WorkoutType::Strength, caloriesBurned),
    sets(sets),
    reps(reps),
    weight(weight)
{}

double StrengthWorkout::computeImpact() const {
    return getCaloriesBurned() * sets * reps;
}

void StrengthWorkout::displayLog() const {
   qDebug() << "Strength Workout: " << getDescription()
              << " | Date: " << getDate()
              << " | Duration: " << getDuration() << " min"
              << " | Sets: " << sets
              << " | Reps: " << reps
              << " | Weight: " << weight << " kg"
              << " | Calories: " << getCaloriesBurned();
}

int StrengthWorkout::getSets() const { return sets; }
int StrengthWorkout::getReps() const { return reps; }
double StrengthWorkout::getWeight() const { return weight; }
void StrengthWorkout::setSets(int sets) { this->sets = sets; }
void StrengthWorkout::setReps(int reps) { this->reps = reps; }
void StrengthWorkout::setWeight(double weight) { this->weight = weight; }