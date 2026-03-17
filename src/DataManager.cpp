#include "DataManager.h"
#include "Workout.h"
#include "Nutrition.h"
#include "json.hpp"
#include <fstream>
#include <iostream>
#include <stdexcept>
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
        entry["date"]        = log->getDate();
        entry["duration"]    = log->getDuration();
        entry["description"] = log->getDescription();

        // dynamic_cast to check if the log is a Workout or Nutrition at runtime
        if (const Workout* w = dynamic_cast<const Workout*>(log.get()))
        {
            entry["logType"]       = "Workout";
            entry["workoutType"]   = w->getType();
            entry["caloriesBurned"] = w->getCaloriesBurned();
        }
        else if (const Nutrition* n = dynamic_cast<const Nutrition*>(log.get()))
        {
            entry["logType"]           = "Nutrition";
            entry["mealType"]          = n->getMealType();
            entry["caloriesConsumed"]  = n->getCaloriesConsumed();
        }

        output["logs"].push_back(entry);
    }

    // Serialize each health metric — all fields are in the base class, no casting needed
    for (const auto& metric : logManager.getMetrics())
    {
        json entry;
        entry["metricID"] = metric->getMetricID();
        entry["name"]     = metric->getName();
        entry["date"]     = metric->getDate();
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
        string logType    = entry["logType"];
        string logID      = entry["logID"];
        string date       = entry["date"];
        double duration   = entry["duration"];
        string description = entry["description"];

        if (logType == "Workout")
        {
            string workoutType    = entry["workoutType"];
            double caloriesBurned = entry["caloriesBurned"];
            logManager.addLog(make_unique<Workout>(logID, date, description, duration, workoutType, caloriesBurned));
        }
        else if (logType == "Nutrition")
        {
            string mealType          = entry["mealType"];
            double caloriesConsumed  = entry["caloriesConsumed"];
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
        string date     = entry["date"];
        double value    = entry["value"];
        logManager.addMetric(make_unique<HealthMetric>(metricID, name, date, value));
    }
}
