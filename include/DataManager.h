// DataManager.h
// Responsible for all file I/O:
//   saveData()      — serialises LogManager to a JSON file
//   loadData()      — deserialises a JSON file back into LogManager
//   exportSummary() — writes a human-readable plain-text summary report
//
// All three methods are const because DataManager holds no mutable state;
// it is a pure service class.

#pragma once

#include "LogManager.h"
#include <string>

class DataManager
{
public:
    // Persist all logs and health metrics to a JSON file.
    // Throws std::runtime_error if the file cannot be opened.
    void saveData(const std::string &filename, const LogManager &logManager) const;

    // Restore all logs and health metrics from a JSON file.
    // Clears the LogManager before populating — prevents duplicates on re-load.
    // Throws std::runtime_error on file-open failure or malformed JSON.
    void loadData(const std::string &filename, LogManager &logManager) const;

    // Write a human-readable plain-text summary report to `filename`.
    // Includes: overview totals, per-workout rows, per-meal rows,
    //           and health metric rows — all formatted as fixed-width columns.
    // Throws std::runtime_error if the file cannot be created.
    void exportSummary(const std::string &filename, const LogManager &logManager) const;
};
