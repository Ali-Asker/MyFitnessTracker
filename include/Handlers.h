#pragma once
#include <QObject>
#include <QString>
#include <QVariantList>
#include <QVariantMap>
#include <memory>
#include "LogManager.h"
#include "DataManager.h"
#include "Nutrition.h"
#include "StrengthWorkout.h"
#include "CardioWorkout.h"

/**
 * @brief Handlers class - Bridge between QML UI and C++ backend
 * 
 * This class connects the QML interface to your existing backend classes:
 * - LogManager: Manages all logs (Nutrition, Workouts)
 * - DataManager: Saves/loads data to JSON files
 * - Nutrition: Meal tracking
 * - StrengthWorkout/CardioWorkout: Exercise tracking
 */
class Handlers : public QObject {
    Q_OBJECT
    
    // Expose nutrition totals as properties for QML binding
    Q_PROPERTY(int totalCalories READ getTotalCalories NOTIFY nutritionChanged)
    Q_PROPERTY(int totalProtein READ getTotalProtein NOTIFY nutritionChanged)
    Q_PROPERTY(int totalCarbs READ getTotalCarbs NOTIFY nutritionChanged)
    Q_PROPERTY(int totalFats READ getTotalFats NOTIFY nutritionChanged)
    Q_PROPERTY(int totalSugar READ getTotalSugar NOTIFY nutritionChanged)
    
    // Expose workout totals
    Q_PROPERTY(int totalWorkouts READ getTotalWorkouts NOTIFY workoutsChanged)
    Q_PROPERTY(int totalWorkoutDuration READ getTotalWorkoutDuration NOTIFY workoutsChanged)
    Q_PROPERTY(int totalCaloriesBurned READ getTotalCaloriesBurned NOTIFY workoutsChanged)

public:
    explicit Handlers(QObject* parent = nullptr);
    ~Handlers() override = default;

    // ==========================================
    // NUTRITION HANDLERS
    // ==========================================
    
    /// Add a new meal to the log
    Q_INVOKABLE void addMeal(const QString& title, const QString& description,
                             int calories, int protein, int carbs, int fats, int sugar);
    
    /// Delete a meal by its log ID
    Q_INVOKABLE void deleteMeal(const QString& logID);
    
    /// Get all meals as a list for QML
    Q_INVOKABLE QVariantList getMeals() const;
    
    // Property getters for nutrition totals
    int getTotalCalories() const;
    int getTotalProtein() const;
    int getTotalCarbs() const;
    int getTotalFats() const;
    int getTotalSugar() const;

    // ==========================================
    // WORKOUT HANDLERS
    // ==========================================
    
    /// Add a new strength workout
    Q_INVOKABLE void addWorkout(const QString& title, int reps, int sets,
                                int durationMins, const QString& workoutType);
    
    /// Delete a workout by its log ID
    Q_INVOKABLE void deleteWorkout(const QString& logID);
    
    /// Get all workouts as a list for QML
    Q_INVOKABLE QVariantList getWorkouts() const;
    
    // Property getters for workout totals
    int getTotalWorkouts() const;
    int getTotalWorkoutDuration() const;
    int getTotalCaloriesBurned() const;

    // ==========================================
    // DATA PERSISTENCE
    // ==========================================
    
    /// Save all data to file
    Q_INVOKABLE void saveData();
    
    /// Load all data from file
    Q_INVOKABLE void loadData();

    // ==========================================
    // NAVIGATION
    // ==========================================
    
    Q_INVOKABLE void navigateToPage(int pageIndex);

signals:
    /// Emitted when nutrition data changes
    void nutritionChanged();
    
    /// Emitted when workout data changes
    void workoutsChanged();
    
    /// Emitted for navigation requests
    void navigationRequested(int pageIndex);
    
    /// Emitted when data is loaded
    void dataLoaded();
    
    /// Emitted on error
    void errorOccurred(const QString& message);

private:
    LogManager m_logManager;
    DataManager m_dataManager;
    
    // Counter for generating unique IDs
    int m_nextLogID;
    
    // Helper to generate unique log ID
    QString generateLogID();
    
    // Recalculate totals after changes
    void recalculateTotals();
    
    // Cached totals for performance
    int m_totalCalories = 0;
    int m_totalProtein = 0;
    int m_totalCarbs = 0;
    int m_totalFats = 0;
    int m_totalSugar = 0;
    int m_totalWorkouts = 0;
    int m_totalWorkoutDuration = 0;
    int m_totalCaloriesBurned = 0;
};

