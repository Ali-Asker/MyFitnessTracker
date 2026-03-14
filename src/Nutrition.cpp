#include "Nutrition.h"
#include <iomanip>
#include <iostream>
using namespace std;

// Constructor implementation for Nutrition class, initializing all attributes including those inherited from Log and the specific attributes of Nutrition.
Nutrition::Nutrition(const string& id,const string& date,double duration,const string& description,const string& mealType,
double caloriesConsumed): Log(id, date, duration, description),mealType(mealType),caloriesConsumed(caloriesConsumed) {}

// The computeImpact method for Nutrition calculates the impact of the nutrition log, which could be based on the calories consumed.
double Nutrition::computeImpact() const
{
	//Return Calories Consumed
	return caloriesConsumed;
}

// The displayLog method for Nutrition provides a way to display the details of the nutrition log, including meal type and calories consumed.
void Nutrition::displayLog() const
{
	Log :: displayLog(); //Call Base class Function
	cout << "Meal Type: " << mealType << endl; // Display Meal Type
	cout << "Calories Consumed: " << fixed << setprecision(2) << caloriesConsumed << " cals" << endl; // Display Calories Consumed
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
