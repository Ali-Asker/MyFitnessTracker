// file author: Josh
#include "CardioWorkout.h"
#include <QDebug>
#include <string>
#include <QDateTime>

CardioWorkout::CardioWorkout(
    const std::string& logID,
    const QDateTime& date,
    const std::string& description,
    double duration,
    double caloriesBurned,
    double distance,
    double pace,
    CardioType cardioType
) : Workout(logID, date, description, duration, WorkoutType::Cardio, caloriesBurned),
    cardioType(CardioType::Distance),
    distance(distance),
    pace(pace)
{}

CardioWorkout::CardioWorkout(
    const std::string& logID,
    const QDateTime& date,
    const std::string& description,
    double duration,
    double caloriesBurned,
    int sets,
    int reps,
    CardioType cardioType
) : Workout(logID, date, description, duration, WorkoutType::Cardio, caloriesBurned),
    cardioType(CardioType::RepBased),
    sets(sets),
    reps(reps)
{}

double CardioWorkout::computeImpact() const {
    return getCaloriesBurned() * distance;
}

CardioType CardioWorkout::getCardioType() const {
    return cardioType;
}

void CardioWorkout::displayLog() const {
    qDebug() << "Cardio Workout: " << getDescription();
    if (cardioType == CardioType::Distance) {
        qDebug() << " | Distance: " << distance << " km"
                  << " | Pace: " << pace << " min/km";
    } else {
        qDebug() << " | Sets: " << sets
                  << " | Reps: " << reps;
    }
}

double CardioWorkout::getDistance() const { return distance; }
double CardioWorkout::getPace() const { return pace; }
void CardioWorkout::setDistance(double distance) { this->distance = distance; }
void CardioWorkout::setPace(double pace) { this->pace = pace; }

int CardioWorkout::getSets() const { return sets; }
int CardioWorkout::getReps() const { return reps; }
void CardioWorkout::setSets(int sets) { this->sets = sets; }
void CardioWorkout::setReps(int reps) { this->reps = reps; }