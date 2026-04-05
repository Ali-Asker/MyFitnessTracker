import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: workoutPage

    color: "#252525"

    // ==========================================
    // PROPERTIES
    // ==========================================
    property string userName: "User"
    property int maxWorkouts: 12
    
    // Form state
    property bool showingForm: false
    property string formTitle: ""
    property int formReps: 10
    property int formSets: 3
    property int formDuration: 45
    property string formWorkoutType: "chest"  // chest, leg, arm
    
    // Workout type colors
    readonly property var workoutColors: ({
        "chest": "#c62828",   // Red
        "leg": "#ef6c00",     // Orange  
        "arm": "#1565c0"      // Blue
    })
    
    readonly property var workoutIcons: ({
        "chest": "🏋️",
        "leg": "🦵", 
        "arm": "💪"
    })

    // Signal for HomePage connection
    signal workoutUpdated(int totalWorkouts, int totalDuration, int caloriesBurned)

    // ==========================================
    // HELPER FUNCTIONS
    // ==========================================
    function getGreeting() {
        var hour = new Date().getHours()
        if (hour < 12) return "Good Morning"
        if (hour < 17) return "Good Afternoon"
        return "Good Evening"
    }

    function clearForm() {
        formTitle = ""
        formReps = 10
        formSets = 3
        formDuration = 45
        formWorkoutType = "chest"
        showingForm = false
    }

    function saveWorkout() {
        if (formTitle.trim() === "" || workoutsModel.count >= maxWorkouts) return
        
        workoutsModel.append({
            "id": Date.now().toString(),
            "title": formTitle.trim(),
            "reps": formReps,
            "sets": formSets,
            "duration": formDuration,
            "workoutType": formWorkoutType,
            "date": new Date().toISOString()
        })
        
        updateHomePageStats()
        clearForm()
    }

    function deleteWorkout(index) {
        workoutsModel.remove(index)
        updateHomePageStats()
    }

    function updateHomePageStats() {
        var totalDuration = 0
        for (var i = 0; i < workoutsModel.count; i++) {
            totalDuration += workoutsModel.get(i).duration
        }
        // Estimate calories: ~5 cal per minute of exercise
        var caloriesBurned = totalDuration * 5
        workoutUpdated(workoutsModel.count, totalDuration, caloriesBurned)
    }

    function formatDuration(mins) {
        if (mins < 60) return mins + " min"
        var hours = Math.floor(mins / 60)
        var remaining = mins % 60
        if (remaining === 0) return hours + "h"
        return hours + "h " + remaining + "m"
    }

    // ==========================================
    // DATA MODEL
    // ==========================================
    property alias workoutsModel: workoutsModelInternal
    
    ListModel {
        id: workoutsModelInternal
    }

    // ==========================================
    // UI
    // ==========================================
    
    // Greeting text at top
    Text {
        id: greetingText

        anchors.left: parent.left
        anchors.leftMargin: Math.max(16, parent.width * 0.02)
        anchors.top: parent.top
        anchors.topMargin: Math.max(15, parent.height * 0.02)
        anchors.right: parent.right
        anchors.rightMargin: Math.max(16, parent.width * 0.02)

        height: Math.max(40, parent.height * 0.06)

        color: "#afafaf"
        font.family: "PoetsenOne"
        font.pixelSize: Math.max(24, Math.min(36, parent.width / 30))
        font.weight: Font.Normal
        horizontalAlignment: Text.AlignLeft
        text: getGreeting() + ", " + userName + "!"
        verticalAlignment: Text.AlignVCenter
    }

    // Main content area - dynamic grid
    GridLayout {
        id: workout_Content

        anchors.left: parent.left
        anchors.leftMargin: Math.max(16, parent.width * 0.02)
        anchors.top: greetingText.bottom
        anchors.topMargin: Math.max(10, parent.height * 0.015)
        anchors.right: parent.right
        anchors.rightMargin: Math.max(16, parent.width * 0.02)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Math.max(16, parent.height * 0.02)

        columns: 4
        rows: 3
        rowSpacing: Math.max(10, parent.height * 0.02)
        columnSpacing: Math.max(10, parent.width * 0.01)

        // Saved Workouts
        Repeater {
            model: workoutsModel

            Rectangle {
                id: workoutWidget
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                color: workoutColors[model.workoutType] || "#004a7c"
                radius: 8
                
                // Delete button (circular X)
                Rectangle {
                    id: deleteBtn
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: 6
                    anchors.topMargin: 6
                    width: Math.max(20, parent.width * 0.15)
                    height: width
                    radius: width / 2
                    color: deleteBtnArea.pressed ? "#ff1744" : (deleteBtnArea.containsMouse ? "#ff5252" : "#d32f2f")
                    z: 10
                    
                    Behavior on color { ColorAnimation { duration: 150 } }
                    
                    Text {
                        anchors.centerIn: parent
                        text: "×"
                        color: "#ffffff"
                        font.pixelSize: parent.width * 0.7
                        font.weight: Font.Bold
                    }
                    
                    MouseArea {
                        id: deleteBtnArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: deleteWorkout(index)
                    }
                }
                
                // Workout info
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Math.max(10, parent.width * 0.06)
                    anchors.topMargin: Math.max(8, parent.width * 0.08)
                    spacing: 6
                    
                    // Icon
                    Text {
                        text: workoutIcons[model.workoutType] || "🏃"
                        font.pixelSize: Math.max(24, workoutWidget.width * 0.22)
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    // Title
                    Text {
                        text: model.title
                        color: "#ffffff"
                        font.pixelSize: Math.max(12, Math.min(18, workoutWidget.width / 9))
                        font.family: "PoetsenOne"
                        font.weight: Font.Bold
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    
                    Item { Layout.fillHeight: true }
                    
                    // Modern stats row with badges
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 6
                        
                        // Reps badge
                        Rectangle {
                            color: Qt.rgba(1, 1, 1, 0.2)
                            radius: 4
                            implicitWidth: repsLabel.width + 10
                            implicitHeight: repsLabel.height + 6
                            
                            Text {
                                id: repsLabel
                                anchors.centerIn: parent
                                text: model.reps + " reps"
                                color: "#ffffff"
                                font.pixelSize: Math.max(9, Math.min(11, workoutWidget.width / 14))
                                font.family: "Segoe UI"
                                font.weight: Font.Medium
                            }
                        }
                        
                        // Sets badge
                        Rectangle {
                            color: Qt.rgba(1, 1, 1, 0.2)
                            radius: 4
                            implicitWidth: setsLabel.width + 10
                            implicitHeight: setsLabel.height + 6
                            
                            Text {
                                id: setsLabel
                                anchors.centerIn: parent
                                text: model.sets + " sets"
                                color: "#ffffff"
                                font.pixelSize: Math.max(9, Math.min(11, workoutWidget.width / 14))
                                font.family: "Segoe UI"
                                font.weight: Font.Medium
                            }
                        }
                    }
                    
                    // Duration with icon
                    Row {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 4
                        
                        Text {
                            text: "⏱"
                            font.pixelSize: Math.max(10, Math.min(12, workoutWidget.width / 14))
                        }
                        
                        Text {
                            text: formatDuration(model.duration)
                            color: Qt.rgba(1, 1, 1, 0.75)
                            font.pixelSize: Math.max(10, Math.min(12, workoutWidget.width / 13))
                            font.family: "Segoe UI"
                            font.weight: Font.Medium
                        }
                    }
                }
            }
        }

        // Add Widget Form OR Add Widget Button
        Rectangle {
            id: addWidgetContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: workoutsModel.count < maxWorkouts
            
            color: showingForm ? "#0277bd" : (addWidgetArea.pressed ? "#5a5959" : (addWidgetArea.containsMouse ? "#929191" : "#828181"))
            radius: 8
            
            Behavior on color { ColorAnimation { duration: 150 } }

            // Add Widget Button (shown when not adding)
            Item {
                anchors.fill: parent
                visible: !showingForm
                
                Column {
                    anchors.centerIn: parent
                    spacing: 10

                    // Plus icon
                    Item {
                        width: 26
                        height: 26
                        anchors.horizontalCenter: parent.horizontalCenter

                        Shape {
                            x: 0.5
                            y: 13
                            width: 25
                            rotation: 90
                            ShapePath {
                                fillColor: "transparent"
                                strokeColor: "#ffffff"
                                strokeWidth: 5
                                PathLine { x: 25; y: 0 }
                            }
                        }
                        Shape {
                            y: 13
                            width: 26
                            ShapePath {
                                fillColor: "transparent"
                                strokeColor: "#ffffff"
                                strokeWidth: 5
                                PathLine { x: 26; y: 0 }
                            }
                        }
                    }

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "#ffffff"
                        font.family: "PoetsenOne"
                        font.pixelSize: Math.max(14, Math.min(20, addWidgetContainer.width / 8))
                        text: "Add Widget"
                    }
                }

                MouseArea {
                    id: addWidgetArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: showingForm = true
                }
            }

            // Add Exercise Form (shown when adding)
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: Math.max(12, parent.width * 0.05)
                visible: showingForm
                spacing: Math.max(8, parent.height * 0.025)

                // Title Input
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.max(28, parent.height * 0.13)
                    color: "#ffffff"
                    radius: 4

                    TextInput {
                        id: titleInput
                        anchors.fill: parent
                        anchors.margins: 8
                        color: "#333333"
                        font.pixelSize: Math.max(11, Math.min(15, parent.width / 14))
                        font.family: "PoetsenOne"
                        clip: true
                        verticalAlignment: TextInput.AlignVCenter
                        onTextChanged: formTitle = text

                        Text {
                            anchors.fill: parent
                            text: "Workout Title"
                            color: "#888888"
                            font.pixelSize: parent.font.pixelSize
                            font.family: "PoetsenOne"
                            verticalAlignment: Text.AlignVCenter
                            visible: !parent.text && !parent.activeFocus
                        }
                    }
                }

                // Form row: Dropdowns + Type selector
                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.maximumHeight: parent.height * 0.55
                    spacing: Math.max(8, parent.width * 0.03)

                    // Left column: Dropdowns (narrower)
                    ColumnLayout {
                        Layout.fillHeight: true
                        Layout.preferredWidth: parent.width * 0.6
                        spacing: Math.max(4, parent.height * 0.02)

                        // Reps Dropdown
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Math.max(24, parent.height * 0.28)
                            color: "#ffffff"
                            radius: 4

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                anchors.rightMargin: 8
                                spacing: 4

                                Text {
                                    text: "Reps: " + formReps
                                    color: "#333333"
                                    font.pixelSize: Math.max(10, Math.min(13, parent.width / 12))
                                    font.family: "PoetsenOne"
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: "▼"
                                    color: "#666666"
                                    font.pixelSize: 10
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: repsPopup.open()
                            }
                        }

                        // Sets Dropdown
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Math.max(24, parent.height * 0.28)
                            color: "#ffffff"
                            radius: 4

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                anchors.rightMargin: 8
                                spacing: 4

                                Text {
                                    text: "Sets: " + formSets
                                    color: "#333333"
                                    font.pixelSize: Math.max(10, Math.min(13, parent.width / 12))
                                    font.family: "PoetsenOne"
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: "▼"
                                    color: "#666666"
                                    font.pixelSize: 10
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: setsPopup.open()
                            }
                        }

                        // Duration Dropdown
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Math.max(24, parent.height * 0.28)
                            color: "#ffffff"
                            radius: 4

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                anchors.rightMargin: 8
                                spacing: 4

                                Text {
                                    text: formatDuration(formDuration)
                                    color: "#333333"
                                    font.pixelSize: Math.max(10, Math.min(13, parent.width / 12))
                                    font.family: "PoetsenOne"
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: "▼"
                                    color: "#666666"
                                    font.pixelSize: 10
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: durationPopup.open()
                            }
                        }
                    }

                    // Right column: Workout Type Selector (wider square)
                    Rectangle {
                        id: typeSelector
                        Layout.fillHeight: true
                        Layout.preferredWidth: height
                        Layout.minimumWidth: 60
                        color: workoutColors[formWorkoutType]
                        radius: 8

                        Behavior on color { ColorAnimation { duration: 200 } }

                        Column {
                            anchors.centerIn: parent
                            spacing: 6

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: workoutIcons[formWorkoutType]
                                font.pixelSize: Math.max(28, typeSelector.width * 0.4)
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: formWorkoutType.charAt(0).toUpperCase() + formWorkoutType.slice(1)
                                color: "#ffffff"
                                font.pixelSize: Math.max(10, Math.min(14, typeSelector.width / 5))
                                font.family: "PoetsenOne"
                                font.weight: Font.Bold
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: typePopup.open()
                        }
                    }
                }

                // Buttons row
                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.max(32, parent.height * 0.14)
                    spacing: 10

                    // Cancel button
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: cancelBtnArea.pressed ? "#1565c0" : (cancelBtnArea.containsMouse ? "#1e88e5" : "#1976d2")
                        radius: 6

                        Behavior on color { ColorAnimation { duration: 150 } }

                        Text {
                            anchors.centerIn: parent
                            text: "Cancel"
                            color: "#ffffff"
                            font.pixelSize: Math.max(11, Math.min(15, parent.width / 5))
                            font.family: "PoetsenOne"
                            font.weight: Font.Bold
                        }

                        MouseArea {
                            id: cancelBtnArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: clearForm()
                        }
                    }

                    // Save button
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: saveBtnArea.pressed ? "#2e7d32" : (saveBtnArea.containsMouse ? "#43a047" : "#4caf50")
                        radius: 6

                        Behavior on color { ColorAnimation { duration: 150 } }

                        Text {
                            anchors.centerIn: parent
                            text: "Save"
                            color: "#ffffff"
                            font.pixelSize: Math.max(11, Math.min(15, parent.width / 4))
                            font.family: "PoetsenOne"
                            font.weight: Font.Bold
                        }

                        MouseArea {
                            id: saveBtnArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: saveWorkout()
                        }
                    }
                }
            }
        }

        // Empty placeholders to maintain grid when few workouts
        Repeater {
            model: Math.max(0, 11 - workoutsModel.count - (workoutsModel.count < maxWorkouts ? 1 : 0))
            
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    // ==========================================
    // POPUPS
    // ==========================================

    // Reps Popup (1-30)
    Popup {
        id: repsPopup
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 200
        height: 300
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            color: "#2d2d2d"
            radius: 8
            border.color: "#474747"
            border.width: 2
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 5

            Text {
                text: "Select Reps"
                color: "#ffffff"
                font.family: "PoetsenOne"
                font.pixelSize: 16
                Layout.alignment: Qt.AlignHCenter
            }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: 30

                delegate: Rectangle {
                    width: parent ? parent.width : 0
                    height: 30
                    color: repsItemArea.containsMouse ? "#444444" : "transparent"
                    radius: 4

                    Text {
                        anchors.centerIn: parent
                        text: (index + 1) + " reps"
                        color: "#ffffff"
                        font.family: "PoetsenOne"
                        font.pixelSize: 14
                    }

                    MouseArea {
                        id: repsItemArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            formReps = index + 1
                            repsPopup.close()
                        }
                    }
                }
            }
        }
    }

    // Sets Popup (1-5)
    Popup {
        id: setsPopup
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 180
        height: 280
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            color: "#2d2d2d"
            radius: 8
            border.color: "#474747"
            border.width: 2
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            Text {
                text: "Select Sets"
                color: "#ffffff"
                font.family: "PoetsenOne"
                font.pixelSize: 16
                Layout.alignment: Qt.AlignHCenter
            }

            Repeater {
                model: 5

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 36
                    color: setsItemArea.containsMouse ? "#444444" : "#3d3d3d"
                    radius: 4

                    Text {
                        anchors.centerIn: parent
                        text: (index + 1) + " set" + (index > 0 ? "s" : "")
                        color: "#ffffff"
                        font.family: "PoetsenOne"
                        font.pixelSize: 14
                    }

                    MouseArea {
                        id: setsItemArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            formSets = index + 1
                            setsPopup.close()
                        }
                    }
                }
            }
        }
    }

    // Duration Popup (15 min intervals, max 2 hours)
    Popup {
        id: durationPopup
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 200
        height: 320
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            color: "#2d2d2d"
            radius: 8
            border.color: "#474747"
            border.width: 2
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 5

            Text {
                text: "Select Duration"
                color: "#ffffff"
                font.family: "PoetsenOne"
                font.pixelSize: 16
                Layout.alignment: Qt.AlignHCenter
            }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: [15, 30, 45, 60, 75, 90, 105, 120]

                delegate: Rectangle {
                    width: parent ? parent.width : 0
                    height: 32
                    color: durationItemArea.containsMouse ? "#444444" : "transparent"
                    radius: 4

                    Text {
                        anchors.centerIn: parent
                        text: formatDuration(modelData)
                        color: "#ffffff"
                        font.family: "PoetsenOne"
                        font.pixelSize: 14
                    }

                    MouseArea {
                        id: durationItemArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            formDuration = modelData
                            durationPopup.close()
                        }
                    }
                }
            }
        }
    }

    // Workout Type Popup (Chest, Leg, Arm)
    Popup {
        id: typePopup
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 280
        height: 180
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
            anchors.margins: 15
            spacing: 15

            Text {
                text: "Select Workout Type"
                color: "#ffffff"
                font.family: "PoetsenOne"
                font.pixelSize: 18
                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 15

                // Chest
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: chestArea.containsMouse ? "#d32f2f" : "#c62828"
                    radius: 8

                    Behavior on color { ColorAnimation { duration: 150 } }

                    Column {
                        anchors.centerIn: parent
                        spacing: 5

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "🏋️"
                            font.pixelSize: 32
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Chest"
                            color: "#ffffff"
                            font.family: "PoetsenOne"
                            font.pixelSize: 14
                        }
                    }

                    MouseArea {
                        id: chestArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            formWorkoutType = "chest"
                            typePopup.close()
                        }
                    }
                }

                // Leg
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: legArea.containsMouse ? "#f57c00" : "#ef6c00"
                    radius: 8

                    Behavior on color { ColorAnimation { duration: 150 } }

                    Column {
                        anchors.centerIn: parent
                        spacing: 5

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "🦵"
                            font.pixelSize: 32
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Leg"
                            color: "#ffffff"
                            font.family: "PoetsenOne"
                            font.pixelSize: 14
                        }
                    }

                    MouseArea {
                        id: legArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            formWorkoutType = "leg"
                            typePopup.close()
                        }
                    }
                }

                // Arm
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: armArea.containsMouse ? "#1976d2" : "#1565c0"
                    radius: 8

                    Behavior on color { ColorAnimation { duration: 150 } }

                    Column {
                        anchors.centerIn: parent
                        spacing: 5

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "💪"
                            font.pixelSize: 32
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Arm"
                            color: "#ffffff"
                            font.family: "PoetsenOne"
                            font.pixelSize: 14
                        }
                    }

                    MouseArea {
                        id: armArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            formWorkoutType = "arm"
                            typePopup.close()
                        }
                    }
                }
            }
        }
    }
}
