#include "HealthMetric.h"
#include <ostream>
using namespace std;

// Two HealthMetric objects are equal if all their attributes match

bool HealthMetric::operator==(const HealthMetric& other) const
{
    return metricID == other.metricID &&
           name     == other.name     &&
           date     == other.date     &&
           value    == other.value;
}

// Stream insertion operator — prints a formatted summary of the metric
ostream& operator<<(ostream& os, const HealthMetric& metric)
{
    os << "HealthMetric[metricID=" << metric.metricID
       << ", name="  << metric.name
       << ", date="  << metric.date.toString("yyyy-MM-dd hh:mm").toStdString()
       << ", value=" << metric.value
       << "]";
    return os;
}
