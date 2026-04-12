#include "YogaWorkout.h"
#include <QDebug>
#include <string>
#include <QDateTime>

// Constructor for YogaWorkout, initializing all attributes including those inherited
YogaWorkout::YogaWorkout(
    const std::string& logID,
    const QDateTime& date,
    const std::string& description,
    double duration,
    double caloriesBurned,
    const std::string& style,
    const std::string& intensity
) : Workout(logID, date, description, duration, WorkoutType::Yoga, caloriesBurned),
    style(style),
    intensity(intensity)
{}

// The computeImpact method for YogaWorkout calculates the impact of the yoga workout log, which could be based on the calories burned and duration.
double YogaWorkout::computeImpact() const {
    return getCaloriesBurned() * getDuration();
}

// The displayLog method for YogaWorkout provides a way to display the details of the yoga workout log, 
// including specific details about the style and intensity of the yoga session.
void YogaWorkout::displayLog() const {
    qDebug() << "Yoga Workout: " << getDescription()
              << " | Date: " << getDate()
              << " | Duration: " << getDuration() << " min"
              << " | Style: " << style
              << " | Calories: " << getCaloriesBurned();
}

// Getters and setters for style and intensity
const std::string& YogaWorkout::getStyle() const { return style; }
void YogaWorkout::setStyle(const std::string& style) { this->style = style; }
const std::string& YogaWorkout::getIntensity() const { return style; }
void YogaWorkout::setIntensity(const std::string& intensity) { this->style = intensity; }