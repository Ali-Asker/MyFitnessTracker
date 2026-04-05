#include "Handlers.h"
#include <QDebug>
#include <QDateTime>

Handlers::Handlers(QObject* parent)
    : QObject(parent)
    , m_nextLogID(1)
{
    qDebug() << "Handlers initialized - connected to LogManager and DataManager";
    
    // Load existing data on startup
    loadData();
}

// ==========================================
// HELPER FUNCTIONS
// ==========================================

QString Handlers::generateLogID() {
    return QString("L%1").arg(m_nextLogID++, 5, 10, QChar('0'));
}

void Handlers::recalculateTotals() {
    m_totalCalories = 0;
    m_totalProtein = 0;
    m_totalCarbs = 0;
    m_totalFats = 0;
    m_totalSugar = 0;
    m_totalWorkouts = 0;
    m_totalWorkoutDuration = 0;
    m_totalCaloriesBurned = 0;
    
    for (const auto& log : m_logManager.getLogs()) {
        // Check if it's a Nutrition log
        if (auto* nutrition = dynamic_cast<Nutrition*>(log.get())) {
            m_totalCalories += static_cast<int>(nutrition->getCaloriesConsumed());
            m_totalProtein += static_cast<int>(nutrition->getProtein());
            m_totalCarbs += static_cast<int>(nutrition->getCarbs());
            m_totalFats += static_cast<int>(nutrition->getFats());
            m_totalSugar += static_cast<int>(nutrition->getSugar());
        }
        // Check if it's a Workout log
        else if (auto* workout = dynamic_cast<Workout*>(log.get())) {
            m_totalWorkouts++;
            m_totalWorkoutDuration += static_cast<int>(workout->getDuration());
            m_totalCaloriesBurned += static_cast<int>(workout->getCaloriesBurned());
        }
    }
}

// ==========================================
// NUTRITION HANDLERS
// ==========================================

void Handlers::addMeal(const QString& title, const QString& description,
                       int calories, int protein, int carbs, int fats, int sugar) {
    qDebug() << "Adding meal:" << title << "| Calories:" << calories;
    
    QString logID = generateLogID();
    
    auto nutrition = std::make_unique<Nutrition>(
        logID.toStdString(),
        QDateTime::currentDateTime(),
        description.toStdString(),
        0.0,  // duration (not used for meals)
        MealType::Snack,  // default meal type
        static_cast<double>(calories),
        static_cast<double>(protein),
        static_cast<double>(carbs),
        static_cast<double>(fats),
        static_cast<double>(sugar),
        title.toStdString()
    );
    
    m_logManager.addLog(std::move(nutrition));
    recalculateTotals();
    
    emit nutritionChanged();
    saveData();
}

void Handlers::deleteMeal(const QString& logID) {
    qDebug() << "Deleting meal:" << logID;
    
    m_logManager.deleteLog(logID.toStdString());
    recalculateTotals();
    
    emit nutritionChanged();
    saveData();
}

QVariantList Handlers::getMeals() const {
    QVariantList meals;
    
    for (const auto& log : m_logManager.getLogs()) {
        if (auto* nutrition = dynamic_cast<Nutrition*>(log.get())) {
            QVariantMap meal;
            meal["id"] = QString::fromStdString(nutrition->getLogID());
            meal["title"] = QString::fromStdString(nutrition->getTitle());
            meal["description"] = QString::fromStdString(nutrition->getDescription());
            meal["calories"] = static_cast<int>(nutrition->getCaloriesConsumed());
            meal["protein"] = static_cast<int>(nutrition->getProtein());
            meal["carbs"] = static_cast<int>(nutrition->getCarbs());
            meal["fats"] = static_cast<int>(nutrition->getFats());
            meal["sugar"] = static_cast<int>(nutrition->getSugar());
            meal["date"] = nutrition->getDate().toString("yyyy-MM-dd");
            meals.append(meal);
        }
    }
    
    return meals;
}

int Handlers::getTotalCalories() const { return m_totalCalories; }
int Handlers::getTotalProtein() const { return m_totalProtein; }
int Handlers::getTotalCarbs() const { return m_totalCarbs; }
int Handlers::getTotalFats() const { return m_totalFats; }
int Handlers::getTotalSugar() const { return m_totalSugar; }

// ==========================================
// WORKOUT HANDLERS
// ==========================================

