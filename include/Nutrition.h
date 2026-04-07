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
	double protein;   // grams
	double carbs;     // grams
	double fats;      // grams
	double sugar;     // grams
	std::string title;

public:
	Nutrition(const std::string& logID,
              const QDateTime& date,
              const std::string& description,
              double duration,
              MealType mealType,
              double caloriesConsumed,
              const std::string& title = "");

	~Nutrition() override = default;

	double computeImpact() const override;
	void displayLog() const override;

	// Getters
	MealType getMealType() const;
	double getCaloriesConsumed() const;
	const std::string& getTitle() const;

	// Setters
	void setMealType(MealType mealType);
	void setCaloriesConsumed(double caloriesConsumed);
	void setProtein(double protein);
	void setCarbs(double carbs);
	void setFats(double fats);
	void setSugar(double sugar);
	void setTitle(const std::string& title);

	bool operator==(const Nutrition& other) const;

	// Overload the stream insertion operator for easy output of Nutrition details
	friend std::ostream& operator<<(std::ostream& os, const Nutrition& nutrition);
};