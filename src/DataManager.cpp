#include "DataManager.h"
#include <QDateTime>
#include "CardioWorkout.h"
#include "Nutrition.h"
#include "StrengthWorkout.h"
#include "Workout.h"
#include "YogaWorkout.h"
#include "json.hpp"
#include <fstream>
#include <iostream>
#include <iomanip>
#include <sstream>
#include <stdexcept>
using namespace std;
using json = nlohmann::json;

// ─────────────────────────────────────────────────────────────────────────────
// saveData
// ─────────────────────────────────────────────────────────────────────────────
// Serialises every log and health metric in the LogManager to a JSON file.
// The runtime type of each log is detected via dynamic_cast so the correct
// subtype fields are included in the JSON object.
// Throws std::runtime_error if the file cannot be opened for writing.

void DataManager::saveData(const string &filename, const LogManager &logManager) const
{
    json output;
    output["logs"]          = json::array();
    output["healthMetrics"] = json::array();

    for (const auto &log : logManager.getLogs()) {
        json entry;
        entry["logID"]       = log->getLogID();
        entry["date"]        = log->getDate().toString("yyyy-MM-dd hh:mm").toStdString();
        entry["duration"]    = log->getDuration();
        entry["description"] = log->getDescription();

        if (const Workout *w = dynamic_cast<const Workout *>(log.get())) {
            entry["logType"]        = "Workout";
            entry["caloriesBurned"] = w->getCaloriesBurned();

            if (const CardioWorkout *c = dynamic_cast<const CardioWorkout *>(w)) {
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
            } else if (const StrengthWorkout *s = dynamic_cast<const StrengthWorkout *>(w)) {
                entry["workoutType"] = "Strength";
                entry["sets"]        = s->getSets();
                entry["reps"]        = s->getReps();
                entry["weight"]      = s->getWeight();
            } else if (const YogaWorkout *y = dynamic_cast<const YogaWorkout *>(w)) {
                entry["workoutType"] = "Yoga";
                entry["style"]       = y->getStyle();
                entry["intensity"]   = y->getIntensity();
            }

        } else if (const Nutrition *n = dynamic_cast<const Nutrition *>(log.get())) {
            entry["logType"]          = "Nutrition";
            entry["caloriesConsumed"] = n->getCaloriesConsumed();

            switch (n->getMealType()) {
            case MealType::Breakfast: entry["mealType"] = "Breakfast"; break;
            case MealType::Lunch:     entry["mealType"] = "Lunch";     break;
            case MealType::Dinner:    entry["mealType"] = "Dinner";    break;
            case MealType::Snack:     entry["mealType"] = "Snack";     break;
            }
        }

        output["logs"].push_back(entry);
    }

    for (const auto &metric : logManager.getMetrics()) {
        json entry;
        entry["metricID"] = metric->getMetricID();
        entry["name"]     = metric->getName();
        entry["date"]     = metric->getDate().toString("yyyy-MM-dd hh:mm").toStdString();
        entry["value"]    = metric->getValue();
        output["healthMetrics"].push_back(entry);
    }

    ofstream file(filename);
    if (!file.is_open())
        throw runtime_error("saveData: could not open file for writing: " + filename);

    file << output.dump(4);
}

// ─────────────────────────────────────────────────────────────────────────────
// loadData
// ─────────────────────────────────────────────────────────────────────────────
// Reads a JSON file produced by saveData(), clears the LogManager, then
// reconstructs every log and health metric.
// Throws std::runtime_error on file-open failure or malformed JSON.