void Handlers::addWorkout(const QString& title, int reps, int sets,
                          int durationMins, const QString& workoutType) {
    qDebug() << "Adding workout:" << title << "| Type:" << workoutType
             << "| Reps:" << reps << "| Sets:" << sets << "| Duration:" << durationMins;
    
    QString logID = generateLogID();
    
    // Estimate calories burned: ~5 cal per minute
    double caloriesBurned = durationMins * 5.0;
    
    // Create a StrengthWorkout for chest/arm/leg types
    auto workout = std::make_unique<StrengthWorkout>(
        logID.toStdString(),
        QDateTime::currentDateTime(),
        title.toStdString(),
        static_cast<double>(durationMins),
        caloriesBurned,
        sets,
        reps,
        0.0  // weight (not tracked in UI yet)
    );
    
    m_logManager.addLog(std::move(workout));
    recalculateTotals();
    
    emit workoutsChanged();
    saveData();
}

void Handlers::deleteWorkout(const QString& logID) {
    qDebug() << "Deleting workout:" << logID;
    
    m_logManager.deleteLog(logID.toStdString());
    recalculateTotals();
    
    emit workoutsChanged();
    saveData();
}

QVariantList Handlers::getWorkouts() const {
    QVariantList workouts;
    
    for (const auto& log : m_logManager.getLogs()) {
        if (auto* workout = dynamic_cast<StrengthWorkout*>(log.get())) {
            QVariantMap w;
            w["id"] = QString::fromStdString(workout->getLogID());
            w["title"] = QString::fromStdString(workout->getDescription());
            w["reps"] = workout->getReps();
            w["sets"] = workout->getSets();
            w["duration"] = static_cast<int>(workout->getDuration());
            w["caloriesBurned"] = static_cast<int>(workout->getCaloriesBurned());
            w["date"] = workout->getDate().toString("yyyy-MM-dd");
            workouts.append(w);
        }
        else if (auto* workout = dynamic_cast<Workout*>(log.get())) {
            QVariantMap w;
            w["id"] = QString::fromStdString(workout->getLogID());
            w["title"] = QString::fromStdString(workout->getDescription());
            w["reps"] = 0;
            w["sets"] = 0;
            w["duration"] = static_cast<int>(workout->getDuration());
            w["caloriesBurned"] = static_cast<int>(workout->getCaloriesBurned());
            w["date"] = workout->getDate().toString("yyyy-MM-dd");
            workouts.append(w);
        }
    }
    
    return workouts;
}

int Handlers::getTotalWorkouts() const { return m_totalWorkouts; }
int Handlers::getTotalWorkoutDuration() const { return m_totalWorkoutDuration; }
int Handlers::getTotalCaloriesBurned() const { return m_totalCaloriesBurned; }

// ==========================================
// DATA PERSISTENCE
// ==========================================

void Handlers::saveData() {
    qDebug() << "Saving data to fitness_data.json...";
    try {
        m_dataManager.saveData("fitness_data.json", m_logManager);
        qDebug() << "Data saved successfully";
    } catch (const std::exception& e) {
        qWarning() << "Failed to save data:" << e.what();
        emit errorOccurred(QString("Failed to save data: %1").arg(e.what()));
    }
}

void Handlers::loadData() {
    qDebug() << "Loading data from fitness_data.json...";
    try {
        m_dataManager.loadData("fitness_data.json", m_logManager);
        recalculateTotals();
        
        // Update next log ID based on existing logs
        for (const auto& log : m_logManager.getLogs()) {
            QString id = QString::fromStdString(log->getLogID());
            if (id.startsWith("L")) {
                int num = id.mid(1).toInt();
                if (num >= m_nextLogID) {
                    m_nextLogID = num + 1;
                }
            }
        }
        
        emit nutritionChanged();
        emit workoutsChanged();
        emit dataLoaded();
        qDebug() << "Data loaded successfully -" << m_logManager.getLogs().size() << "logs";
    } catch (const std::exception& e) {
        qWarning() << "Failed to load data:" << e.what();
        // Not emitting error - file might not exist on first run
    }
}

// ==========================================
// NAVIGATION
// ==========================================

void Handlers::navigateToPage(int pageIndex) {
    qDebug() << "Navigation requested to page:" << pageIndex;
    emit navigationRequested(pageIndex);
}

