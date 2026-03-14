#include "Nutrition.h"
#include <iostream>
using namespace std;

// Constructor implementation for Nutrition class, initializing all attributes including those inherited from Log and the specific attributes of Nutrition.
Nutrition::Nutrition(const std::string& logID,
                     const std::string& date,
                     const std::string& description,
                     double duration,
                     const std::string& mealType,
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
	cout << "Nutrition[mealType=" << mealType
         << ", caloriesConsumed=" << caloriesConsumed
         << ", impact=" << computeImpact()
         << "]\n";
}

// Getters for mealType and caloriesConsumed
const string& Nutrition::getMealType() const
{
	return mealType;
}

double Nutrition::getCaloriesConsumed() const
{
	return caloriesConsumed;
}

// Setters for mealType and caloriesConsumed
void Nutrition::setMealType(const string& mealType)
{
	this->mealType = mealType;
}

void Nutrition::setCaloriesConsumed(double caloriesConsumed)
{
	this->caloriesConsumed = caloriesConsumed;
}

ostream& operator<<(ostream& os, const Nutrition& nutrition)
{
    os << "Nutrition[mealType=" << nutrition.mealType
       << ", caloriesConsumed=" << nutrition.caloriesConsumed
       << ", impact=" << nutrition.computeImpact()
       << "]";
    return os;
}