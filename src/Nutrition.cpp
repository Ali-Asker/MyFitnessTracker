#include "Nutrition.h"
#include <iostream>
using namespace std;

// Constructor implementation for Nutrition class, initializing all attributes including those inherited from Log and the specific attributes of Nutrition.
Nutrition::Nutrition(const string& id,const string& date,double duration,const string& description,const string& mealType,
double caloriesConsumed): Log(id, date, duration, description),mealType(mealType),caloriesConsumed(caloriesConsumed) {}

// The computeImpact method for Nutrition calculates the impact of the nutrition log, which could be based on the calories consumed.
double Nutrition::computeImpact() const
{
	return caloriesConsumed;
}

// The displayLog method for Nutrition provides a way to display the details of the nutrition log, including meal type and calories consumed.
void Nutrition::displayLog() const
{
	cout << "Nutrition Log [" << getLogID() << "] "
		 << getDate() << " | "
		 << getDescription() << " | Duration: " << getDuration()
		 << " | Meal: " << mealType
		 << " | Calories: " << caloriesConsumed << '\n';
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

bool Nutrition::operator==(const Nutrition& other) const
{
	return getLogID() == other.getLogID()
		&& getDate() == other.getDate()
		&& getDuration() == other.getDuration()
		&& getDescription() == other.getDescription()
		&& mealType == other.mealType
		&& caloriesConsumed == other.caloriesConsumed;
}

ostream& operator<<(ostream& os, const Nutrition& nutrition)
{
	os << "Nutrition{" 
	   << "id=" << nutrition.getLogID()
	   << ", date=" << nutrition.getDate()
	   << ", duration=" << nutrition.getDuration()
	   << ", description=" << nutrition.getDescription()
	   << ", mealType=" << nutrition.getMealType()
	   << ", caloriesConsumed=" << nutrition.getCaloriesConsumed()
	   << "}";
	return os;
}