void DataManager::loadData(const string &filename, LogManager &logManager) const
{
    ifstream file(filename);
    if (!file.is_open())
        throw runtime_error("loadData: could not open file: " + filename);

    json data;
    try {
        data = json::parse(file);
    } catch (const nlohmann::json::parse_error &e) {
        throw runtime_error("loadData: corrupted or invalid JSON: " + string(e.what()));
    }

    // Clear before populating — prevents duplicate entries on repeated loads.
    // LogManager::clear() also wipes the ID registry so load works correctly.
    logManager.clear();

    for (const auto &entry : data["logs"]) {
        string    logType     = entry["logType"];
        string    logID       = entry["logID"];
        QDateTime date        = QDateTime::fromString(
            QString::fromStdString(entry["date"].get<std::string>()), Qt::ISODate);
        double    duration    = entry["duration"];
        string    description = entry["description"];

        if (logType == "Workout") {
            std::string workoutType    = entry["workoutType"];
            double      caloriesBurned = entry["caloriesBurned"];

            if (workoutType == "Cardio") {
                std::string cardioType = entry["cardioType"];
                if (cardioType == "Distance") {
                    logManager.addLog(make_unique<CardioWorkout>(
                        logID, date, description, duration, caloriesBurned,
                        entry["distance"].get<double>(),
                        entry["pace"].get<double>(),
                        CardioType::Distance));
                } else {
                    logManager.addLog(make_unique<CardioWorkout>(
                        logID, date, description, duration, caloriesBurned,
                        entry["sets"].get<int>(),
                        entry["reps"].get<int>(),
                        CardioType::RepBased));
                }
            } else if (workoutType == "Strength") {
                logManager.addLog(make_unique<StrengthWorkout>(
                    logID, date, description, duration, caloriesBurned,
                    entry["sets"].get<int>(),
                    entry["reps"].get<int>(),
                    entry["weight"].get<double>()));
            } else if (workoutType == "Yoga") {
                logManager.addLog(make_unique<YogaWorkout>(
                    logID, date, description, duration, caloriesBurned,
                    entry["style"].get<std::string>(),
                    entry["intensity"].get<std::string>()));
            }

        } else if (logType == "Nutrition") {
            MealType    mealType;
            std::string mealTypeStr = entry["mealType"];
            if      (mealTypeStr == "Breakfast") mealType = MealType::Breakfast;
            else if (mealTypeStr == "Lunch")     mealType = MealType::Lunch;
            else if (mealTypeStr == "Dinner")    mealType = MealType::Dinner;
            else                                 mealType = MealType::Snack;

            logManager.addLog(make_unique<Nutrition>(
                logID, date, description, duration,
                mealType, entry["caloriesConsumed"].get<double>()));

        } else {
            cerr << "loadData: unknown logType '" << logType << "' — skipping.\n";
        }
    }

    for (const auto &entry : data["healthMetrics"]) {
        QDateTime date = QDateTime::fromString(
            QString::fromStdString(entry["date"].get<std::string>()), Qt::ISODate);
        logManager.addMetric(make_unique<HealthMetric>(
            entry["metricID"].get<std::string>(),
            entry["name"].get<std::string>(),
            date,
            entry["value"].get<double>()));
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// exportSummary
// ─────────────────────────────────────────────────────────────────────────────
// Writes a human-readable plain-text summary report to `filename`.
//
// The report contains four sections:
//   1. Overview  — aggregate counts and calorie totals
//   2. Workouts  — one line per workout with type-specific details
//   3. Nutrition — one line per meal
//   4. Health Metrics — one line per metric
//
// This is separate from saveData/loadData and is intended as a user-facing
// export (e.g. "Export Report" menu item) rather than a persistence format.
// Throws std::runtime_error if the output file cannot be created.

void DataManager::exportSummary(const string &filename, const LogManager &logManager) const
{
    ofstream out(filename);
    if (!out.is_open())
        throw runtime_error("exportSummary: could not open file for writing: " + filename);

    // ── Helper: horizontal rule ───────────────────────────────────────────────
    auto hr = [&](char c = '-', int w = 72) {
        out << string(w, c) << "\n";
    };

    // ── Timestamp ─────────────────────────────────────────────────────────────
    std::string generated =
        QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss").toStdString();

    // ── Collect summary data ──────────────────────────────────────────────────
    int    totalWorkouts   = 0;
    int    totalMeals      = 0;
    double totalDuration   = 0.0;
    double totalBurned     = 0.0;
    double totalConsumed   = 0.0;

    // Pass 1: accumulate totals
    for (const auto &log : logManager.getLogs()) {
        if (const Workout *w = dynamic_cast<const Workout *>(log.get())) {
            ++totalWorkouts;
            totalDuration += w->getDuration();
            totalBurned   += w->getCaloriesBurned();
        } else if (const Nutrition *n = dynamic_cast<const Nutrition *>(log.get())) {
            ++totalMeals;
            totalConsumed += n->getCaloriesConsumed();
        }
    }
    double netCalories = totalConsumed - totalBurned;

    // ── Header ────────────────────────────────────────────────────────────────
    hr('=');
    out << "  MyFitnessTracker — Data Export Summary\n";
    out << "  Generated: " << generated << "\n";
    hr('=');
    out << "\n";

    // ── Section 1: Overview ───────────────────────────────────────────────────
    out << "OVERVIEW\n";
    hr();
    out << left << setw(30) << "Total workout sessions:"  << totalWorkouts   << "\n";
    out << left << setw(30) << "Total meal entries:"      << totalMeals      << "\n";
    out << left << setw(30) << "Total workout time:"
        << fixed << setprecision(1) << totalDuration << " min\n";
    out << left << setw(30) << "Total calories burned:"
        << fixed << setprecision(1) << totalBurned   << " kcal\n";
    out << left << setw(30) << "Total calories consumed:"
        << fixed << setprecision(1) << totalConsumed << " kcal\n";
    out << left << setw(30) << "Net calories:"
        << fixed << setprecision(1) << netCalories
        << " kcal  (" << (netCalories <= 0 ? "deficit" : "surplus") << ")\n";
    out << left << setw(30) << "Health metric entries:"
        << logManager.getMetrics().size() << "\n";
    out << "\n";

    // ── Section 2: Workouts ───────────────────────────────────────────────────
    out << "WORKOUTS  (" << totalWorkouts << " entries)\n";
    hr();

    if (totalWorkouts == 0) {
        out << "  (none)\n";
    } else {
        // Column header
        out << left
            << setw(8)  << "ID"
            << setw(13) << "Date"
            << setw(12) << "Type"
            << setw(8)  << "Dur"
            << setw(10) << "Calories"
            << "Details\n";
        hr('-', 72);

        for (const auto &log : logManager.getLogs()) {
            const Workout *w = dynamic_cast<const Workout *>(log.get());
            if (!w) continue;

            std::string typeStr;
            std::string details;

            if (const CardioWorkout *c = dynamic_cast<const CardioWorkout *>(w)) {
                typeStr = "Cardio";
                if (c->getCardioType() == CardioType::Distance) {
                    ostringstream oss;
                    oss << fixed << setprecision(1)
                        << c->getDistance() << " km @ "
                        << c->getPace()     << " min/km";
                    details = oss.str();
                } else {
                    details = to_string(c->getSets()) + " sets x "
                              + to_string(c->getReps()) + " reps";
                }
            } else if (const StrengthWorkout *s = dynamic_cast<const StrengthWorkout *>(w)) {
                typeStr = "Strength";
                ostringstream oss;
                oss << s->getSets() << "x" << s->getReps()
                    << " @ " << fixed << setprecision(1) << s->getWeight() << " kg";
                details = oss.str();
            } else if (const YogaWorkout *y = dynamic_cast<const YogaWorkout *>(w)) {
                typeStr = "Yoga";
                details = y->getStyle() + " / " + y->getIntensity();
            }

            out << left
                << setw(8)  << w->getLogID()
                << setw(13) << w->getDate().toString("yyyy-MM-dd").toStdString()
                << setw(12) << typeStr
                << setw(8)  << (to_string(static_cast<int>(w->getDuration())) + " min")
                << setw(10) << (to_string(static_cast<int>(w->getCaloriesBurned())) + " kcal")
                << details  << "\n";
        }
    }
    out << "\n";

    // ── Section 3: Nutrition ──────────────────────────────────────────────────
    out << "NUTRITION  (" << totalMeals << " entries)\n";
    hr();

    if (totalMeals == 0) {
        out << "  (none)\n";
    } else {
        out << left
            << setw(8)  << "ID"
            << setw(13) << "Date"
            << setw(12) << "Meal"
            << setw(10) << "Calories"
            << "Description\n";
        hr('-', 72);

        for (const auto &log : logManager.getLogs()) {
            const Nutrition *n = dynamic_cast<const Nutrition *>(log.get());
            if (!n) continue;

            std::string mealStr;
            switch (n->getMealType()) {
            case MealType::Breakfast: mealStr = "Breakfast"; break;
            case MealType::Lunch:     mealStr = "Lunch";     break;
            case MealType::Dinner:    mealStr = "Dinner";    break;
            case MealType::Snack:     mealStr = "Snack";     break;
            }

            out << left
                << setw(8)  << n->getLogID()
                << setw(13) << n->getDate().toString("yyyy-MM-dd").toStdString()
                << setw(12) << mealStr
                << setw(10) << (to_string(static_cast<int>(n->getCaloriesConsumed())) + " kcal")
                << n->getDescription() << "\n";
        }
    }
    out << "\n";

    // ── Section 4: Health Metrics ─────────────────────────────────────────────
    out << "HEALTH METRICS  (" << logManager.getMetrics().size() << " entries)\n";
    hr();

    if (logManager.getMetrics().empty()) {
        out << "  (none)\n";
    } else {
        out << left
            << setw(8)  << "ID"
            << setw(13) << "Date"
            << setw(20) << "Metric"
            << "Value\n";
        hr('-', 72);

        for (const auto &m : logManager.getMetrics()) {
            ostringstream valStr;
            valStr << fixed << setprecision(2) << m->getValue();

            out << left
                << setw(8)  << m->getMetricID()
                << setw(13) << m->getDate().toString("yyyy-MM-dd").toStdString()
                << setw(20) << m->getName()
                << valStr.str() << "\n";
        }
    }
    out << "\n";

    hr('=');
    out << "  End of report\n";
    hr('=');
}
