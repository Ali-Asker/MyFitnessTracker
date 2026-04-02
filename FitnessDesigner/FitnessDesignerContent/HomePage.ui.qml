import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: homePage

    color: "#252525"

    // ==========================================
    // PROPERTIES - Fitness Data (Signal handlers react to changes)
    // ==========================================
    property int widgetCount: 0
    property string userName: "User"
    
    // Nutrition Goals & Current Values
    property int calorieGoal: 2000
    property int caloriesCurrent: 1450
    property int proteinGoal: 150      // grams
    property int proteinCurrent: 95
    property int carbsGoal: 250        // grams
    property int carbsCurrent: 180
    property int sugarGoal: 50         // grams
    property int sugarCurrent: 32
    property int fatGoal: 65           // grams
    property int fatCurrent: 45
    
    // Activity Stats (Essential Widget 1 - Activity Focus)
    property int stepsToday: 8547
    property int stepsGoal: 10000
    property int caloriesBurned: 420
    property int activeMinutes: 45
    property double distanceKm: 6.2
    
    // Health Stats (Essential Widget 2 - Health Focus)
    property int heartRateAvg: 72
    property int heartRateMin: 58
    property int heartRateMax: 145
    property int sleepHours: 7
    property int sleepMinutes: 23
    property int waterGlasses: 6
    property int waterGoal: 8
    
    // Today's Workouts
    property var todaysWorkouts: ["Push Day - Chest & Triceps", "15 min HIIT Cardio"]

    // ==========================================
    // SIGNAL HANDLER: Property Change Detection
    // ==========================================
    onCaloriesCurrentChanged: {
        console.log("📊 Signal: Calories updated to", caloriesCurrent, "/", calorieGoal)
    }
    
    onStepsTodayChanged: {
        console.log("👟 Signal: Steps updated to", stepsToday)
        if (stepsToday >= stepsGoal) {
            console.log("🎉 Congratulations! Step goal reached!")
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
    Text {
        id: good_Morning_USER_

        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 24

        height: 50

        color: "#afafaf"
        font.family: "PoetsenOne"
        font.pixelSize: 36
        font.weight: Font.Normal
        horizontalAlignment: Text.AlignLeft
        text: getGreeting() + ", " + userName + "!"
        textFormat: Text.PlainText
        verticalAlignment: Text.AlignVCenter
    }

    // Main content area with auto-layout
    ColumnLayout {
        id: homePage_Content

        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.top: good_Morning_USER_.bottom
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
            Layout.maximumHeight: parent.height * 0.32

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
                            text: "📅 TODAY"
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
                            text: "🏋️ TODAY'S WORKOUTS"
                            color: "#888888"
                            font.pixelSize: 12
                            font.family: "PoetsenOne"
                            font.letterSpacing: 2
                        }

                        Repeater {
                            model: homePage.todaysWorkouts
                            
                            Rectangle {
                                width: parent.width
                                height: 32
                                color: workoutItemArea.containsMouse ? "#4a4a4a" : "#454545"
                                radius: 4
                                
                                Behavior on color { ColorAnimation { duration: 100 } }

                                Row {
                                    anchors.fill: parent
                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 10
                                    spacing: 8
                                    
                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: "•"
                                        color: "#4CAF50"
                                        font.pixelSize: 18
                                    }
                                    
                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: modelData
                                        color: "#ffffff"
                                        font.pixelSize: 14
                                        font.family: "PoetsenOne"
                                        elide: Text.ElideRight
                                        width: parent.width - 30
                                    }
                                }
                                
                                MouseArea {
                                    id: workoutItemArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    // Signal handler: View workout details
                                    onClicked: {
                                        console.log("🏋️ Signal: Workout clicked -", modelData)
                                    }
                                }
                            }
                        }
                    }
                }

                // Vertical Separator
                Rectangle {
                    Layout.fillHeight: true
                    width: 1
                    color: "#555555"
                }

                // Center Section: Pie Chart for Macros
                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.height - 40
                    
                    // Pie Chart using Shape
                    Shape {
                        id: pieChart
                        anchors.centerIn: parent
                        width: Math.min(parent.width, parent.height) - 20
                        height: width
                        
                        property real proteinAngle: (homePage.proteinCurrent / (homePage.proteinCurrent + homePage.carbsCurrent + homePage.fatCurrent)) * 360
                        property real carbsAngle: (homePage.carbsCurrent / (homePage.proteinCurrent + homePage.carbsCurrent + homePage.fatCurrent)) * 360
                        property real fatAngle: (homePage.fatCurrent / (homePage.proteinCurrent + homePage.carbsCurrent + homePage.fatCurrent)) * 360
                        
                        property real centerX: width / 2
                        property real centerY: height / 2
                        property real radius: width / 2 - 5

                        // Protein slice (Red/Pink)
                        ShapePath {
                            fillColor: "#e74c3c"
                            strokeColor: "#3d3d3d"
                            strokeWidth: 2
                            startX: pieChart.centerX
                            startY: pieChart.centerY
                            
                            PathLine { x: pieChart.centerX + pieChart.radius; y: pieChart.centerY }
                            PathArc {
                                x: pieChart.centerX + pieChart.radius * Math.cos(pieChart.proteinAngle * Math.PI / 180)
                                y: pieChart.centerY + pieChart.radius * Math.sin(pieChart.proteinAngle * Math.PI / 180)
                                radiusX: pieChart.radius
                                radiusY: pieChart.radius
                                useLargeArc: pieChart.proteinAngle > 180
                            }
                            PathLine { x: pieChart.centerX; y: pieChart.centerY }
                        }
                        
                        // Carbs slice (Yellow/Orange)
                        ShapePath {
                            fillColor: "#f39c12"
                            strokeColor: "#3d3d3d"
                            strokeWidth: 2
                            startX: pieChart.centerX
                            startY: pieChart.centerY
                            
                            PathLine { 
                                x: pieChart.centerX + pieChart.radius * Math.cos(pieChart.proteinAngle * Math.PI / 180)
                                y: pieChart.centerY + pieChart.radius * Math.sin(pieChart.proteinAngle * Math.PI / 180)
                            }
                            PathArc {
                                x: pieChart.centerX + pieChart.radius * Math.cos((pieChart.proteinAngle + pieChart.carbsAngle) * Math.PI / 180)
                                y: pieChart.centerY + pieChart.radius * Math.sin((pieChart.proteinAngle + pieChart.carbsAngle) * Math.PI / 180)
                                radiusX: pieChart.radius
                                radiusY: pieChart.radius
                                useLargeArc: pieChart.carbsAngle > 180
                            }
                            PathLine { x: pieChart.centerX; y: pieChart.centerY }
                        }
                        
                        // Fat slice (Blue)
                        ShapePath {
                            fillColor: "#3498db"
                            strokeColor: "#3d3d3d"
                            strokeWidth: 2
                            startX: pieChart.centerX
                            startY: pieChart.centerY
                            
                            PathLine { 
                                x: pieChart.centerX + pieChart.radius * Math.cos((pieChart.proteinAngle + pieChart.carbsAngle) * Math.PI / 180)
                                y: pieChart.centerY + pieChart.radius * Math.sin((pieChart.proteinAngle + pieChart.carbsAngle) * Math.PI / 180)
                            }
                            PathArc {
                                x: pieChart.centerX + pieChart.radius
                                y: pieChart.centerY
                                radiusX: pieChart.radius
                                radiusY: pieChart.radius
                                useLargeArc: pieChart.fatAngle > 180
                            }
                            PathLine { x: pieChart.centerX; y: pieChart.centerY }
                        }
                    }
                    
                    // Center circle with calories
                    Rectangle {
                        anchors.centerIn: parent
                        width: pieChart.width * 0.5
                        height: width
                        radius: width / 2
                        color: "#3d3d3d"
                        
                        Column {
                            anchors.centerIn: parent
                            spacing: 2
                            
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: homePage.caloriesCurrent
                                color: "#ffffff"
                                font.pixelSize: 22
                                font.family: "PoetsenOne"
                                font.weight: Font.Bold
                            }
                            
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: "/ " + homePage.calorieGoal + " kcal"
                                color: "#888888"
                                font.pixelSize: 10
                                font.family: "PoetsenOne"
                            }
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        // Signal handler: Click pie chart for details
                        onClicked: {
                            console.log("🥧 Signal: Pie chart clicked - showing macro details")
                        }
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
                    spacing: 8

                    Text {
                        text: "🍽️ NUTRITION GOALS"
                        color: "#888888"
                        font.pixelSize: 12
                        font.family: "PoetsenOne"
                        font.letterSpacing: 2
                    }

                    // Protein Progress
                    NutrientProgressBar {
                        Layout.fillWidth: true
                        label: "Protein"
                        current: homePage.proteinCurrent
                        goal: homePage.proteinGoal
                        unit: "g"
                        barColor: "#e74c3c"
                    }

                    // Carbs Progress
                    NutrientProgressBar {
                        Layout.fillWidth: true
                        label: "Carbs"
                        current: homePage.carbsCurrent
                        goal: homePage.carbsGoal
                        unit: "g"
                        barColor: "#f39c12"
                    }

                    // Fat Progress
                    NutrientProgressBar {
                        Layout.fillWidth: true
                        label: "Fat"
                        current: homePage.fatCurrent
                        goal: homePage.fatGoal
                        unit: "g"
                        barColor: "#3498db"
                    }

                    // Sugar Progress
                    NutrientProgressBar {
                        Layout.fillWidth: true
                        label: "Sugar"
                        current: homePage.sugarCurrent
                        goal: homePage.sugarGoal
                        unit: "g"
                        barColor: "#9b59b6"
                    }

                    Item { Layout.fillHeight: true }
                }
            }
        }

        // Widgets row - 4 columns with equal width
        RowLayout {
            id: widgetsRow

            Layout.fillWidth: true
            Layout.fillHeight: true

            spacing: 15

            // ==========================================
            // ESSENTIAL WIDGET 1 - Activity & Movement Stats
            // ==========================================
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
                    Row {
                        Layout.fillWidth: true
                        spacing: 8
                        
                        Text {
                            text: "🏃"
                            font.pixelSize: 20
                        }
                        
                        Text {
                            text: "ACTIVITY"
                            color: "#88c8ff"
                            font.pixelSize: 14
                            font.family: "PoetsenOne"
                            font.letterSpacing: 2
                        }
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

                    // Separator
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "#006699"
                    }

                    // Secondary Stats Grid
                    GridLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        columns: 2
                        rowSpacing: 8
                        columnSpacing: 15

                        // Calories Burned
                        StatItem {
                            Layout.fillWidth: true
                            icon: "🔥"
                            value: homePage.caloriesBurned
                            label: "kcal burned"
                            valueColor: "#ff9500"
                        }

                        // Distance
                        StatItem {
                            Layout.fillWidth: true
                            icon: "📍"
                            value: homePage.distanceKm
                            label: "km walked"
                            valueColor: "#00ff88"
                            isDecimal: true
                        }

                        // Active Minutes
                        StatItem {
                            Layout.fillWidth: true
                            icon: "⏱️"
                            value: homePage.activeMinutes
                            label: "active mins"
                            valueColor: "#00d4ff"
                        }

                        // Floors Climbed (bonus stat)
                        StatItem {
                            Layout.fillWidth: true
                            icon: "🪜"
                            value: 12
                            label: "floors"
                            valueColor: "#ff6b9d"
                        }
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    // Signal handler: Click for detailed activity view
                    onClicked: {
                        console.log("🏃 Signal: Activity widget clicked - Steps:", homePage.stepsToday)
                    }
                }
            }

            // Column 2: Blue widget (shorter, aligned to top)
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 15

                // Small widget - Quick Stats Summary
                Rectangle {
                    id: widget_blue

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.maximumHeight: parent.height * 0.45

                    color: "#2d5a30"
                    radius: 8

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        Text {
                            text: "💪 STREAK"
                            color: "#88ff88"
                            font.pixelSize: 11
                            font.family: "PoetsenOne"
                            font.letterSpacing: 2
                        }

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
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        // Signal handler: Click streak widget
                        onClicked: {
                            console.log("💪 Signal: Streak widget clicked - 7 day streak!")
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }

            // Column 3: Add Widget button (same size as column 2 widget)
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                Rectangle {
                    id: widget_add

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.maximumHeight: parent.height * 0.45

                    color: addWidgetArea.pressed ? "#5a5959" : (addWidgetArea.containsMouse ? "#929191" : "#828181")
                    radius: 8

                    Behavior on color { ColorAnimation { duration: 150 } }

                    Item {
                        anchors.centerIn: parent
                        width: childrenRect.width
                        height: childrenRect.height

                        Column {
                            spacing: 10
                            anchors.horizontalCenter: parent.horizontalCenter

                            Item {
                                id: _x
                                width: 26
                                height: 25.37
                                anchors.horizontalCenter: parent.horizontalCenter

                                Shape {
                                    id: line_3
                                    x: 0.32
                                    y: 12.68
                                    height: 0
                                    width: 25.37
                                    rotation: 90

                                    ShapePath {
                                        fillColor: "#00000000"
                                        strokeColor: "#ffffff"
                                        strokeWidth: 6
                                        PathSvg {
                                            path: "M 0 0 L 25.365854263305664 0"
                                        }
                                    }
                                }
                                Shape {
                                    id: line_4
                                    y: 12.68
                                    height: 0
                                    width: 26
                                    rotation: 0

                                    ShapePath {
                                        fillColor: "#00000000"
                                        strokeColor: "#ffffff"
                                        strokeWidth: 6
                                        PathSvg {
                                            path: "M 0 0 L 26 0"
                                        }
                                    }
                                }
                            }

                            Text {
                                id: add_Widget
                                anchors.horizontalCenter: parent.horizontalCenter

                                color: "#ffffff"
                                font.family: "PoetsenOne"
                                font.pixelSize: 20
                                font.weight: Font.Normal
                                horizontalAlignment: Text.AlignHCenter
                                text: "Add Widget"
                            }
                        }
                    }

                    MouseArea {
                        id: addWidgetArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        // Signal handler: Opens the widget selection popup
                        onClicked: {
                            console.log("➕ Signal: Add Widget button clicked")
                            widgetSelectionPopup.open()
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }

            // ==========================================
            // ESSENTIAL WIDGET 2 - Health & Wellness Stats
            // ==========================================
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
                    Row {
                        Layout.fillWidth: true
                        spacing: 8
                        
                        Text {
                            text: "❤️"
                            font.pixelSize: 20
                        }
                        
                        Text {
                            text: "HEALTH"
                            color: "#ffaacc"
                            font.pixelSize: 14
                            font.family: "PoetsenOne"
                            font.letterSpacing: 2
                        }
                    }

                    // Heart Rate (Main Stat)
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.maximumHeight: parent.height * 0.35

                        Row {
                            anchors.centerIn: parent
                            spacing: 15

                            Column {
                                spacing: 2
                                
                                Text {
                                    text: homePage.heartRateAvg
                                    color: "#ffffff"
                                    font.pixelSize: 36
                                    font.family: "PoetsenOne"
                                    font.weight: Font.Bold
                                }

                                Text {
                                    text: "avg BPM"
                                    color: "#ffaacc"
                                    font.pixelSize: 12
                                    font.family: "PoetsenOne"
                                }
                            }

                            Column {
                                spacing: 4
                                
                                Row {
                                    spacing: 5
                                    Text {
                                        text: "↓"
                                        color: "#4CAF50"
                                        font.pixelSize: 14
                                    }
                                    Text {
                                        text: homePage.heartRateMin
                                        color: "#ffffff"
                                        font.pixelSize: 14
                                        font.family: "PoetsenOne"
                                    }
                                }
                                
                                Row {
                                    spacing: 5
                                    Text {
                                        text: "↑"
                                        color: "#ff5555"
                                        font.pixelSize: 14
                                    }
                                    Text {
                                        text: homePage.heartRateMax
                                        color: "#ffffff"
                                        font.pixelSize: 14
                                        font.family: "PoetsenOne"
                                    }
                                }
                            }
                        }
                    }

                    // Separator
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "#99335a"
                    }

                    // Sleep Stats
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50

                        Row {
                            anchors.centerIn: parent
                            spacing: 10

                            Text {
                                text: "😴"
                                font.pixelSize: 24
                            }

                            Column {
                                spacing: 2

                                Row {
                                    spacing: 4
                                    Text {
                                        text: homePage.sleepHours + "h " + homePage.sleepMinutes + "m"
                                        color: "#ffffff"
                                        font.pixelSize: 20
                                        font.family: "PoetsenOne"
                                        font.weight: Font.Bold
                                    }
                                }

                                Text {
                                    text: "sleep last night"
                                    color: "#ffaacc"
                                    font.pixelSize: 11
                                    font.family: "PoetsenOne"
                                }
                            }
                        }
                    }

                    // Water Intake
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Row {
                            anchors.centerIn: parent
                            spacing: 10

                            Text {
                                text: "💧"
                                font.pixelSize: 24
                            }

                            Column {
                                spacing: 2

                                Row {
                                    spacing: 4
                                    Text {
                                        text: homePage.waterGlasses + " / " + homePage.waterGoal
                                        color: "#ffffff"
                                        font.pixelSize: 20
                                        font.family: "PoetsenOne"
                                        font.weight: Font.Bold
                                    }
                                    Text {
                                        text: "glasses"
                                        color: "#ffaacc"
                                        font.pixelSize: 14
                                        font.family: "PoetsenOne"
                                        anchors.baseline: parent.children[0].baseline
                                    }
                                }

                                // Water progress dots
                                Row {
                                    spacing: 4
                                    Repeater {
                                        model: homePage.waterGoal
                                        Rectangle {
                                            width: 12
                                            height: 12
                                            radius: 6
                                            color: index < homePage.waterGlasses ? "#00d4ff" : "#4a1a30"
                                            
                                            Behavior on color { ColorAnimation { duration: 200 } }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    // Signal handler: Click for detailed health view
                    onClicked: {
                        console.log("❤️ Signal: Health widget clicked - HR:", homePage.heartRateAvg, "BPM")
                    }
                }
            }
        }
    }

    // ==========================================
    // REUSABLE COMPONENTS
    // ==========================================
    
    // Nutrient Progress Bar Component
    component NutrientProgressBar: Item {
        property string label: "Nutrient"
        property int current: 0
        property int goal: 100
        property string unit: "g"
        property color barColor: "#ffffff"
        
        height: 32
        
        RowLayout {
            anchors.fill: parent
            spacing: 10
            
            Text {
                text: label
                color: "#cccccc"
                font.pixelSize: 13
                font.family: "PoetsenOne"
                Layout.preferredWidth: 55
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 8
                radius: 4
                color: "#555555"
                
                Rectangle {
                    width: parent.width * Math.min(current / goal, 1)
                    height: parent.height
                    radius: 4
                    color: barColor
                    
                    Behavior on width { NumberAnimation { duration: 300 } }
                }
            }
            
            Text {
                text: current + "/" + goal + unit
                color: current >= goal ? "#4CAF50" : "#ffffff"
                font.pixelSize: 11
                font.family: "PoetsenOne"
                Layout.preferredWidth: 65
                horizontalAlignment: Text.AlignRight
            }
        }
        
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            // Signal handler: Nutrient bar clicked
            onClicked: {
                console.log("📊 Signal:", label, "clicked -", current, "/", goal, unit)
            }
        }
    }

    // Stat Item Component
    component StatItem: Item {
        property string icon: "📊"
        property real value: 0
        property string label: "stat"
        property color valueColor: "#ffffff"
        property bool isDecimal: false
        
        height: 40
        
        Row {
            anchors.fill: parent
            spacing: 8
            
            Text {
                text: icon
                font.pixelSize: 16
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 1
                
                Text {
                    text: isDecimal ? value.toFixed(1) : value.toString()
                    color: valueColor
                    font.pixelSize: 16
                    font.family: "PoetsenOne"
                    font.weight: Font.Bold
                }
                
                Text {
                    text: label
                    color: "#88c8ff"
                    font.pixelSize: 9
                    font.family: "PoetsenOne"
                }
            }
        }
    }

    // ==========================================
    // WIDGET SELECTION POPUP
    // ==========================================
    Popup {
        id: widgetSelectionPopup
        anchors.centerIn: parent
        width: 500
        height: 400
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            color: "#2d2d2d"
            radius: 10
            border.color: "#474747"
            border.width: 2
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            Text {
                Layout.fillWidth: true
                text: "Select a Widget to Add"
                color: "#ffffff"
                font.family: "PoetsenOne"
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
            }

            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 2
                rowSpacing: 15
                columnSpacing: 15

                // Widget Option 1: Steps Tracker
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: widgetMouseArea1.pressed ? "#005a8c" : (widgetMouseArea1.containsMouse ? "#00578a" : "#004a7c")
                    radius: 8
                    border.color: "#006ba0"
                    border.width: 2

                    Behavior on color { ColorAnimation { duration: 150 } }

                    Column {
                        anchors.centerIn: parent
                        spacing: 10

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "👟"
                            font.pixelSize: 48
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Steps Tracker"
                            color: "#ffffff"
                            font.family: "PoetsenOne"
                            font.pixelSize: 16
                        }
                    }

                    MouseArea {
                        id: widgetMouseArea1
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        // Signal handler: Select steps tracker widget
                        onClicked: {
                            console.log("👟 Signal: Steps Tracker widget added")
                            homePage.widgetCount++
                            widgetSelectionPopup.close()
                        }
                    }
                }

                // Widget Option 2: Calorie Counter
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: widgetMouseArea2.pressed ? "#7a2f00" : (widgetMouseArea2.containsMouse ? "#8a3500" : "#6b2a00")
                    radius: 8
                    border.color: "#9a4000"
                    border.width: 2

                    Behavior on color { ColorAnimation { duration: 150 } }

                    Column {
                        anchors.centerIn: parent
                        spacing: 10

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "🔥"
                            font.pixelSize: 48
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Calorie Tracker"
                            color: "#ffffff"
                            font.family: "PoetsenOne"
                            font.pixelSize: 16
                        }
                    }

                    MouseArea {
                        id: widgetMouseArea2
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        // Signal handler: Select calorie tracker widget
                        onClicked: {
                            console.log("🔥 Signal: Calorie Tracker widget added")
                            homePage.widgetCount++
                            widgetSelectionPopup.close()
                        }
                    }
                }

                // Widget Option 3: Heart Rate Monitor
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: widgetMouseArea3.pressed ? "#7a0030" : (widgetMouseArea3.containsMouse ? "#8a0035" : "#6b002a")
                    radius: 8
                    border.color: "#9a0040"
                    border.width: 2

                    Behavior on color { ColorAnimation { duration: 150 } }

                    Column {
                        anchors.centerIn: parent
                        spacing: 10

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "❤️"
                            font.pixelSize: 48
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Heart Rate"
                            color: "#ffffff"
                            font.family: "PoetsenOne"
                            font.pixelSize: 16
                        }
                    }

                    MouseArea {
                        id: widgetMouseArea3
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        // Signal handler: Select heart rate widget
                        onClicked: {
                            console.log("❤️ Signal: Heart Rate widget added")
                            homePage.widgetCount++
                            widgetSelectionPopup.close()
                        }
                    }
                }

                // Widget Option 4: Water Intake
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: widgetMouseArea4.pressed ? "#005a7a" : (widgetMouseArea4.containsMouse ? "#00648a" : "#00506b")
                    radius: 8
                    border.color: "#0070a0"
                    border.width: 2

                    Behavior on color { ColorAnimation { duration: 150 } }

                    Column {
                        anchors.centerIn: parent
                        spacing: 10

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "💧"
                            font.pixelSize: 48
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Water Intake"
                            color: "#ffffff"
                            font.family: "PoetsenOne"
                            font.pixelSize: 16
                        }
                    }

                    MouseArea {
                        id: widgetMouseArea4
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        // Signal handler: Select water intake widget
                        onClicked: {
                            console.log("💧 Signal: Water Intake widget added")
                            homePage.widgetCount++
                            widgetSelectionPopup.close()
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 45
                color: cancelMouseArea.pressed ? "#5a5959" : (cancelMouseArea.containsMouse ? "#6a6969" : "#828181")
                radius: 8

                Behavior on color { ColorAnimation { duration: 150 } }

                Text {
                    anchors.centerIn: parent
                    text: "Cancel"
                    color: "#ffffff"
                    font.family: "PoetsenOne"
                    font.pixelSize: 18
                }

                MouseArea {
                    id: cancelMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    // Signal handler: Cancel and close popup
                    onClicked: {
                        console.log("❌ Signal: Widget selection cancelled")
                        widgetSelectionPopup.close()
                    }
                }
            }
        }

        // Signal handler: Popup opened
        onOpened: {
            console.log("📦 Signal: Widget selection popup opened")
        }

        // Signal handler: Popup closed
        onClosed: {
            console.log("📦 Signal: Widget selection popup closed. Total widgets:", homePage.widgetCount)
        }
    }
}
