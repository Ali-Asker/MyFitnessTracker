import QtQuick
import QtQuick.Shapes
import QtQuick.Window
import FitnessDesigner 1.0
import FitnessHandlers 1.0

Rectangle {
    id: mainRoot

    // Make the root element fill the view - enables responsive resizing
    // The view's SizeRootObjectToView mode will size the root to the window
    anchors.fill: parent

    // Set minimum sizes to prevent layout collapse
    property int minimumWidth: 1200
    property int minimumHeight: 800

    color: "#252525"

    property int currentPage: 0
    
    // C++ Handlers instance for backend communication
    Handlers {
        id: handlers
        
        // Listen for navigation requests from C++
        onNavigationRequested: (pageIndex) => {
            mainRoot.currentPage = pageIndex
        }
        
        // Listen for data changes from C++
        onNutritionChanged: {
            homePage.caloriesCurrent = handlers.totalCalories
            homePage.proteinCurrent = handlers.totalProtein
            homePage.carbsCurrent = handlers.totalCarbs
            homePage.fatCurrent = handlers.totalFats
            homePage.sugarCurrent = handlers.totalSugar
        }
        
        onWorkoutsChanged: {
            homePage.caloriesBurned = handlers.totalCaloriesBurned
            homePage.activeMinutes = handlers.totalWorkoutDuration
        }
    }

    SideMenuBar {
        id: sideMenu
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        currentPage: mainRoot.currentPage
        onNavigate: (page) => {
            mainRoot.currentPage = page
            handlers.navigateToPage(page)
        }
    }

    Item {
        id: pageStack
        anchors.left: sideMenu.right
        anchors.leftMargin: 15
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        HomePage {
            id: homePage
            anchors.fill: parent
            visible: mainRoot.currentPage === 0
            
            // Handle navigation signal from HomePage
            onNavigateToPage: (page) => {
                mainRoot.currentPage = page
            }
        }
        NutritionPage {
            id: nutritionPage
            anchors.fill: parent
            visible: mainRoot.currentPage === 1
            
            // Connect nutrition updates to HomePage
            onNutritionUpdated: (calories, protein, carbs, fats, sugar) => {
                homePage.caloriesCurrent = calories
                homePage.proteinCurrent = protein
                homePage.carbsCurrent = carbs
                homePage.fatCurrent = fats
                homePage.sugarCurrent = sugar
            }
        }
        WorkoutPage {
            id: workoutPage
            anchors.fill: parent
            visible: mainRoot.currentPage === 2
            
            // Connect workout updates to HomePage
            onWorkoutUpdated: (totalWorkouts, totalDuration, caloriesBurned) => {
                homePage.caloriesBurned = caloriesBurned
                homePage.activeMinutes = totalDuration
                // Update today's workouts list with full details
                var workoutDetails = []
                for (var i = 0; i < workoutPage.workoutsModel.count && i < 3; i++) {
                    var w = workoutPage.workoutsModel.get(i)
                    workoutDetails.push({
                        title: w.title,
                        reps: w.reps,
                        sets: w.sets,
                        duration: w.duration,
                        workoutType: w.workoutType
                    })
                }
                homePage.todaysWorkouts = workoutDetails
            }
        }
    }

    Item {
        id: windowsControl
        anchors.right: parent.right
        anchors.top: parent.top
        z: 2000
        height: 36
        width: 150

        function win() {
            return mainRoot.Window.window
        }

        Item {
            id: minimize_2
            height: 36
            width: 50

            Rectangle {
                id: minimizeBg
                anchors.fill: parent
                color: minimizeArea.pressed ? "#5a5a5a" : (minimizeArea.containsMouse ? "#555555" : "#474747")
                Behavior on color { ColorAnimation { duration: 150 } }
            }
            Shape {
                x: 19.79
                y: 17.65
                height: 0
                width: 10.42
                ShapePath {
                    fillColor: "#00000000"
                    strokeColor: "#ffffff"
                    strokeWidth: 1
                    PathSvg {
                        path: "M 0 0 L 10.416666984558105 0"
                    }
                }
            }
            MouseArea {
                id: minimizeArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: {
                    const w = windowsControl.win()
                    if (w)
                        w.showMinimized()
                }
            }
        }
        Item {
            id: fullSize
            x: 50
            height: 36
            width: 50

            Rectangle {
                id: maximizeBg
                anchors.fill: parent
                color: maximizeArea.pressed ? "#5a5a5a" : (maximizeArea.containsMouse ? "#555555" : "#474747")
                Behavior on color { ColorAnimation { duration: 150 } }
            }
            Item {
                x: 16
                y: 9
                height: 18
                width: 18
                Rectangle {
                    x: 6
                    y: 2
                    height: 10
                    width: 10
                    color: "#ffffff"
                }
                Rectangle {
                    x: 2
                    y: 6
                    height: 10
                    width: 10
                    color: "#ffffff"
                }
                Rectangle {
                    x: 3
                    y: 7
                    height: 8
                    width: 8
                    color: maximizeArea.pressed ? "#5a5a5a" : (maximizeArea.containsMouse ? "#555555" : "#474747")
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
            }
            MouseArea {
                id: maximizeArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: {
                    const w = windowsControl.win()
                    if (!w)
                        return
                    if (w.visibility === Window.Maximized)
                        w.showNormal()
                    else
                        w.showMaximized()
                }
            }
        }
        Item {
            id: exit
            x: 100
            height: 36
            width: 50

            Rectangle {
                id: exitBg
                anchors.fill: parent
                color: exitArea.pressed ? "#aa2020" : (exitArea.containsMouse ? "#e81123" : "#474747")
                Behavior on color { ColorAnimation { duration: 150 } }
            }
            Item {
                x: 21
                y: 14
                height: 7.83
                width: 7.86
                Shape {
                    x: -1.62
                    y: 3.91
                    height: 0
                    width: 11.09
                    rotation: -44.89
                    ShapePath {
                        fillColor: "#00000000"
                        strokeColor: "#ffffff"
                        strokeWidth: 1
                        PathSvg {
                            path: "M 0 0 L 11.09451961517334 0"
                        }
                    }
                }
                Shape {
                    x: -1.62
                    y: 3.92
                    height: 0
                    width: 11.09
                    rotation: 44.89
                    ShapePath {
                        fillColor: "#00000000"
                        strokeColor: "#ffffff"
                        strokeWidth: 1
                        PathSvg {
                            path: "M 0 0 L 11.09451961517334 0"
                        }
                    }
                }
            }
            MouseArea {
                id: exitArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: {
                    const w = windowsControl.win()
                    if (w)
                        w.close()
                }
            }
        }
    }

    MouseArea {
        id: dragArea
        x: sideMenu.width + 8
        y: 8
        width: parent.width - sideMenu.width - 8 - 150 - 8
        height: 40
        hoverEnabled: true
        cursorShape: Qt.SizeAllCursor
        z: 1500
        onPressed: {
            const w = mainRoot.Window.window
            if (w)
                w.startSystemMove()
        }
    }

    Rectangle {
        id: leftResizeHandle
        width: 6
        color: "transparent"
        z: 3000
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeHorCursor
            onPressed: {
                const w = mainRoot.Window.window
                if (w)
                    w.startSystemResize(Qt.LeftEdge)
            }
        }
    }

    Rectangle {
        id: rightResizeHandle
        width: 6
        color: "transparent"
        z: 3000
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeHorCursor
            onPressed: {
                const w = mainRoot.Window.window
                if (w)
                    w.startSystemResize(Qt.RightEdge)
            }
        }
    }

    Rectangle {
        id: topResizeHandle
        height: 6
        color: "transparent"
        z: 3000
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeVerCursor
            onPressed: {
                const w = mainRoot.Window.window
                if (w)
                    w.startSystemResize(Qt.TopEdge)
            }
        }
    }

    Rectangle {
        id: bottomResizeHandle
        height: 6
        color: "transparent"
        z: 3000
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeVerCursor
            onPressed: {
                const w = mainRoot.Window.window
                if (w)
                    w.startSystemResize(Qt.BottomEdge)
            }
        }
    }
}
