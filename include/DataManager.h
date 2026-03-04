#pragma once
#include <string>
#include "LogManager.h"

class DataManager {
public: 
	// Saves the current state of the LogManager to a file specified by filename.
	void saveData(const std::string& filename, const LogManager& logManager) const;
	void loadData(const std::string& filename, LogManager& logManager) const;
};