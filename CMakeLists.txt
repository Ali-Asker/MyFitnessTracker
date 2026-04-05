cmake_minimum_required(VERSION 3.16)
project(MyFitnessTracker LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Qt auto-tools
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Widgets Qml Quick QuickControls2)

qt_add_executable(MyFitnessTracker
    src/main.cpp

    src/DataManager.cpp
    src/Analytics.cpp
    src/Log.cpp
    src/LogManager.cpp
    src/Nutrition.cpp
    src/HealthMetric.cpp
    src/Handlers.cpp
    src/Workouts/Workout.cpp
    src/Workouts/CardioWorkout.cpp
    src/Workouts/StrengthWorkout.cpp
    src/Workouts/YogaWorkout.cpp
    
    include/DataManager.h
    include/Log.h
    include/LogManager.h
    include/Nutrition.h
    include/HealthMetric.h
    include/Analytics.h
    include/Handlers.h
    include/Workouts/Workout.h
    include/Workouts/CardioWorkout.h
    include/Workouts/StrengthWorkout.h
    include/Workouts/YogaWorkout.h
    
    FitnessDesigner/FitnessDesigner.qrc
)

target_include_directories(MyFitnessTracker PRIVATE
    include
    include/Workouts
)

target_link_libraries(MyFitnessTracker PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Widgets
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
)
