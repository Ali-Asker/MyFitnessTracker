import QtQuick
import QtQuick.Layouts

// Simple linear progress bar for individual nutrients
Item {
    id: root
    
    // Properties (same as before)
    property string nutrientName: "Protein"
    property real currentValue: 0
    property real goalValue: 100
    property color nutrientColor: "#ff6b6b"
    property string unit: "g"
    
    // Calculate percentage
    property real percentage: goalValue > 0 ? Math.min(currentValue / goalValue, 1) : 0

    // Main container
    Rectangle {
        anchors.fill: parent
        anchors.margins: 4

        Column {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 2

            // Nutrient name at top
            Text {
                width: parent.width
                text: root.nutrientName
                color: root.nutrientColor
                font.pixelSize: 11
                font.family: "PoetsenOne"
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignHCenter
            }

            // Progress bar
            Rectangle {
                width: parent.width
                height: 8
                color: "#2a2a2a"

                Rectangle {
                    width: Math.min(parent.width, parent.width * root.percentage)
                    height: parent.height / 2
                    radius: 5
                    color: root.percentage >= 1.0 ? "#4CAF50" : root.nutrientColor

                    Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
                }
            }

            // Value display below progress bar
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 2

                Text {
                    text: Math.round(root.currentValue)
                    color: "#ffffff"
                    font.pixelSize: 18
                    font.family: "PoetsenOne"
                    font.weight: Font.Bold
                }

                Text {
                    anchors.baseline: parent.children[0].baseline
                    text: " / " + Math.round(root.goalValue) + root.unit
                    color: "#888888"
                    font.pixelSize: 11
                    font.family: "PoetsenOne"
                }
            }
        }
    }
}
