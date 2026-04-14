#include "Workout.h"
#include <QDebug>
#include <string>
#include <QDateTime>
using namespace std;

namespace {
	// Helper method to convert enum to string
	const char* toString(WorkoutType type)
	{
		switch (type) {
		case WorkoutType::Cardio:
			return "Cardio";
		case WorkoutType::Strength:
			return "Strength";
		case WorkoutType::Yoga:
			return "Yoga";
		}
		return "Unknown";
	}
}

// Constructor implementation for Workout class, initializing all attributes including those inherited from Log and the specific attributes of Workout.
Workout::Workout(const std::string& logID, const QDateTime& date, const std::string& description, double duration, const WorkoutType type, double caloriesBurned)
		: Log(logID, date, duration, description), type(type), caloriesBurned(caloriesBurned) {}

// The computeImpact method for Workout calculates the impact of the workout log, which could be based on the calories burned.
double Workout::computeImpact() const
{
    return caloriesBurned;
}

// The displayLog method for Workout provides a way to display the details of the workout log, including workout type and calories burned.
void Workout::displayLog() const
{
	qDebug() << "Workout[type=" << toString(type)
         << ", caloriesBurned=" << caloriesBurned
         << ", impact=" << computeImpact()
         << "]";
}

// Getters for type and caloriesBurned
WorkoutType Workout::getType() const
{
	return type;
}

double Workout::getCaloriesBurned() const
{
	return caloriesBurned;
}

// Setters for type and caloriesBurned
void Workout::setType(WorkoutType type)
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
	return type == other.type &&
           caloriesBurned == other.caloriesBurned;
}

// Overload the stream insertion operator for easy output of Workout details, allowing us to print the workout information in a formatted way.
ostream& operator<<(ostream& os, const Workout& workout)
{
	os << "Workout[type=" << toString(workout.type)
		<< ", caloriesBurned=" << workout.caloriesBurned
		<< ", impact=" << workout.computeImpact()
		<< "]";
		return os;
}
