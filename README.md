# MyFitnessTracker

**CST8219 – C++ Programming – Final Project**
**Professor:** Surbhi Bahri
**Submission Date:** April 14, 2026

### Team Members
- Shane O'Connell — #041144343
- Joshua MacPherson — #041166405
- Phinees Abel Letshu — #041171488
- Rukman Malhi — #041092619
- Ali Asker — #041161916

---

## Project Structure

```
MyFitnessTracker/
├── include/
│   ├── Workouts/
│   │   ├── CardioWorkout.h
│   │   ├── StrengthWorkout.h
│   │   ├── Workout.h
│   │   └── YogaWorkout.h
│   ├── Analytics.h              (template class — fully defined in header)
│   ├── AnalyticsTab.h
│   ├── DataManager.h
│   ├── HealthMetric.h
│   ├── HealthMetricsTab.h
│   ├── json.hpp                 (json — external library)
│   ├── Log.h
│   ├── LogManager.h
│   ├── Mainwindow.h
│   ├── Nutrition.h
│   ├── NutritionTab.h
│   ├── SplashScreen.h
│   └── Workoutstab.h
│
├── src/
│   ├── Workouts/
│   │   ├── CardioWorkout.cpp
│   │   ├── StrengthWorkout.cpp
│   │   ├── Workout.cpp
│   │   └── YogaWorkout.cpp
│   ├── AnalyticsTab.cpp
│   ├── DataManager.cpp
│   ├── HealthMetric.cpp
│   ├── HealthMetricsTab.cpp
│   ├── Log.cpp
│   ├── LogManager.cpp
│   ├── main.cpp                 
│   ├── Mainwindow.cpp
│   ├── Nutrition.cpp
│   ├── NutritionTab.cpp
│   ├── SplashScreen.cpp
│   └── Workoutstab.cpp
│
├── CMakeLists.txt
├── CMakePresets.json
└── README.md
```
---

## How It Runs

The application is a Qt6 Widgets desktop app. Execution flow:

1. **`main.cpp`** launches a `SplashScreen` for ~3 seconds.
2. When the splash emits its `ready()` signal, **`MainWindow`** opens.
3. `MainWindow` owns a single `LogManager` (data) and `DataManager` (file I/O), and builds four tabs that all share the same `LogManager` reference:
   - **Workouts** — add/edit/delete cardio, strength, and yoga workouts
   - **Nutrition** — add/edit/delete meals with macro tracking
   - **Health Metrics** — add/edit/delete standalone metrics (weight, heart rate, etc.)
   - **Analytics** — computed summaries via the `Analytics<Log>` template class
4. The **File menu** handles Save, Load, and Export Summary (plain-text report).
