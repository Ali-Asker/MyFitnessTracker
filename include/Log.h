#pragma once
#include <string>
#include <QDateTime>

class Log
{
private:
    std::string logID;
    QDateTime date;
    double duration;
    std::string description;

public:
    Log(const std::string& id, const QDateTime& date, double duration, const std::string& description);

    virtual ~Log() = default;

    // Pure virtual — each derived class defines its own impact
    virtual double computeImpact() const = 0;
    virtual void displayLog() const;

	// Static method to validate log ID format
    static bool isValidIDFormat(const std::string& id);

    // Getters
    const std::string& getLogID() const;
    const QDateTime& getDate() const;
    double getDuration() const;
    const std::string& getDescription() const;

    // Setters 
    void setDate(const QDateTime& date);
    void setDuration(double duration);
    void setDescription(const std::string& description);
};