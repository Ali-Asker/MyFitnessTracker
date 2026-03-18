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
        const std::string& style,
        const std::string& intensity
    );
    ~YogaWorkout() override = default;

    double computeImpact() const override;
    void displayLog() const override;

    const std::string& getStyle() const;
    void setStyle(const std::string& style);

    const std::string& getIntensity() const;
    void setIntensity(const std::string& intensity);

private:
    std::string style;
    std::string intensity;
};