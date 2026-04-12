#pragma once
#include "Workout.h"
#include <string>
#include <QDateTime>

enum class CardioType {
    Distance,
    RepBased
};

class CardioWorkout : public Workout {
public:
    // for distance cardio
    CardioWorkout(
        const std::string& logID,
        const QDateTime& date,
        const std::string& description,
        double duration,
        double caloriesBurned,
        double distance,
        double pace,
        CardioType cardioType
    );

    // for rep based cardio like jumping jacks or burpees
    CardioWorkout(
        const std::string& logID,
        const QDateTime& date,
        const std::string& description,
        double duration,
        double caloriesBurned,
        int sets,
        int reps,
        CardioType cardioType
    );

    ~CardioWorkout() override = default;

    double computeImpact() const override;
    void displayLog() const override;

    CardioType getCardioType() const;

    // distance based get/set
    double getDistance() const;
    double getPace() const;
    void setDistance(double distance);
    void setPace(double pace);

    // rep based get/set
    int getSets() const;
    int getReps() const;
    void setSets(int sets);
    void setReps(int reps);

private:
    CardioType cardioType;
    // distance
    double distance = 0;
    double pace = 0;
    // reps
    int sets = 0;
    int reps = 0;
};