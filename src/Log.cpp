#include "Log.h"
#include <QDateTime>
#include <string>
#include <QDebug>

#include <iomanip>
#include <iostream>
using namespace std;

// Constructor implementation 
Log::Log(const std::string& id, const QDateTime& date,double duration,const std::string& description): logID(id),
    date(date),duration(duration),description(description){}

// Base display method — can be overridden by derived classes for specific formatting
// Author: Josh
void Log::displayLog() const
{
   qDebug() << "Log[id =" << logID
    <<", date=" << date.toString("yyyy-MM-dd hh:mm:ss")
    << ", duration=" << QString::number(duration, 'f', 2)
    << ", description=" << description << "]\n";
}

// Getters

const std::string& Log::getLogID() const
{
    return logID;
}

const QDateTime& Log::getDate() const
{
    return date;
}

double Log::getDuration() const
{
    return duration;
}

const std::string& Log::getDescription() const
{
    return description;
}

// Setters

void Log::setDate(const QDateTime& date)
{
    this->date = date;
}

void Log::setDuration(double duration)
{
    this->duration = duration;
}

void Log::setDescription(const std::string& description)
{
    this->description = description;
}
