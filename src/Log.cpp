// File author: Shane
#include "Log.h"
#include <QDateTime>
#include <string>
#include <QDebug>

#include <iomanip>
#include <iostream>
using namespace std;

// Static method to validate log ID format
bool Log::isValidIDFormat(const std::string& id)
{
    if (id.empty()) {
        cerr << "Error: Log ID cannot be empty.\n";
        return false;
    }
	if (id.length() > 6) { // Limiting log ID to 6 characters for simplicity just chose this amount arbitrarily, can be changed if needed
        cerr << "Error: Log ID cannot exceed 6 characters.\n";
        return false;
    }
	// Check if all characters in the log ID are alphanumeric
    if (!std::all_of(id.begin(), id.end(), ::isalnum)) {
        cerr << "Error: Log ID must be alphanumeric.\n";
        return false;
	}
    return true;
}

// Constructor implementation for Log class, initializing all attributes and validating the log ID format.
Log::Log(const std::string& id, const QDateTime& date, double duration,
    const std::string& description)
    : logID(id), date(date), duration(duration), description(description)
{
    if (!isValidIDFormat(id)) {
        throw std::invalid_argument("Invalid Log ID: \"" + id + "\"");
    }
}

// Base display method — can be overridden by derived classes for specific formatting
void Log::displayLog() const
{
   qDebug() << "Log[id =" << logID
    <<", date=" << date.toString("yyyy-MM-dd hh:mm:ss")
    << ", duration=" << QString::number(duration, 'f', 2)
    << ", description=" << description << "]\n";
}

// Getters and setters for Log attributes
const std::string& Log::getLogID() const{ return logID; }
const QDateTime& Log::getDate() const{ return date; }
double Log::getDuration() const{ return duration; }
const std::string& Log::getDescription() const{ return description; }
void Log::setDate(const QDateTime& date){ this->date = date; }
void Log::setDuration(double duration) { this->duration = duration; }
void Log::setDescription(const std::string& description){ this->description = description; }
