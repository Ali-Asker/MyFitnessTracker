// file author: Shane
#include "CardioWorkout.h"
#include <QDebug>
#include <string>
#include <QDateTime>

// Constructor for distance-based cardio workouts, 
// initializing all attributes including those inherited from Workout and the specific attributes of 
// CardioWorkout related to distance.
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

// Constructor for rep-based cardio workouts
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

// The computeImpact method for CardioWorkout calculates the impact of the cardio workout log, 
// which could be based on the calories burned and either distance or reps depending on the cardio type.
double CardioWorkout::computeImpact() const {
    return getCaloriesBurned() * distance;
}

// The displayLog method for CardioWorkout provides a way 
// to display the details of the cardio workout log,
CardioType CardioWorkout::getCardioType() const {
    return cardioType;
}

// including specific details based on whether it's distance-based or rep-based cardio.
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

// Getters and setters for distance, pace, sets, and reps, allowing for retrieval and modification of these attributes as needed.
double CardioWorkout::getDistance() const { return distance; }
double CardioWorkout::getPace() const { return pace; }
void CardioWorkout::setDistance(double distance) { this->distance = distance; }
void CardioWorkout::setPace(double pace) { this->pace = pace; }
int CardioWorkout::getSets() const { return sets; }
int CardioWorkout::getReps() const { return reps; }
void CardioWorkout::setSets(int sets) { this->sets = sets; }
void CardioWorkout::setReps(int reps) { this->reps = reps; }