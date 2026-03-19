// file author: Shane
#include "StrengthWorkout.h"
#include <QDebug>
#include <string>
#include <QDateTime>

// Constructor for StrengthWorkout, initializing all attributes including those inherited 
// from Workout and the specific attributes of StrengthWorkout related to sets, reps, and weight.
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

// The computeImpact method for StrengthWorkout calculates the impact of the strength workout log,
double StrengthWorkout::computeImpact() const {
    return getCaloriesBurned() * sets * reps;
}

// The displayLog method for StrengthWorkout provides a way to display the details of the strength workout log,
void StrengthWorkout::displayLog() const {
   qDebug() << "Strength Workout: " << getDescription()
              << " | Date: " << getDate()
              << " | Duration: " << getDuration() << " min"
              << " | Sets: " << sets
              << " | Reps: " << reps
              << " | Weight: " << weight << " kg"
              << " | Calories: " << getCaloriesBurned();
}

// Getters and setters for sets, reps, and weight
int StrengthWorkout::getSets() const { return sets; }
int StrengthWorkout::getReps() const { return reps; }
double StrengthWorkout::getWeight() const { return weight; }
void StrengthWorkout::setSets(int sets) { this->sets = sets; }
void StrengthWorkout::setReps(int reps) { this->reps = reps; }
void StrengthWorkout::setWeight(double weight) { this->weight = weight; }