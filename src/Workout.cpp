#include "Workout.h"
#include <iostream>
using namespace std;

// Constructor implementation for Workout class, initializing all attributes including those inherited from Log and the specific attributes of Workout.
Workout::Workout(const string& id, const string& date, double duration, const string& description, const string& type,
	double caloriesBurned) : Log(id, date, duration, description), type(type), caloriesBurned(caloriesBurned) {}

// The computeImpact method for Workout calculates the impact of the workout log, which could be based on the calories burned.
double Workout::computeImpact() const
{
	return caloriesBurned;
}

// The displayLog method for Workout provides a way to display the details of the workout log, including workout type and calories burned.
void Workout::displayLog() const
{
	cout << "Workout Log [" << getLogID() << "] "
		 << getDate() << " | "
		 << getDescription() << " | Duration: " << getDuration()
		 << " | Type: " << type
		 << " | Calories burned: " << caloriesBurned << '\n';
}

// Getters for type and caloriesBurned
const string& Workout::getType() const
{
	return type;
}

double Workout::getCaloriesBurned() const
{
	return caloriesBurned;
}

// Setters for type and caloriesBurned
void Workout::setType(const string& type)
{
	this->type = type;
}

void Workout::setCaloriesBurned(double caloriesBurned)
{
	this->caloriesBurned = caloriesBurned;
}

// Equality operator to compare two Workout objects based on their attributes.
bool Workout::operator==(const Workout& other) const
{
	return getLogID() == other.getLogID()
		&& getDate() == other.getDate()
		&& getDuration() == other.getDuration()
		&& getDescription() == other.getDescription()
		&& type == other.type
		&& caloriesBurned == other.caloriesBurned;
}

// Overload the stream insertion operator for easy output of Workout details, allowing us to print the workout information in a formatted way.
ostream& operator<<(ostream& os, const Workout& workout)
{
	os << "Workout{" 
	   << "id=" << workout.getLogID()
	   << ", date=" << workout.getDate()
	   << ", duration=" << workout.getDuration()
	   << ", description=" << workout.getDescription()
	   << ", type=" << workout.getType()
	   << ", caloriesBurned=" << workout.getCaloriesBurned()
	   << "}";
	return os;
}