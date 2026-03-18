cmake_minimum_required(VERSION 3.16)
project(MyFitnessTracker LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Qt auto-tools
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC_SEARCH_PATHS ${CMAKE_SOURCE_DIR}/ui)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Widgets Qml Quick QuickControls2)

qt_add_executable(MyFitnessTracker

    # C++ entry point
    src/main.cpp

    # C++ backend
    src/FitnessApplication.cpp
    src/DataManager.cpp
    src/Log.cpp
    src/LogManager.cpp
    src/Nutrition.cpp
    src/Workout.cpp

    # Headers
    include/Analytics.h
    include/DataManager.h
    include/FitnessApplication.h
    include/HealthMetric.h
    include/Log.h
    include/LogManager.h
    include/Nutrition.h
    include/Workout.h

    # Qt Widgets UI
    ui/FitnessApplication.ui

    # Qt Resources (embeds all QML + assets into the binary)
    resources/FitnessApplication.qrc
    FitnessDesigner/FitnessDesigner.qrc
)

target_include_directories(MyFitnessTracker PRIVATE
    include
)

target_link_libraries(MyFitnessTracker PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Widgets
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
)
