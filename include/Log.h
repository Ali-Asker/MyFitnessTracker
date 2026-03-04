#pragma once
#include <string>

class Log {
protected:
    std::string logID;
    std::string date;
    std::string description;
    double duration;

// Constructor to initialize the log with its ID, date, description, and duration
public:
    Log(const std::string& logID,const std::string& date, const std::string& description,double duration)
		// Member initializer list
        : logID(logID), date(date), description(description), duration(duration) {}
    virtual ~Log() = default;

	// Abstract methods to be implemented by derived classes
    virtual double computeImpact() const = 0;
    virtual void displayLog() const = 0;

	// Getters and setters for log attributes
    std::string getLogID() const { return logID; }
    std::string getDate() const { return date; }
    std::string getDescription() const { return description; }
    double getDuration() const { return duration; }

	void setDate(const std::string& date) { this->date = date; }
	void setDescription(const std::string& description) { this->description = description; }
    void setDuration(double duration) { this->duration = duration; }
	void setLogID(const std::string& logID) { this->logID = logID; }
};