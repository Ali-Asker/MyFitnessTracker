#include "Log.h"

#include <iomanip>
#include <iostream>
#include <bits/ostream.tcc>
using namespace std;

// Constructor implementation 
Log::Log(const string& id, const string& date,double duration,const string& description): logID(id),
    date(date),duration(duration),description(description){}

// Base display method — can be overridden by derived classes for specific formatting
void Log::displayLog() const
{
    cout << "==== Log ====" << endl;
    cout << "Log ID: " << logID << endl; //Display Log ID
    cout << "Date: " << date << endl; //Display Date
    cout << "Duration: " << fixed << setprecision(2) << duration << endl; // Display Duration
    cout << "Description: " << description << endl; // Display Duration

}

// Getters

const string& Log::getLogID() const
{
    return logID;
}

const string& Log::getDate() const
{
    return date;
}

double Log::getDuration() const
{
    return duration;
}

const string& Log::getDescription() const
{
    return description;
}

// Setters

void Log::setDate(const string& date)
{
    this->date = date;
}

void Log::setDuration(double duration)
{
    this->duration = duration;
}

void Log::setDescription(const string& description)
{
    this->description = description;
}