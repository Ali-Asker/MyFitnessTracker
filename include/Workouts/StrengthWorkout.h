#pragma once
#include "Workout.h"
#include <string>
#include <QDateTime>

class StrengthWorkout : public Workout {
public:
    StrengthWorkout(
        const std::string& logID,
        const QDateTime& date,
        const std::string& description,
        double duration,
        double caloriesBurned,
        int sets,
        int reps,
        double weight
    );
    ~StrengthWorkout() override = default;

    double computeImpact() const override;
    void displayLog() const override;

    int getSets() const;
    int getReps() const;
    double getWeight() const;

    void setSets(int sets);
    void setReps(int reps);
    void setWeight(double weight);

private:
    int sets;
    int reps;
    double weight;
};