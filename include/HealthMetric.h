#pragma once
#include <string>
#include <ostream>

class HealthMetric {
	private:
	std::string metricID;
	std::string name;
	std::string date;
	double value;

public:
	HealthMetric(const std::string& metricID, const std::string& name, const std::string& date, double value)
		: metricID(metricID), name(name), date(date), value(value) {}
	~HealthMetric() = default;

	// Getters and setters for HealthMetric attributes
	const std::string getMetricID() const { return metricID; }
	const std::string getName() const { return name; }
	const std::string getDate() const { return date; }
	double getValue() const { return value; }

	void setName(const std::string& name) { this->name = name; }
	void setDate(const std::string& date) { this->date = date; }
	void setValue(double value) { this->value = value; }
	bool operator==(const HealthMetric& other) const;
		
	friend std::ostream& operator<<(std::ostream& os, const HealthMetric& metric);
};