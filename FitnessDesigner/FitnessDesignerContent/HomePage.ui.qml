import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import QtQuick.Controls
import FitnessDesigner 1.0

Rectangle {
    id: homePage

    color: "#252525"

    // ==========================================
    // SIGNALS - Navigation
    // ==========================================
    signal navigateToPage(int page)

    // ==========================================
    // PROPERTIES - Fitness Data (Signal handlers react to changes)
    // ==========================================
    property int widgetCount: 0
    property string userName: "User"
    
    // Nutrition Goals & Current Values - in Grams
    property int calorieGoal: 2000
    property int caloriesCurrent: 0
    property int proteinGoal: 150
    property int proteinCurrent: 0
    property int carbsGoal: 250
    property int carbsCurrent: 0
    property int sugarGoal: 50
    property int sugarCurrent: 0
    property int fatGoal: 65
    property int fatCurrent: 0
    
    // Activity Stats (Essential Widget 1 - Activity Focus)
    property int stepsToday: 520
    property int stepsGoal: 10000
    property int caloriesBurned: 0
    property int activeMinutes: 0
    property double distanceKm: 6.2
    
    // Health Stats (Essential Widget 2 - Health Focus)
    property int heartRateAvg: 72
    property int heartRateMin: 58
    property int heartRateMax: 145
    property int sleepHours: 7
    property int sleepMinutes: 23
    property int waterGlasses: 6
    property int waterGoal: 8
    
    // Today's Workouts - array of objects with full details
    property var todaysWorkouts: []

    // ==========================================
    // SIGNAL HANDLER: Property Change Detection
    // ==========================================
    onCaloriesCurrentChanged: {
        console.log("Signal: Calories updated to", caloriesCurrent, "/", calorieGoal)
    }
    
    onStepsTodayChanged: {
        console.log("Signal: Steps updated to", stepsToday)
        if (stepsToday >= stepsGoal) {
            console.log("Congratulations! Step goal reached!")
        }
    }

    // Helper function to get greeting based on time
    function getGreeting() {
        var hour = new Date().getHours()
        if (hour < 12) return "Good Morning"
        if (hour < 17) return "Good Afternoon"
        return "Good Evening"
    }

    // Helper function to get today's date formatted
    function getTodayDate() {
        var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        var months = ["January", "February", "March", "April", "May", "June",
                      "July", "August", "September", "October", "November", "December"]
        var now = new Date()
        return days[now.getDay()] + ", " + months[now.getMonth()] + " " + now.getDate()
    }

    // Greeting text at top
    PageHeaderText {
        id: good_Morning

        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 24

        height: 50

        font.pixelSize: 36
        text: getGreeting() + ", " + userName + "!"
    }

    // Main content area with auto-layout
    ColumnLayout {
        id: homePage_Content

        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.top: good_Morning.bottom
        anchors.topMargin: 15
        anchors.right: parent.right
        anchors.rightMargin: 24
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24

        spacing: 15

        // ==========================================
        // HEADER WIDGET - Date, Workouts & Nutrition with Pie Chart
        // ==========================================
        Rectangle {
            id: header_Widget

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: parent.height * 0.4
            Layout.minimumHeight: 220

            color: "#3d3d3d"
            radius: 8

            RowLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 20

                // Left Section: Date & Today's Workouts
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.35
                    spacing: 12

                    // Today's Date
                    Column {
                        Layout.fillWidth: true
                        spacing: 4

                        Text {
                            text: "TODAY"
                            color: "#888888"
                            font.pixelSize: 12
                            font.family: "PoetsenOne"
                            font.letterSpacing: 2
                        }

                        Text {
                            id: dateText
                            text: getTodayDate()
                            color: "#ffffff"
                            font.pixelSize: 18
                            font.family: "PoetsenOne"
                            font.weight: Font.Bold
                        }
                    }

                    // Separator
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "#555555"
                    }

                    // Today's Workouts
                    Column {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 8

                        Text {
                            text: "TODAY'S WORKOUTS"
                            color: "#888888"
                            font.pixelSize: 12
                            font.family: "PoetsenOne"
                            font.letterSpacing: 2
                        }

                        Repeater {
                            model: homePage.todaysWorkouts
                            
                            Rectangle {
                                width: parent.width
                                height: 44
                                color: workoutItemArea.containsMouse ? "#4a4a4a" : "#454545"
                                radius: 6
                                
                                Behavior on color { ColorAnimation { duration: 100 } }

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 10
                                    spacing: 10
                                    
                                    // Workout type indicator dot
                                    Rectangle {
                                        width: 8
                                        height: 8
                                        radius: 4
                                        color: modelData.workoutType === "chest" ? "#c62828" :
                                                                                   modelData.workoutType === "leg" ? "#ef6c00" :
                                                                                                                     modelData.workoutType === "arm" ? "#1565c0" : "#4CAF50"
                                    }
                                    
                                    // Workout info column
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        spacing: 2
                                        
                                        // Title
                                        Text {
                                            text: modelData.title || ""
                                            color: "#ffffff"
                                            font.pixelSize: 13
                                            font.family: "PoetsenOne"
                                            font.weight: Font.Bold
                                            elide: Text.ElideRight
                                            Layout.fillWidth: true
                                        }
                                        
                                        // Stats row
                                        RowLayout {
                                            Layout.fillWidth: true
                                            spacing: 12
                                            
                                            // Reps x Sets
                                            Text {
                                                text: (modelData.reps || 0) + " reps × " + (modelData.sets || 0) + " sets"
                                                color: "#aaaaaa"
                                                font.pixelSize: 10
                                                font.family: "Segoe UI"
                                            }
                                            
                                            // Duration
                                            Text {
                                                text: {
                                                    var mins = modelData.duration || 0
                                                    if (mins < 60) return mins + " min"
                                                    var hours = Math.floor(mins / 60)
                                                    var remaining = mins % 60
                                                    if (remaining === 0) return hours + "h"
                                                    return hours + "h " + remaining + "m"
                                                }
                                                color: "#888888"
                                                font.pixelSize: 10
                                                font.family: "Segoe UI"
                                            }
                                        }
                                    }
                                }
                                
                                HandCursor {
                                    id: workoutItemArea
                                    onClicked: {
                                        console.log("Signal: Workout clicked -", modelData.title)
                                    }
                                }
                            }
                        }
                        
                        // Show message when no workouts
                        Text {
                            visible: homePage.todaysWorkouts.length === 0
                            text: "No workouts yet"
                            color: "#888888"
                            font.family: "Segoe UI"
                            font.pixelSize: 12
                            font.italic: true
                        }
                    }
                }

                // Vertical Separator
                Rectangle {
                    Layout.fillHeight: true
                    width: 1
                    color: "#555555"
                }

                // Center Section: Modern Donut Chart for Macros
                ModernDonutBar {
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.height - 20
                    
                    // Pass the data from homePage
                    proteinValue: homePage.proteinCurrent
                    carbsValue: homePage.carbsCurrent
                    fatValue: homePage.fatCurrent
                    caloriesValue: homePage.caloriesCurrent
                    caloriesGoal: homePage.calorieGoal
                    
                    // Handle the click event
                    onChartClicked: {
                        homePage.navigateToPage(1)
                    }
                }

                // Vertical Separator
                Rectangle {
                    Layout.fillHeight: true
                    width: 1
                    color: "#555555"
                }

                // Right Section: Nutrition Goals Breakdown
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width * 0.35
                    Layout.alignment: Qt.AlignCenter
                    spacing: 15

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "NUTRITION GOALS"
                        color: "#888888"
                        font.pixelSize: 12
                        font.family: "PoetsenOne"
                        font.letterSpacing: 2
                    }

                    // Centered 2x2 Grid of Nutrient Stats
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        
                        GridLayout {
                            anchors.centerIn: parent
                            width: Math.min(parent.width * 0.95, parent.height * 1.2)
                            height: Math.min(parent.height * 0.95, parent.width * 0.85)
                            columns: 2
                            rows: 2
                            columnSpacing: 20
                            rowSpacing: 20
                        
                        // Protein
                        NutrientStatCircle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.minimumWidth: 80
                            Layout.minimumHeight: 100
                            
                            nutrientName: "PROTEIN"
                            currentValue: homePage.proteinCurrent
                            goalValue: homePage.proteinGoal
                            nutrientColor: "#ff6b6b"
                            unit: "g"
                        }
                        
                        // Carbs
                        NutrientStatCircle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.minimumWidth: 80
                            Layout.minimumHeight: 100
                            
                            nutrientName: "CARBS"
                            currentValue: homePage.carbsCurrent
                            goalValue: homePage.carbsGoal
                            nutrientColor: "#feca57"
                            unit: "g"
                        }
                        
                        // Fat
                        NutrientStatCircle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.minimumWidth: 80
                            Layout.minimumHeight: 100
                            
                            nutrientName: "FAT"
                            currentValue: homePage.fatCurrent
                            goalValue: homePage.fatGoal
                            nutrientColor: "#54a0ff"
                            unit: "g"
                        }
                        
                        // Sugar
                        NutrientStatCircle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.minimumWidth: 80
                            Layout.minimumHeight: 100
                            
                            nutrientName: "SUGAR"
                            currentValue: homePage.sugarCurrent
                            goalValue: homePage.sugarGoal
                            nutrientColor: "#ee5a6f"
                            unit: "g"
                        }
                    }
                }
                    

                    Item { Layout.fillHeight: true }
                }
            }
        }

        // ==============================================
        // WIDGETS ROW - 4 columns with equal width
        // ==============================================
        RowLayout {
            id: widgetsRow

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: parent.height * 0.70
            Layout.minimumHeight: 120

            spacing: 15

            // Essential Widget 1 - Activity & Movement Stats
            Rectangle {
                id: essential_Widget1

                Layout.fillWidth: true
                Layout.fillHeight: true

                color: "#004a7c"
                radius: 8

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 12

                    // Widget Title
                    Text {
                        text: "ACTIVITY"
                        color: "#88c8ff"
                        font.pixelSize: 14
                        font.family: "PoetsenOne"
                        font.letterSpacing: 2
                    }

                    // Steps Progress (Main Stat)
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.maximumHeight: parent.height * 0.4

                        Column {
                            anchors.centerIn: parent
                            spacing: 4

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: homePage.stepsToday.toLocaleString()
                                color: "#ffffff"
                                font.pixelSize: 36
                                font.family: "PoetsenOne"
                                font.weight: Font.Bold
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "/ " + homePage.stepsGoal.toLocaleString() + " steps"
                                color: "#88c8ff"
                                font.pixelSize: 14
                                font.family: "PoetsenOne"
                            }

                            // Steps Progress Bar
                            Rectangle {
                                width: 120
                                height: 6
                                radius: 3
                                color: "#003366"
                                anchors.horizontalCenter: parent.horizontalCenter

                                Rectangle {
                                    width: parent.width * Math.min(homePage.stepsToday / homePage.stepsGoal, 1)
                                    height: parent.height
                                    radius: 3
                                    color: homePage.stepsToday >= homePage.stepsGoal ? "#4CAF50" : "#00a8ff"
                                    
                                    Behavior on width { NumberAnimation { duration: 300 } }
                                }
                            }
                        }
                    }
                }

                HandCursor {
                    // Signal handler: Click for detailed activity view
                    onClicked:
                        console.log("Signal: Activity widget clicked - Steps:", homePage.stepsToday)
                }
            }

            // Essential Widget 2 (shorter, aligned to top)
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 15

                // Small widget - Quick Stats Summary
                Rectangle {
                    id: widget_blue

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    color: "#2d5a30"
                    radius: 8

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        Text {
                            text: "STREAK"
                            color: "#88ff88"
                            font.pixelSize: 11
                            font.family: "PoetsenOne"
                            font.letterSpacing: 2
                        }
                        
                        Item { Layout.fillHeight: true }

                        Text {
                            text: "7"
                            color: "#ffffff"
                            font.pixelSize: 42
                            font.family: "PoetsenOne"
                            font.weight: Font.Bold
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: "days in a row!"
                            color: "#88ff88"
                            font.pixelSize: 12
                            font.family: "PoetsenOne"
                            Layout.alignment: Qt.AlignHCenter
                        }
                        
                        Item { Layout.fillHeight: true }
                    }

                    HandCursor {
                        // Signal handler: Click streak widget
                        onClicked: {
                            console.log("Signal: Streak widget clicked - 7 day streak!")
                        }
                    }
                }

                // Small widget - Quick Stats Summary
                Rectangle {

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    color: "#2d5a30"
                    radius: 8

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        Text {
                            text: "STREAK"
                            color: "#88ff88"
                            font.pixelSize: 11
                            font.family: "PoetsenOne"
                            font.letterSpacing: 2
                        }

                        Item { Layout.fillHeight: true }

                        Text {
                            text: "7"
                            color: "#ffffff"
                            font.pixelSize: 42
                            font.family: "PoetsenOne"
                            font.weight: Font.Bold
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: "days in a row!"
                            color: "#88ff88"
                            font.pixelSize: 12
                            font.family: "PoetsenOne"
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Item { Layout.fillHeight: true }
                    }

                    HandCursor {
                        // Signal handler: Click streak widget
                        onClicked: {
                            console.log("Signal: Streak widget clicked - 7 day streak!")
                        }
                    }
                }
            }

            // Essential Widget 3 - Health & Wellness Stats
            Rectangle {
                id: essential_Widget2

                Layout.fillWidth: true
                Layout.fillHeight: true

                color: "#6b002a"
                radius: 8

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 12

                    // Widget Title
                    Text {
                        text: "Prepared Widget for use"
                        color: "#ffaacc"
                        font.pixelSize: 14
                        font.family: "PoetsenOne"
                        font.letterSpacing: 2
                    }
                }

                HandCursor {
                    // Signal handler: Click for detailed health view
                    onClicked: {
                        console.log("Signal: Health widget clicked - HR:", homePage.heartRateAvg, "BPM")
                    }
                }
            }
        }
    }
}
