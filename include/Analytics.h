// Analytics.h
// Template class for computing fitness and nutrition summaries.
//
// WHY everything is defined in the header:
// C++ templates are not compiled until they are instantiated with a concrete
// type (e.g. Analytics<Log>). The compiler needs to see the full method body
// at the point of instantiation — it cannot link to a separate .cpp file the
// way it does for regular classes. Keeping declarations AND definitions here
// is the standard solution for template classes.
//
// Analytics.cpp has been removed from the project entirely.

#pragma once

#include <vector>
#include <QDebug>
#include "Workouts/Workout.h"
#include "Nutrition.h"

template <typename T>
class Analytics
{
public:
    Analytics() = default;

    // ── Declarations + definitions (all in one place for templates) ───────────

    // Sums the duration of every Workout-derived log in the vector.
    double computeTotalWorkoutTime(const std::vector<T *> &logs) const
    {
        double total = 0.0;
        for (auto *log : logs) {
            // dynamic_cast returns nullptr if the log is not a Workout — skip it
            if (Workout *w = dynamic_cast<Workout *>(log))
                total += w->getDuration();
        }
        return total;
    }

    // Sums caloriesBurned from every Workout-derived log.
    double computeTotalCaloriesBurned(const std::vector<T *> &logs) const
    {
        double total = 0.0;
        for (auto *log : logs) {
            if (Workout *w = dynamic_cast<Workout *>(log))
                total += w->getCaloriesBurned();
        }
        return total;
    }

    // Sums caloriesConsumed from every Nutrition-derived log.
    double computeTotalCaloriesConsumed(const std::vector<T *> &logs) const
    {
        double total = 0.0;
        for (auto *log : logs) {
            // dynamic_cast returns nullptr if the log is not a Nutrition — skip it
            if (Nutrition *n = dynamic_cast<Nutrition *>(log))
                total += n->getCaloriesConsumed();
        }
        return total;
    }

    // Net calories = consumed - burned.
    // A negative result means a calorie deficit (more burned than eaten).
    double computeNetCalories(double totalConsumed, double totalBurned) const
    {
        return totalConsumed - totalBurned;
    }

    // Returns progress as a percentage: (current / goal) * 100.
    // Returns -1 and logs a warning if goal is 0 (division by zero guard).
    double computeGoalProgress(double currentValue, double goalValue) const
    {
        if (goalValue == 0.0) {
            qDebug() << "Analytics: goal value cannot be 0";
            return -1.0;
        }
        return (currentValue / goalValue) * 100.0;
    }
};
