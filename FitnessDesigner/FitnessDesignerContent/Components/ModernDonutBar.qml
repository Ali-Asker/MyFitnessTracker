import QtQuick
import QtQuick.Layouts

// Center Section: Simple Linear Progress Bars for Macros
Item {
    id: root
    
    // Customizable properties (same as before)
    property real proteinValue: 0
    property real carbsValue: 0
    property real fatValue: 0
    property real caloriesValue: 0
    property real caloriesGoal: 2000
    
    // Goal values for each macro (customize as needed)
    property real proteinGoal: 150
    property real carbsGoal: 250
    property real fatGoal: 65
    
    // Colors (same as before)
    property color proteinColor: "#ff6b6b"
    property color carbsColor: "#feca57"
    property color fatColor: "#54a0ff"
    
    // Enable/disable click navigation
    property bool enableNavigation: true
    signal chartClicked()
    
    Layout.fillHeight: true
    Layout.preferredWidth: parent.height - 20

    // Main container
    Rectangle {
        anchors.fill: parent
        anchors.margins: 8
        color: "#3d3d3d"
        radius: 12

        Column {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            // Calories display at top
            Column {
                width: parent.width
                spacing: 2

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.caloriesValue
                    color: "#ffffff"
                    font.pixelSize: 28
                    font.family: "PoetsenOne"
                    font.weight: Font.Bold
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "/ " + root.caloriesGoal + " kcal"
                    color: "#888888"
                    font.pixelSize: 11
                    font.family: "PoetsenOne"
                }
            }

            // Spacer
            Item { width: 1; height: 8 }

            // Protein progress bar
            Column {
                width: parent.width
                spacing: 4

                Row {
                    width: parent.width
                    Text {
                        text: "Protein"
                        color: root.proteinColor
                        font.pixelSize: 11
                        font.family: "PoetsenOne"
                    }
                    Item { width: 1; Layout.fillWidth: true }
                    Text {
                        anchors.right: parent.right
                        text: root.proteinValue + "g"
                        color: "#cccccc"
                        font.pixelSize: 11
                        font.family: "PoetsenOne"
                    }
                }

                // Progress bar background
                Rectangle {
                    width: parent.width
                    height: 8
                    radius: 4
                    color: "#2a2a2a"

                    // Progress bar fill
                    Rectangle {
                        width: Math.min(parent.width, parent.width * (root.proteinValue / root.proteinGoal))
                        height: parent.height
                        radius: 4
                        color: root.proteinColor

                        Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
                    }
                }
            }

            // Carbs progress bar
            Column {
                width: parent.width
                spacing: 4

                Row {
                    width: parent.width
                    Text {
                        text: "Carbs"
                        color: root.carbsColor
                        font.pixelSize: 11
                        font.family: "PoetsenOne"
                    }
                    Item { width: 1; Layout.fillWidth: true }
                    Text {
                        anchors.right: parent.right
                        text: root.carbsValue + "g"
                        color: "#cccccc"
                        font.pixelSize: 11
                        font.family: "PoetsenOne"
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 8
                    radius: 4
                    color: "#2a2a2a"

                    Rectangle {
                        width: Math.min(parent.width, parent.width * (root.carbsValue / root.carbsGoal))
                        height: parent.height
                        radius: 4
                        color: root.carbsColor

                        Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
                    }
                }
            }

            // Fat progress bar
            Column {
                width: parent.width
                spacing: 4

                Row {
                    width: parent.width
                    Text {
                        text: "Fat"
                        color: root.fatColor
                        font.pixelSize: 11
                        font.family: "PoetsenOne"
                    }
                    Item { width: 1; Layout.fillWidth: true }
                    Text {
                        anchors.right: parent.right
                        text: root.fatValue + "g"
                        color: "#cccccc"
                        font.pixelSize: 11
                        font.family: "PoetsenOne"
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 8
                    radius: 4
                    color: "#2a2a2a"

                    Rectangle {
                        width: Math.min(parent.width, parent.width * (root.fatValue / root.fatGoal))
                        height: parent.height
                        radius: 4
                        color: root.fatColor

                        Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
                    }
                }
            }
        }
    }

    // Click area for navigation
    HandCursor {
        id: clickArea
        enabled: root.enableNavigation
        onClicked: {
            if (root.enableNavigation) {
                console.log("Signal: Navigating to Nutrition page")
                root.chartClicked()
            }
        }
    }
}