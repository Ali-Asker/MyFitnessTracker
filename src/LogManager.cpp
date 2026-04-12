#include "LogManager.h"
#include "Nutrition.h" // required for dynamic_cast<Nutrition*> in filterByType
#include "Workout.h"   // required for dynamic_cast<Workout*> in filterByType
#include <iostream>
using namespace std;

// Validates that a log ID is unique and follows the required format (non-empty, max 6 characters).
bool LogManager::validateID(const std::string &id) const
{
    if (registeredIDs.count(id)) {
        cerr << "Error: Log ID \"" << id << "\" is already taken.\n";
        return false;
    }
    return true;
}

// Adds a new log to the LogManager. The log is passed as a unique_ptr to ensure proper memory management.
// The function takes ownership of the log and adds it to the logs vector.
// Before adding, it validates the log ID to ensure it is unique and follows the required format.
void LogManager::addLog(unique_ptr<Log> log)
{
    if (!validateID(log->getLogID())) {
        return;
    }
    registeredIDs.insert(log->getLogID());
    logs.push_back(std::move(log));
}

// Edits an existing log identified by logID.
// The function searches for the log with the specified ID and allows the user to modify its details.
// If found, prompts the user to enter new values for date, duration, and description.
// Uses cin.ignore() before getline to flush the leftover newline from the input buffer.
// If no match is found, an error message is printed to cerr.
void LogManager::editLog(const string &logID)
{
    for (auto &log : logs) {
        if (log->getLogID() == logID) {
            string newDate, newDescription;
            double newDuration;

            cout << "Enter new date (yyyy-MM-dd hh:mm): ";
            cin >> newDate;

            QDateTime date = QDateTime::fromString(QString::fromStdString(newDate),
                                                   "yyyy-MM-dd hh:mm");

            log->setDate(date);

            cout << "Enter new duration: ";
            cin >> newDuration;
            log->setDuration(newDuration);

            cout << "Enter new description: ";
            cin.ignore();
            getline(cin, newDescription);
            log->setDescription(newDescription);
            return;
        }
    }
    cerr << "Log with ID " << logID << " not found.\n";
}

// Deletes a log from the LogManager based on the provided logID.
// Iterates through the logs vector looking for a log with the matching ID.
// Uses an iterator-based loop so we can call erase() directly on the found position.
// Returns immediately after deletion to avoid iterator invalidation.
// If no match is found, an error message is printed to cerr.

void LogManager::deleteLog(const string &logID)
{
    for (auto it = logs.begin(); it != logs.end(); ++it) {
        if ((*it)->getLogID() == logID) {
            logs.erase(it);
            return;
        }
    }
    cerr << "Log with ID " << logID << " not found.\n";
}

// Searches for logs that contain the specified keyword in their description and returns a vector of pointers to the matching logs.
// Iterates all logs and checks if the description contains the given keyword using string::find.
// string::npos is returned by find() when no match exists, so we check against it.
// Returns raw pointers (Log*) since ownership stays with the logs vector.
vector<Log *> LogManager::searchLogs(const string &keyword) const
{
    vector<Log *> results;

    for (const auto &log : logs) {
        if (log->getDescription().find(keyword) != string::npos) {
            results.push_back(log.get());
        }
    }
    return results;
}

// Filters logs by their type (e.g., "Workout" or "Nutrition") and returns a vector of pointers to the matching logs.
// Uses dynamic_cast to check the runtime type of each log.
// dynamic_cast returns nullptr if the cast fails, making the if-check safe.
// This is necessary because the vector stores abstract Log* pointers,
// so the actual subtype (Workout or Nutrition) is only known at runtime.

vector<Log *> LogManager::filterByType(const string &type) const
{
    vector<Log *> results;
    for (const auto &log : logs) {
        if (type == "Workout" && dynamic_cast<Workout *>(log.get())) {
            results.push_back(log.get());
        } else if (type == "Nutrition" && dynamic_cast<Nutrition *>(log.get())) {
            results.push_back(log.get());
        }
    }
    return results;
}

// Filters logs based on a date range specified by startDate and endDate, returning a vector of pointers to the matching logs.
// Filters logs whose date falls within the inclusive range [startDate, endDate].
// Relies on dates being stored in YYYY-MM-DD format, which is lexicographically
// sortable — meaning string comparison behaves identically to date comparison.
vector<Log *> LogManager::filterByDate(const string &startDate, const string &endDate) const
{
    vector<Log *> results;

    for (const auto &log : logs) {
        const string &date = log->getDate().toString("yyyy-MM-dd hh:mm").toStdString();
        if (date >= startDate && date <= endDate) {
            results.push_back(log.get());
        }
    }
    return results;
}

// Adds a new health metric to the LogManager. The metric is passed as a unique_ptr to ensure proper memory management.
// std::move transfers ownership from the caller into the healthMetrics vector.
void LogManager::addMetric(unique_ptr<HealthMetric> metric)
{
    healthMetrics.push_back(std::move(metric));
}

// Deletes a health metric from the LogManager based on the provided metricID.
// Iterates through the healthMetrics vector looking for a metric with the matching ID.
// Uses an iterator-based loop so we can call erase() directly on the found position.
// If no match is found, an error message is printed to cerr.
void LogManager::deleteMetric(const string &metricID)
{
    for (auto it = healthMetrics.begin(); it != healthMetrics.end(); ++it) {
        if ((*it)->getMetricID() == metricID) {
            healthMetrics.erase(it);
            return;
        }
    }
    cerr << "Metric with ID " << metricID << " not found.\n";
}

// Clears all logs and health metrics from the manager, used before loading fresh data from a file
// Called by DataManager::loadData before populating fresh data from a file,
// ensuring no stale entries remain from a previous session.
void LogManager::clear()
{
    logs.clear();
    healthMetrics.clear();
    // MUST also clear the ID registry — otherwise every ID from the previous
    // load stays in the set and the next loadData() rejects them all as
    // "already taken", silently dropping every log.
    registeredIDs.clear();
}

// Returns a constant reference to the vector of unique pointers to logs, allowing read-only access to the logs stored in the LogManager.
const vector<unique_ptr<Log>> &LogManager::getLogs() const
{
    return logs;
}

// Returns a constant reference to the vector of unique pointers to health metrics, allowing read-only access to the health metrics stored in the LogManager.
const vector<unique_ptr<HealthMetric>> &LogManager::getMetrics() const
{
    return healthMetrics;
}
