#pragma once
#include <string>
#include <ostream>
#include "Log.h"

class Nutrition : public Log {
private:
	std::string mealType;
	double caloriesConsumed;
public:
	Nutrition(const std::string& logID,
              const std::string& date,
              const std::string& description,
              double duration,
              const std::string& mealType,
              double caloriesConsumed);
	// Might be redundant since the base class destructor is virtual, idkkkkk
	~Nutrition() override = default;

	double computeImpact() const override;
	void displayLog() const override;

	const std::string& getMealType() const;
	double getCaloriesConsumed() const;

	void setMealType(const std::string& mealType);
	void setCaloriesConsumed(double caloriesConsumed);

	bool operator==(const Nutrition& other) const;

	// Overload the stream insertion operator for easy output of Nutrition details
	friend std::ostream& operator<<(std::ostream& os, const Nutrition& nutrition);
};