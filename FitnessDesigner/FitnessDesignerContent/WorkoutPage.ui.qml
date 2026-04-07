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
    property string formTitle: ""   // Default values for new workouts
    property int formReps: 8        // Default values for new workouts
    property int formSets: 2        // Default values for new workouts
    property int formDuration: 30   // in minutes
    property string formWorkoutType: "Strength"  // Strength, Yoga, Cardio
    property date formDate: new Date()  // Calendar date for workout

    // Yoga-specific properties
    property string formYogaStyle: ""   // Name of yoga style
    property string formYogaIntensity: "Medium"  // Low, Medium, Heavy

    // Cardio-specific properties
    property string formCardioType: ""  // "Distance" or "RepBased"
    property double formCardioDistance: 0  // Distance in km/miles

    // Workout type colors
    readonly property var workoutColors: ({
                                              "Strength": "#c62828",
                                              "Yoga": "#e100f5",
                                              "Cardio": "#1565c0"
                                          })

    readonly property var workoutIcons: ({
                                             "Strength": "🏋️",
                                             "Yoga": "🧘‍♀️",
                                             "Cardio": "🏃‍♂️"
                                         })

    // Signal for HomePage connection
    signal workoutUpdated(int totalWorkouts, int totalDuration, int caloriesBurned)

    // ==========================================
    // HELPER FUNCTIONS
    // ==========================================
    function formatDuration(mins) {
        if (mins < 60) return mins + " min"
        var hours = Math.floor(mins / 60)
        var remaining = mins % 60
        if (remaining === 0) return hours + "h"
        return hours + "h " + remaining + "m"
    }

    function formatDate(d) {
        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        return months[d.getMonth()] + " " + d.getDate() + ", " + d.getFullYear()
    }

    function workoutMatchesQuery(title, workoutType) {
        var query = workoutSearchField.text.trim().toLowerCase()
        if (query.length === 0)
            return true

        var normalizedTitle = (title || "").toLowerCase()
        var normalizedType = (workoutType || "").toLowerCase()
        return normalizedTitle.indexOf(query) !== -1 || normalizedType.indexOf(query) !== -1
    }

    function clearAllWorkouts() {
        workoutsModel.clear()
        showingForm = false
        workoutSearchField.text = ""
        workoutUpdated(0, 0, 0)
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
    PageHeaderText {
        id: greetingText

        anchors.left: parent.left
        anchors.leftMargin: Math.max(16, parent.width * 0.02)
        anchors.top: parent.top
        anchors.topMargin: Math.max(15, parent.height * 0.02)
        anchors.right: parent.right
        anchors.rightMargin: Math.max(16, parent.width * 0.02)

        height: Math.max(40, parent.height * 0.06)

        font.pixelSize: Math.max(24, Math.min(36, parent.width / 30))
        text: "Workout Bar!"
    }

    Rectangle {
        id: workoutSearchContainer

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: greetingText.verticalCenter
        width: Math.min(parent.width * 0.36, 320)
        height: Math.max(38, parent.height * 0.05)
        radius: height / 2
        color: workoutSearchField.activeFocus ? "#33353a" : "#2d2f34"
        border.width: workoutSearchField.activeFocus ? 2 : 1
        border.color: workoutSearchField.activeFocus ? "#4fc3f7" : "#4a4d52"
        opacity: 0.95

        Behavior on border.color { ColorAnimation { duration: 120 } }
        Behavior on color { ColorAnimation { duration: 120 } }

        TextInput {
            id: workoutSearchField
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            color: "#ffffff"
            font.family: "Segoe UI"
            font.pixelSize: Math.max(12, Math.min(16, parent.width / 18))
            verticalAlignment: TextInput.AlignVCenter
            clip: true

            Text {
                anchors.fill: parent
                text: "Search workouts"
                color: "#9ea3aa"
                font.family: "Segoe UI"
                font.pixelSize: workoutSearchField.font.pixelSize
                verticalAlignment: Text.AlignVCenter
                visible: !workoutSearchField.text && !workoutSearchField.activeFocus
            }
        }
    }

    Rectangle {
        id: clearWorkoutsButton

        anchors.left: workoutSearchContainer.right
        anchors.leftMargin: 10
        anchors.verticalCenter: workoutSearchContainer.verticalCenter
        width: Math.max(68, parent.width * 0.07)
        height: workoutSearchContainer.height
        radius: height / 2

        color: clearBtnArea.pressed ? "#b71c1c" : (clearBtnArea.containsMouse ? "#d32f2f" : "#c62828")

        Behavior on color { ColorAnimation { duration: 120 } }

        Text {
            anchors.centerIn: parent
            text: "Clear"
            color: "#ffffff"
            font.family: "PoetsenOne"
            font.pixelSize: Math.max(12, Math.min(15, parent.width / 4))
            font.weight: Font.Bold
        }

        HandCursor {
            id: clearBtnArea
            anchors.fill: parent
            onClicked: clearAllWorkouts()
        }
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
                visible: workoutMatchesQuery(model.title, model.workoutType)

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

                    HandCursor {
                        id: deleteBtnArea
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

                HandCursor {
                    id: addWidgetArea
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
                    spacing: 12

                    // Left column: Dynamic inputs based on workout type
                    ColumnLayout {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.preferredWidth: 300
                        Layout.maximumWidth: 400
                        spacing: 6

                        // Calendar Date Selector (for all workout types)
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Math.max(24, parent.height * 0.22)
                            color: "#ffffff"
                            radius: 4
                            border.color: "#cccccc"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                anchors.rightMargin: 8
                                spacing: 4

                                Text {
                                    text: "📅"
                                    font.pixelSize: 14
                                }
                                Text {
                                    text: formatDate(formDate)
                                    color: "#333333"
                                    font.pixelSize: Math.max(10, Math.min(13, parent.width / 14))
                                    font.family: "PoetsenOne"
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: "▼"
                                    color: "#666666"
                                    font.pixelSize: 10
                                }
                            }

                            HandCursor {
                                anchors.fill: parent
                                onClicked: calendarPopup.open()
                            }
                        }

                        // === STRENGTH INPUTS ===
                        // Reps Input (Strength only)
                        Rectangle {
                            visible: formWorkoutType === "Strength" || (formWorkoutType === "Cardio" && formCardioType === "RepBased")
                            Layout.fillWidth: true
                            Layout.preferredHeight: visible ? Math.max(24, parent.height * 0.22) : 0
                            color: "#ffffff"
                            radius: 4
                            border.color: repsField.activeFocus ? "#1976d2" : "#cccccc"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                anchors.rightMargin: 8
                                spacing: 4

                                Text {
                                    text: "Reps:"
                                    color: "#333333"
                                    font.pixelSize: Math.max(10, Math.min(13, parent.width / 12))
                                    font.family: "PoetsenOne"
                                }

                                TextField {
                                    id: repsField
                                    Layout.fillWidth: true
                                    text: formReps.toString()
                                    color: "#333333"
                                    font.pixelSize: Math.max(10, Math.min(13, parent.width / 12))
                                    font.family: "PoetsenOne"
                                    validator: IntValidator { bottom: 1; top: 999 }
                                    background: Rectangle { color: "transparent" }
                                    onTextChanged: {
                                        if (text !== "" && acceptableInput) {
                                            formReps = parseInt(text)
                                        }
                                    }
                                }
                            }
                        }

                        // Sets Input (Strength only)
                        Rectangle {
                            visible: formWorkoutType === "Strength" || (formWorkoutType === "Cardio" && formCardioType === "RepBased")
                            Layout.fillWidth: true
                            Layout.preferredHeight: visible ? Math.max(24, parent.height * 0.22) : 0
                            color: "#ffffff"
                            radius: 4
                            border.color: setsField.activeFocus ? "#1976d2" : "#cccccc"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                anchors.rightMargin: 8
                                spacing: 4

                                Text {
                                    text: "Sets:"
                                    color: "#333333"
                                    font.pixelSize: Math.max(10, Math.min(13, parent.width / 12))
                                    font.family: "PoetsenOne"
                                }

                                TextField {
                                    id: setsField
                                    Layout.fillWidth: true
                                    text: formSets.toString()
                                    color: "#333333"
                                    font.pixelSize: Math.max(10, Math.min(13, parent.width / 12))
                                    font.family: "PoetsenOne"
                                    validator: IntValidator { bottom: 1; top: 999 }
                                    background: Rectangle { color: "transparent" }
                                    onTextChanged: {
                                        if (text !== "" && acceptableInput) {
                                            formSets = parseInt(text)
                                        }
                                    }
                                }
                            }
                        }

                        // === YOGA INPUTS ===
                        // Style Input (Yoga only)
                        Rectangle {
                            visible: formWorkoutType === "Yoga"
                            Layout.fillWidth: true
                            Layout.preferredHeight: visible ? Math.max(24, parent.height * 0.22) : 0
                            color: "#ffffff"
                            radius: 4
                            border.color: styleField.activeFocus ? "#1976d2" : "#cccccc"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                anchors.rightMargin: 8
                                spacing: 4

                                Text {
                                    text: "Style:"
                                    color: "#333333"
                                    font.pixelSize: Math.max(10, Math.min(13, parent.width / 12))
                                    font.family: "PoetsenOne"
                                }

                                TextField {
                                    id: styleField
                                    Layout.fillWidth: true
                                    text: formYogaStyle
                                    color: "#333333"
                                    font.pixelSize: Math.max(10, Math.min(13, parent.width / 12))
                                    font.family: "PoetsenOne"
                                    placeholderText: "e.g. Vinyasa"
                                    background: Rectangle { color: "transparent" }
                                    onTextChanged: formYogaStyle = text
                                }
                            }
                        }

                        // Intensity Dropdown (Yoga only)
                        Rectangle {
                            visible: formWorkoutType === "Yoga"
                            Layout.fillWidth: true
                            Layout.preferredHeight: visible ? Math.max(24, parent.height * 0.22) : 0
                            color: "#ffffff"
                            radius: 4
                            border.color: "#cccccc"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                anchors.rightMargin: 8
                                spacing: 4

                                Text {
                                    text: "Intensity:"
                                    color: "#333333"
                                    font.pixelSize: Math.max(10, Math.min(13, parent.width / 12))
                                    font.family: "PoetsenOne"
                                }
                                Text {
                                    text: formYogaIntensity
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

                            HandCursor {
                                anchors.fill: parent
                                onClicked: intensityPopup.open()
                            }
                        }

                        // === CARDIO INPUTS ===
                        // Cardio Type Selector (Cardio only - shows when no type selected)
                        Rectangle {
                            visible: formWorkoutType === "Cardio" && formCardioType === ""
                            Layout.fillWidth: true
                            Layout.preferredHeight: visible ? Math.max(24, parent.height * 0.22) : 0
                            color: "#1976d2"
                            radius: 4

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                anchors.rightMargin: 8
                                spacing: 4

                                Text {
                                    text: "Select Cardio Type..."
                                    color: "#ffffff"
                                    font.pixelSize: Math.max(10, Math.min(13, parent.width / 12))
                                    font.family: "PoetsenOne"
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: "▼"
                                    color: "#ffffff"
                                    font.pixelSize: 10
                                }
                            }

                            HandCursor {
                                anchors.fill: parent
                                onClicked: cardioTypePopup.open()
                            }
                        }

                        // Cardio Type Display (when type is selected)
                        Rectangle {
                            visible: formWorkoutType === "Cardio" && formCardioType !== ""
                            Layout.fillWidth: true
                            Layout.preferredHeight: visible ? Math.max(24, parent.height * 0.22) : 0
                            color: "#ffffff"
                            radius: 4
                            border.color: "#cccccc"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                anchors.rightMargin: 8
                                spacing: 4

                                Text {
                                    text: "Type:"
                                    color: "#333333"
                                    font.pixelSize: Math.max(10, Math.min(13, parent.width / 12))
                                    font.family: "PoetsenOne"
                                }
                                Text {
                                    text: formCardioType === "Distance" ? "Distance Cardio" : "Rep Based Cardio"
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

                            HandCursor {
                                anchors.fill: parent
                                onClicked: cardioTypePopup.open()
                            }
                        }

                        // Distance Input (Cardio Distance only)
                        Rectangle {
                            visible: formWorkoutType === "Cardio" && formCardioType === "Distance"
                            Layout.fillWidth: true
                            Layout.preferredHeight: visible ? Math.max(24, parent.height * 0.22) : 0
                            color: "#ffffff"
                            radius: 4
                            border.color: distanceField.activeFocus ? "#1976d2" : "#cccccc"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                anchors.rightMargin: 8
                                spacing: 4

                                Text {
                                    text: "Distance (km):"
                                    color: "#333333"
                                    font.pixelSize: Math.max(10, Math.min(13, parent.width / 12))
                                    font.family: "PoetsenOne"
                                }

                                TextField {
                                    id: distanceField
                                    Layout.fillWidth: true
                                    text: formCardioDistance > 0 ? formCardioDistance.toString() : ""
                                    color: "#333333"
                                    font.pixelSize: Math.max(10, Math.min(13, parent.width / 12))
                                    font.family: "PoetsenOne"
                                    validator: DoubleValidator { bottom: 0.1; top: 999; decimals: 2 }
                                    background: Rectangle { color: "transparent" }
                                    onTextChanged: {
                                        if (text !== "" && acceptableInput) {
                                            formCardioDistance = parseFloat(text)
                                        }
                                    }
                                }
                            }
                        }

                        // Duration Input (for all types)
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: Math.max(24, parent.height * 0.22)
                            color: "#ffffff"
                            radius: 4
                            border.color: durationField.activeFocus ? "#1976d2" : "#cccccc"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 8
                                anchors.rightMargin: 8
                                spacing: 4

                                Text {
                                    text: "Duration (min):"
                                    color: "#333333"
                                    font.pixelSize: Math.max(10, Math.min(13, parent.width / 12))
                                    font.family: "PoetsenOne"
                                }

                                TextField {
                                    id: durationField
                                    Layout.fillWidth: true
                                    text: formDuration.toString()
                                    color: "#333333"
                                    font.pixelSize: Math.max(10, Math.min(13, parent.width / 12))
                                    font.family: "PoetsenOne"
                                    validator: IntValidator { bottom: 1; top: 999 }
                                    background: Rectangle { color: "transparent" }
                                    onTextChanged: {
                                        if (text !== "" && acceptableInput) {
                                            formDuration = parseInt(text)
                                        }
                                    }
                                }
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

                        HandCursor {
                            anchors.fill: parent
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

                        HandCursor {
                            id: cancelBtnArea
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

                        HandCursor {
                            id: saveBtnArea
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

                // Strength
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: strengthArea.containsMouse ? "#d32f2f" : "#c62828"
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
                            text: "Strength"
                            color: "#ffffff"
                            font.family: "PoetsenOne"
                            font.pixelSize: 14
                        }
                    }

                    HandCursor {
                        id: strengthArea
                        onClicked: {
                            formWorkoutType = "Strength"
                            typePopup.close()
                        }
                    }
                }

                // Yoga
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: yogaArea.containsMouse ? '#e100f5' : "#e100f5"
                    radius: 8

                    Behavior on color { ColorAnimation { duration: 150 } }

                    Column {
                        anchors.centerIn: parent
                        spacing: 5

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "🧘‍♀️"
                            font.pixelSize: 32
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Yoga"
                            color: "#ffffff"
                            font.family: "PoetsenOne"
                            font.pixelSize: 14
                        }
                    }

                    HandCursor {
                        id: yogaArea
                        onClicked: {
                            formWorkoutType = "Yoga"
                            typePopup.close()
                        }
                    }
                }

                // Cardio
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: cardioArea.containsMouse ? "#1976d2" : "#1565c0"
                    radius: 8

                    Behavior on color { ColorAnimation { duration: 150 } }

                    Column {
                        anchors.centerIn: parent
                        spacing: 5

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "🏃‍♂️"
                            font.pixelSize: 32
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Cardio"
                            color: "#ffffff"
                            font.family: "PoetsenOne"
                            font.pixelSize: 14
                        }
                    }

                    HandCursor {
                        id: cardioArea
                        onClicked: {
                            formWorkoutType = "Cardio"
                            formCardioType = ""  // Reset cardio type to show selection
                            typePopup.close()
                        }
                    }
                }
            }
        }
    }


    // Intensity Popup (for Yoga)
    Popup {
        id: intensityPopup
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 280
        height: 200
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
            spacing: 12

            Text {
                text: "Select Intensity"
                color: "#ffffff"
                font.family: "PoetsenOne"
                font.pixelSize: 18
                Layout.alignment: Qt.AlignHCenter
            }

            // Low
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                color: lowArea.containsMouse ? "#388e3c" : "#4caf50"
                radius: 6

                Behavior on color { ColorAnimation { duration: 150 } }

                Text {
                    anchors.centerIn: parent
                    text: "🌿 Low"
                    color: "#ffffff"
                    font.family: "PoetsenOne"
                    font.pixelSize: 16
                }

                HandCursor {
                    id: lowArea
                    onClicked: {
                        formYogaIntensity = "Low"
                        intensityPopup.close()
                    }
                }
            }

            // Medium
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                color: mediumArea.containsMouse ? "#f57c00" : "#ff9800"
                radius: 6

                Behavior on color { ColorAnimation { duration: 150 } }

                Text {
                    anchors.centerIn: parent
                    text: "🔥 Medium"
                    color: "#ffffff"
                    font.family: "PoetsenOne"
                    font.pixelSize: 16
                }

                HandCursor {
                    id: mediumArea
                    onClicked: {
                        formYogaIntensity = "Medium"
                        intensityPopup.close()
                    }
                }
            }

            // Heavy
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                color: heavyArea.containsMouse ? "#c62828" : "#d32f2f"
                radius: 6

                Behavior on color { ColorAnimation { duration: 150 } }

                Text {
                    anchors.centerIn: parent
                    text: "💪 Heavy"
                    color: "#ffffff"
                    font.family: "PoetsenOne"
                    font.pixelSize: 16
                }

                HandCursor {
                    id: heavyArea
                    onClicked: {
                        formYogaIntensity = "Heavy"
                        intensityPopup.close()
                    }
                }
            }
        }
    }

    // Cardio Type Popup
    Popup {
        id: cardioTypePopup
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
                text: "Select Cardio Type"
                color: "#ffffff"
                font.family: "PoetsenOne"
                font.pixelSize: 18
                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 15

                // Distance Cardio
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: distanceCardioArea.containsMouse ? "#1976d2" : "#1565c0"
                    radius: 8

                    Behavior on color { ColorAnimation { duration: 150 } }

                    Column {
                        anchors.centerIn: parent
                        spacing: 5

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "🏃"
                            font.pixelSize: 32
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Distance"
                            color: "#ffffff"
                            font.family: "PoetsenOne"
                            font.pixelSize: 14
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Cardio"
                            color: "#cccccc"
                            font.family: "PoetsenOne"
                            font.pixelSize: 11
                        }
                    }

                    HandCursor {
                        id: distanceCardioArea
                        onClicked: {
                            formCardioType = "Distance"
                            cardioTypePopup.close()
                        }
                    }
                }

                // Rep Based Cardio
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: repCardioArea.containsMouse ? "#7b1fa2" : "#9c27b0"
                    radius: 8

                    Behavior on color { ColorAnimation { duration: 150 } }

                    Column {
                        anchors.centerIn: parent
                        spacing: 5

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "🔄"
                            font.pixelSize: 32
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Rep Based"
                            color: "#ffffff"
                            font.family: "PoetsenOne"
                            font.pixelSize: 14
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Cardio"
                            color: "#cccccc"
                            font.family: "PoetsenOne"
                            font.pixelSize: 11
                        }
                    }

                    HandCursor {
                        id: repCardioArea
                        onClicked: {
                            formCardioType = "RepBased"
                            cardioTypePopup.close()
                        }
                    }
                }
            }
        }
    }
}
