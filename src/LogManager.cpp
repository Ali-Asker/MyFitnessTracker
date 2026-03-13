#include "LogManager.h"
using namespace std;

// Adds a new log to the LogManager. The log is passed as a unique_ptr to ensure proper memory management. 
// The function takes ownership of the log and adds it to the logs vector.
void LogManager::addLog(unique_ptr<Log> log)
{
	
}

// Edits an existing log identified by logID. 
// The function searches for the log with the specified ID and allows the user to modify its details.
void LogManager::editLog(const string& logID)
{
	
}

// Deletes a log from the LogManager based on the provided logID.
void LogManager::deleteLog(const string& logID)
{
	
}

// Searches for logs that contain the specified keyword in their description and returns a vector of pointers to the matching logs.
vector<Log*> LogManager::searchLogs(const string& keyword) const
{
	vector<Log*> results;
	return results;
}

// Filters logs by their type (e.g., "Workout" or "Nutrition") and returns a vector of pointers to the matching logs.
vector<Log*> LogManager::filterByType(const string& type) const
{
	vector<Log*> results;
	return results;
}

// Filters logs based on a date range specified by startDate and endDate, returning a vector of pointers to the matching logs.
vector<Log*> LogManager::filterByDate(const string& startDate, const string& endDate) const
{
	vector<Log*> results;
	return results;
}

// Adds a new health metric to the LogManager. The metric is passed as a unique_ptr to ensure proper memory management.
void LogManager::addMetric(unique_ptr<HealthMetric> metric)
{
	
}

// Deletes a health metric from the LogManager based on the provided metricID.
void LogManager::deleteMetric(const string& metricID)
{
	
}

// Returns a constant reference to the vector of unique pointers to logs, allowing read-only access to the logs stored in the LogManager.
const vector<unique_ptr<Log>>& LogManager::getLogs() const
{
	return logs;
}

// Returns a constant reference to the vector of unique pointers to health metrics, allowing read-only access to the health metrics stored in the LogManager.
const vector<unique_ptr<HealthMetric>>& LogManager::getMetrics() const
{
	return healthMetrics;
}