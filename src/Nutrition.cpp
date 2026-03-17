#include "Nutrition.h"
#include <QDebug>
#include <string>
#include <QDateTime>
using namespace std;

namespace {
	// Helper method to convert enum to string
	// Author: Josh
	const char* toString(MealType type)
	{
		switch (type) {
		case MealType::Breakfast:
			return "Breakfast";
		case MealType::Lunch:
			return "Lunch";
		case MealType::Dinner:
			return "Dinner";
		case MealType::Snack:
			return "Snack";
		}

		return "Unknown";
	}
}

// Constructor implementation for Nutrition class, initializing all attributes including those inherited from Log and the specific attributes of Nutrition.
Nutrition::Nutrition(const std::string& logID,
                     const QDateTime& date,
                     const std::string& description,
                     double duration,
                     MealType mealType,
                     double caloriesConsumed)
    : Log(logID, date, duration, description),
      mealType(mealType),
      caloriesConsumed(caloriesConsumed) {}

// The computeImpact method for Nutrition calculates the impact of the nutrition log, which could be based on the calories consumed.
double Nutrition::computeImpact() const
{
    return -caloriesConsumed;
}

// The displayLog method for Nutrition provides a way to display the details of the nutrition log, including meal type and calories consumed.
void Nutrition::displayLog() const
{
	qDebug() << "Nutrition[mealType=" << toString(mealType)
         << ", caloriesConsumed=" << caloriesConsumed
         << ", impact=" << computeImpact()
         << "]";
}

// Getters for mealType and caloriesConsumed
MealType Nutrition::getMealType() const
{
	return mealType;
}

double Nutrition::getCaloriesConsumed() const
{
	return caloriesConsumed;
}

// Setters for mealType and caloriesConsumed
void Nutrition::setMealType(MealType mealType)
{
	this->mealType = mealType;
}

void Nutrition::setCaloriesConsumed(double caloriesConsumed)
{
	this->caloriesConsumed = caloriesConsumed;
}

ostream& operator<<(ostream& os, const Nutrition& nutrition)
{
    os << "Nutrition[mealType=" << toString(nutrition.mealType)
       << ", caloriesConsumed=" << nutrition.caloriesConsumed
       << ", impact=" << nutrition.computeImpact()
       << "]";
    return os;
}