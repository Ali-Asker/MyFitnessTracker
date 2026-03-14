#pragma once
#include <string>
#include <ostream>
#include "Log.h"

class Workout : public Log {
private:
	std::string type;
	double caloriesBurned;
public:
	Workout(const std::string& logID,
            const std::string& date,
            const std::string& description,
            double duration,
            const std::string& type,
            double caloriesBurned);
	~Workout() override = default;

	double computeImpact() const override;
	void displayLog() const override;

	const std::string& getType() const;
	double getCaloriesBurned() const;

	void setType(const std::string& type);
	void setCaloriesBurned(double caloriesBurned);

	bool operator==(const Workout& other) const;

	// Overload the stream insertion operator for easy output of Workout details
	friend std::ostream& operator<<(std::ostream& os, const Workout& workout);
};