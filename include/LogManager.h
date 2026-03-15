#pragma once
#include <string>
#include <vector>
#include <memory>
#include "Log.h"
#include "HealthMetric.h"

class LogManager {
private:
	std::vector<std::unique_ptr<Log>> logs;
	std::vector<std::unique_ptr<HealthMetric>> healthMetrics;

public:
	void addLog(std::unique_ptr<Log> log);
	void editLog(const std::string& logID);
	void deleteLog(const std::string& logID);

	std::vector<Log*> searchLogs(const std::string& keyword) const;
	std::vector<Log*> filterByType(const std::string& type) const;
	std::vector<Log*> filterByDate(const std::string& startDate, const std::string& endDate) const;

	void addMetric(std::unique_ptr<HealthMetric> metric);
	void deleteMetric(const std::string& metricID);

    // Clears all logs and health metrics from the manager, used before loading fresh data from a file
    void clear();

	const std::vector<std::unique_ptr<Log>>& getLogs() const;
	const std::vector<std::unique_ptr<HealthMetric>>& getMetrics() const;
};
