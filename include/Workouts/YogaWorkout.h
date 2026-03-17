// file author: Josh
#pragma once
#include "Workout.h"
#include <iostream>
#include <string>

class YogaWorkout : public Workout {
public:
    YogaWorkout(
        const std::string& logID,
        const QDateTime& date,
        const std::string& description,
        double duration,
        double caloriesBurned,
        const std::string& style
    );
    ~YogaWorkout() override = default;

    double computeImpact() const override;
    void displayLog() const override;

    const std::string& getStyle() const;
    void setStyle(const std::string& style);

private:
    std::string style;
};