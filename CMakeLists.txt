cmake_minimum_required(VERSION 3.16)
project(MyFitnessTracker LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Widgets)

qt_add_executable(MyFitnessTracker

    # ── Entry point ──────────────────────────────────────────────────────────
    src/main.cpp

    # ── Splash screen ────────────────────────────────────────────────────────
    src/SplashScreen.cpp     include/SplashScreen.h

    # ── UI layer ─────────────────────────────────────────────────────────────
    src/MainWindow.cpp       include/MainWindow.h
    src/WorkoutsTab.cpp      include/WorkoutsTab.h
    src/NutritionTab.cpp     include/NutritionTab.h
    src/HealthMetricsTab.cpp include/HealthMetricsTab.h
    src/AnalyticsTab.cpp     include/AnalyticsTab.h

    # ── Business logic ───────────────────────────────────────────────────────
    # NOTE: Analytics.cpp is intentionally absent.
    # Analytics is a template class — its method bodies live in Analytics.h
    # and are compiled on demand wherever Analytics<T> is instantiated.
    src/DataManager.cpp      include/DataManager.h
    src/Log.cpp              include/Log.h
    src/LogManager.cpp       include/LogManager.h
    src/Nutrition.cpp        include/Nutrition.h
    src/HealthMetric.cpp     include/HealthMetric.h
                             include/Analytics.h

    # ── Workout subtypes ─────────────────────────────────────────────────────
    src/Workouts/Workout.cpp         include/Workouts/Workout.h
    src/Workouts/CardioWorkout.cpp   include/Workouts/CardioWorkout.h
    src/Workouts/StrengthWorkout.cpp include/Workouts/StrengthWorkout.h
    src/Workouts/YogaWorkout.cpp     include/Workouts/YogaWorkout.h
)

target_include_directories(MyFitnessTracker PRIVATE
    include
    include/Workouts
)

target_link_libraries(MyFitnessTracker PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Widgets
)
