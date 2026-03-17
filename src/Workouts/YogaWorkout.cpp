// file author: Josh
#include "YogaWorkout.h"
#include <QDebug>
#include <string>
#include <QDateTime>

YogaWorkout::YogaWorkout(
    const std::string& logID,
    const QDateTime& date,
    const std::string& description,
    double duration,
    double caloriesBurned,
    const std::string& style
) : Workout(logID, date, description, duration, WorkoutType::Yoga, caloriesBurned),
    style(style)
{}

double YogaWorkout::computeImpact() const {
    return getCaloriesBurned() * getDuration();
}

void YogaWorkout::displayLog() const {
    qDebug() << "Yoga Workout: " << getDescription()
              << " | Date: " << getDate()
              << " | Duration: " << getDuration() << " min"
              << " | Style: " << style
              << " | Calories: " << getCaloriesBurned();
}

const std::string& YogaWorkout::getStyle() const { return style; }
void YogaWorkout::setStyle(const std::string& style) { this->style = style; }