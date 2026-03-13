#pragma once
#include <string>

class Log
{
private:
    std::string logID;
    std::string date;
    double duration;
    std::string description;

public:
    Log(const std::string& id, const std::string& date,double duration,const std::string& description);

    virtual ~Log() = default;

    // Pure virtual — each derived class defines its own impact
    virtual double computeImpact() const = 0;
    virtual void displayLog() const;

    // Getters
    const std::string& getLogID() const;
    const std::string& getDate() const;
    double getDuration() const;
    const std::string& getDescription() const;

    // Setters 
    void setDate(const std::string& date);
    void setDuration(double duration);
    void setDescription(const std::string& description);
};