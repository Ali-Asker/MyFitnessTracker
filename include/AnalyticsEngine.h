#pragma once
#include <vector>

template <typename T>
class AnalyticsEngine {
public:
    double computeTotalWorkoutTime(const std::vector<T*>& logs) const;
    double computeTotalCaloriesBurned(const std::vector<T*>& logs) const;
    double computeTotalCaloriesConsumed(const std::vector<T*>& logs) const;
    double computeNetCalories(double totalConsumed, double totalBurned) const;
    double computeGoalProgress(double currentValue, double goalValue) const;
};