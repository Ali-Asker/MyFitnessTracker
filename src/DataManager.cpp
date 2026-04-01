#include "DataManager.h"
#include "CardioWorkout.h"
#include "StrengthWorkout.h"
#include "YogaWorkout.h"
#include "Workout.h"
#include "Nutrition.h"
#include "json.hpp"
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <QDateTime>
using namespace std;
using json = nlohmann::json;

// Saves the current state of the LogManager to a file specified by filename.
// Iterates through all logs and health metrics in the LogManager, serializes each one
// into a JSON object, and writes the entire structure to the specified file.
// Throws a runtime_error if the file cannot be opened for writing.

void DataManager::saveData(const string& filename, const LogManager& logManager) const
{
    json output;
    output["logs"] = json::array();
    output["healthMetrics"] = json::array();

    // Serialize each log — we check the runtime type to know which fields to include
    for (const auto& log : logManager.getLogs())
    {
        json entry;
        entry["logID"]       = log->getLogID();
        entry["date"]        = log->getDate().toString("yyyy-MM-dd hh:mm").toStdString();
        entry["duration"]    = log->getDuration();
        entry["description"] = log->getDescription();

        // dynamic_cast to check if the log is a Workout or Nutrition at runtime
        if (const Workout* w = dynamic_cast<const Workout*>(log.get()))
        {
            entry["logType"]        = "Workout";
            entry["caloriesBurned"] = w->getCaloriesBurned();

            if (const CardioWorkout* c = dynamic_cast<const CardioWorkout*>(w))
            {
                entry["workoutType"] = "Cardio";
                if (c->getCardioType() == CardioType::Distance) {
                    entry["cardioType"] = "Distance";
                    entry["distance"]   = c->getDistance();
                    entry["pace"]       = c->getPace();
                } else {
                    entry["cardioType"] = "RepBased";
                    entry["sets"]       = c->getSets();
                    entry["reps"]       = c->getReps();
                }
            } 
            else if (const StrengthWorkout* s = dynamic_cast<const StrengthWorkout*>(w))
            {
                entry["workoutType"] = "Strength";
                entry["sets"]        = s->getSets();
                entry["reps"]        = s->getReps();
                entry["weight"]      = s->getWeight();
            }
            else if (const YogaWorkout* y = dynamic_cast<const YogaWorkout*>(w))
            {
                entry["workoutType"] = "Yoga";
                entry["style"]       = y->getStyle();
                entry["intensity"]   = y->getIntensity();
            }
        }
        else if (const Nutrition* n = dynamic_cast<const Nutrition*>(log.get()))
        {
            entry["logType"]           = "Nutrition";
            entry["caloriesConsumed"]  = n->getCaloriesConsumed();

            switch (n->getMealType()) {
                case MealType::Breakfast: entry["mealType"] = "Breakfast"; break;
                case MealType::Lunch:     entry["mealType"] = "Lunch";     break;
                case MealType::Dinner:    entry["mealType"] = "Dinner";    break;
                case MealType::Snack:     entry["mealType"] = "Snack";     break;
            }
        }

        output["logs"].push_back(entry);
    }

    // Serialize each health metric — all fields are in the base class, no casting needed
    for (const auto& metric : logManager.getMetrics())
    {
        json entry;
        entry["metricID"] = metric->getMetricID();
        entry["name"]     = metric->getName();
        entry["date"]     = metric->getDate().toString("yyyy-MM-dd hh:mm").toStdString();
        entry["value"]    = metric->getValue();

        output["healthMetrics"].push_back(entry);
    }

    // Write the JSON to file with 4-space indentation for human readability
    ofstream file(filename);
    if (!file.is_open())
        throw runtime_error("saveData: could not open file for writing: " + filename);

    file << output.dump(4);
}

// Loads the state of the LogManager from a file specified by filename, replacing any existing data in logManager.

// Reads the JSON file at the given path, clears the existing LogManager state,
// and reconstructs all logs and health metrics from the parsed data.
// Throws a runtime_error if the file cannot be opened or if the JSON is malformed.
void DataManager::loadData(const string& filename, LogManager& logManager) const
{
    ifstream file(filename);
    if (!file.is_open())
        throw runtime_error("loadData: could not open file: " + filename);

    json data;
    try
    {
        data = json::parse(file);
    }
    catch (const nlohmann::json::parse_error& e)
    {
        throw runtime_error("loadData: corrupted or invalid JSON file: " + string(e.what()));
    }

    // Clear existing data before populating — prevents duplicate entries on repeated loads
    logManager.clear();

    // Reconstruct each log — branch on logType to instantiate the correct subclass
    for (const auto& entry : data["logs"])
    {
        string logType     = entry["logType"];
        string logID       = entry["logID"];
        QDateTime date     = QDateTime::fromString(QString::fromStdString(entry["date"].get<std::string>()), Qt::ISODate);
        double duration    = entry["duration"];
        string description = entry["description"];

        if (logType == "Workout")
        {
            std::string workoutType = entry["workoutType"];
            double caloriesBurned   = entry["caloriesBurned"];

            if (workoutType == "Cardio") {
                std::string cardioType = entry["cardioType"]; 
                if (cardioType == "Distance") {
                    double distance   = entry["distance"];
                    double pace       = entry["pace"];
                    logManager.addLog(make_unique<CardioWorkout>(logID, date, description, duration, caloriesBurned, distance, pace, CardioType::Distance));
                } else if (cardioType == "RepBased") {
                    int sets          = entry["sets"];
                    int reps          = entry["reps"];
                    logManager.addLog(make_unique<CardioWorkout>(logID, date, description, duration, caloriesBurned, sets, reps, CardioType::RepBased));
                } 
            } else if (workoutType == "Strength") {
                int sets              = entry["sets"];
                int reps              = entry["reps"];
                double weight         = entry["weight"];
                logManager.addLog(make_unique<StrengthWorkout>(logID, date, description, duration, caloriesBurned, sets, reps, weight));
            } else if (workoutType == "Yoga") {
                std::string style     = entry["style"];
                std::string intensity = entry["intensity"];
                logManager.addLog(make_unique<YogaWorkout>(logID, date, description, duration, caloriesBurned, style, intensity));
            }
        }
        else if (logType == "Nutrition")
        {
            MealType mealType;
            std::string mealTypeStr = entry["mealType"];
            if (mealTypeStr == "Breakfast")     mealType = MealType::Breakfast;
            else if (mealTypeStr == "Lunch")    mealType = MealType::Lunch;
            else if (mealTypeStr == "Dinner")   mealType = MealType::Dinner;
            else                                mealType = MealType::Snack;

            double caloriesConsumed = entry["caloriesConsumed"];
            logManager.addLog(make_unique<Nutrition>(logID, date, description, duration, mealType, caloriesConsumed));
        }
        else
        {
            cerr << "loadData: unknown logType '" << logType << "' — skipping entry.\n";
        }
    }

    // Reconstruct each health metric — all fields are flat, no subclass branching needed
    for (const auto& entry : data["healthMetrics"])
    {
        string metricID = entry["metricID"];
        string name     = entry["name"];
        QDateTime date  = QDateTime::fromString(QString::fromStdString(entry["date"].get<std::string>()), Qt::ISODate);
        double value    = entry["value"];
        logManager.addMetric(make_unique<HealthMetric>(metricID, name, date, value));
    }
}