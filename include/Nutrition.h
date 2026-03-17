#pragma once
#include <string>
#include <ostream>
#include "Log.h"
#include <QDateTime>

enum class MealType {
		Breakfast,
		Lunch,
		Dinner,
		Snack
};

class Nutrition : public Log {
private:
	MealType mealType;
	double caloriesConsumed;
public:
	Nutrition(const std::string& logID,
              const QDateTime& date,
              const std::string& description,
              double duration,
              MealType mealType,
              double caloriesConsumed);
	// Might be redundant since the base class destructor is virtual, idkkkkk
	~Nutrition() override = default;

	double computeImpact() const override;
	void displayLog() const override;

	MealType getMealType() const;
	double getCaloriesConsumed() const;

	void setMealType(MealType mealType);
	void setCaloriesConsumed(double caloriesConsumed);

	bool operator==(const Nutrition& other) const;

	// Overload the stream insertion operator for easy output of Nutrition details
	friend std::ostream& operator<<(std::ostream& os, const Nutrition& nutrition);
};