cmake_minimum_required(VERSION 3.16)
project(MyFitnessTracker LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Qt auto tools for .ui and .qrc
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC_SEARCH_PATHS ${CMAKE_SOURCE_DIR}/ui)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Widgets)

qt_add_executable(MyFitnessTracker
    src/main.cpp
    src/GUI.cpp
    src/DataManager.cpp
    src/Log.cpp
    src/LogManager.cpp
    src/Nutrition.cpp
    src/Workouts/Workout.cpp
    src/Workouts/CardioWorkout.cpp
    src/Workouts/StrengthWorkout.cpp
    src/Workouts/YogaWorkout.cpp
    src/HealthMetric.cpp

    include/Analytics.h
    include/DataManager.h
    include/GUI.h
    include/HealthMetric.h
    include/Log.h
    include/LogManager.h
    include/Nutrition.h
    include/Workouts/Workout.h
    include/Workouts/CardioWorkout.h
    include/Workouts/StrengthWorkout.h
    include/Workouts/YogaWorkout.h

    src/components/WorkoutCard/WorkoutCard.cpp
    src/components/WorkoutDialog/WorkoutDialog.cpp

    ui/GUI.ui
    ui/GUI.qrc
    ui/WorkoutDialog.ui
)

target_include_directories(MyFitnessTracker PRIVATE include)
target_include_directories(MyFitnessTracker PRIVATE include/Workouts)
target_include_directories(MyFitnessTracker PRIVATE src/components/WorkoutCard)
target_include_directories(MyFitnessTracker PRIVATE src/components/WorkoutDialog)

target_link_libraries(MyFitnessTracker
    PRIVATE Qt6::Core Qt6::Gui Qt6::Widgets
)
