#include "../include/Analytics.h"
#include <numeric>
#include <vector>
#include "../include/Workouts/Workout.h"
#include "../include/Nutrition.h"
#include <QDebug>

/*
 computeTotalWorkoutTime: This function computes the total workout time from a vector of logs.
 It iterates through the logs and checks if each log is of type T and adds up the duration to calculate
 the total workout time.
*/
template <typename T>
double Analytics<T>::computeTotalWorkoutTime(const std::vector<T*>& logs) const {
    double totalWorkoutTime = 0.0;
    for (auto log : logs) { // Loop through logs
        Workout* workout = dynamic_cast<Workout*>(log);
        //if log is valid
        if (workout != nullptr) {
            //Add duration of workout to total workout time
            totalWorkoutTime += workout->getDuration();
        }

    }
    //Return total workout time
    return totalWorkoutTime;
}
/*
computeTotalCaloriesBurned: This function computes the total calories burned from a vector of logs.
It iterates through the logs, checks if each log is of type T, and adds up the calories burned from
those logs to calculate the total calories burned.
*/
template <typename T>
double Analytics<T>::computeTotalCaloriesBurned(const std::vector<T*>& logs) const {
    double totalCaloriesBurned = 0.0;
    for (auto log : logs) { // Loop through logs
        Workout* workout = dynamic_cast<Workout*>(log);
        //if log is valid
        if (workout != nullptr) {
            //Add calories burned from workout to total calories burned
            totalCaloriesBurned += workout->getCaloriesBurned();
        }
        //Return total calories burned

    }

    return totalCaloriesBurned;
}
/*
computeTotalCaloriesConsumed: This function computes the total calories consumed from a vector of logs. It iterates through the logs,
checks if each log is of type T (e.g., Nutrition), and sums up the calories consumed from those logs to calculate the total calories
consumed.
*/
template <typename T>
double Analytics<T>::computeTotalCaloriesConsumed(const std::vector<T*>& logs) const {
    double totalCaloriesConsumed = 0.0;
    for (auto log : logs) { // Loop through logs
        Nutrition* nutrition = dynamic_cast<Nutrition*>(log);
        //if log is valid
        if (nutrition != nullptr) {
            //Add calories consumed from nutrition log to total calories consumed
            totalCaloriesConsumed += nutrition->getCaloriesConsumed();
        }
        //Return total calories consumed

    }
    return totalCaloriesConsumed;
}
/*
computeNetCalories: This function computes the net calories by subtracting the total calories burned from the total calories consumed.
It takes two parameters: totalConsumed and totalBurned. The function returns the net calories as a double value.
*/
template <typename T>
double Analytics<T>::computeNetCalories(double totalConsumed, double totalBurned) const {
    //Calculate net calories by subtracting total calories burned from total calories consumed
    return totalConsumed - totalBurned;

}
/*
computeGoalProgress: This function computes the progress towards a goal by calculating the percentage of the current value compared to the goal value.
If the goal value is zero, it displays a warning message as the goal value cannot be zero
*/
template <typename T>
double Analytics<T>::computeGoalProgress(double currentValue, double goalValue) const {
    if (goalValue == 0.0) { // Error Checking
        // Display warning message if goal value is zero to prevent division by zero error
        qDebug() << "The Goal Value cannot be 0";
        return -1.0;
    }
    //Calculate goal progress as a percentage by dividing current value by goal value and multiplying by 100
    return (currentValue / goalValue) * 100.0;


}