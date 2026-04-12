#pragma once
#include <string>
#include <QDateTime>
#include <ostream>
#include "Log.h"

enum class WorkoutType {
    Cardio,
    Strength,
    Yoga
};

class Workout : public Log {
private:
	WorkoutType type;
	double caloriesBurned;
public:
	Workout(const std::string& logID,
            const QDateTime& date,
            const std::string& description,
            double duration,
            WorkoutType type,
            double caloriesBurned);
	~Workout() override = default;

	double computeImpact() const override;
	void displayLog() const override;

	WorkoutType getType() const;
	double getCaloriesBurned() const;

	void setType(WorkoutType type);
	void setCaloriesBurned(double caloriesBurned);

	bool operator==(const Workout& other) const;

	// Overload the stream insertion operator for easy output of Workout details
	friend std::ostream& operator<<(std::ostream& os, const Workout& workout);
};