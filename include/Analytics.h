#pragma once
#include <vector>

template <typename T>
class Analytics {
public:
	// Computes the total workout time from a vector of logs. It iterates through the logs, checks if each log is of type T 
    // (e.g., Workout), and sums up the duration of those logs to calculate the total workout time.
    Analytics() = default;
    double computeTotalWorkoutTime(const std::vector<T*>& logs) const;
    double computeTotalCaloriesBurned(const std::vector<T*>& logs) const;
    double computeTotalCaloriesConsumed(const std::vector<T*>& logs) const;
    double computeNetCalories(double totalConsumed, double totalBurned) const;
    double computeGoalProgress(double currentValue, double goalValue) const;
};