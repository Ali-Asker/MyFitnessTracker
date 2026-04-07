import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import QtQuick.Controls

// Center Section: Modern Donut Chart for Macros
Item {
    id: root
    
    // Customizable properties
    property real proteinValue: 0
    property real carbsValue: 0
    property real fatValue: 0
    property real caloriesValue: 0
    property real caloriesGoal: 2000
    
    // Optional: Allow customizing colors
    property color proteinColor: "#ff6b6b"
    property color carbsColor: "#feca57"
    property color fatColor: "#54a0ff"
    
    // Optional: Enable/disable click navigation
    property bool enableNavigation: true
    signal chartClicked()
    
    Layout.fillHeight: true
    Layout.preferredWidth: parent.height - 20

    // Background glow effect
    Rectangle {
        anchors.centerIn: parent
        width: donutChart.width + 20
        height: width
        radius: width / 2
        color: "transparent"
        border.color: Qt.rgba(1, 1, 1, 0.05)
        border.width: 8
    }

    // Modern Donut Chart using Shape
    Shape {
        id: donutChart
        anchors.centerIn: parent
        width: Math.min(parent.width, parent.height) - 30
        height: width

        // Calculate totals with fallback to prevent NaN
        property real totalMacros: Math.max(1, root.proteinValue + root.carbsValue + root.fatValue)
        property real proteinAngle: (root.proteinValue / totalMacros) * 360
        property real carbsAngle: (root.carbsValue / totalMacros) * 360
        property real fatAngle: (root.fatValue / totalMacros) * 360

        property real centerX: width / 2
        property real centerY: height / 2
        property real outerRadius: width / 2 - 2
        property real innerRadius: outerRadius * 0.65

        // Smooth animations
        Behavior on proteinAngle { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
        Behavior on carbsAngle { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
        Behavior on fatAngle { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }

        // Protein arc (Coral Red)
        ShapePath {
            fillColor: root.proteinColor
            strokeColor: "transparent"
            startX: donutChart.centerX + donutChart.outerRadius
            startY: donutChart.centerY

            PathArc {
                x: donutChart.centerX + donutChart.outerRadius * Math.cos(donutChart.proteinAngle * Math.PI / 180)
                y: donutChart.centerY + donutChart.outerRadius * Math.sin(donutChart.proteinAngle * Math.PI / 180)
                radiusX: donutChart.outerRadius
                radiusY: donutChart.outerRadius
                useLargeArc: donutChart.proteinAngle > 180
            }
            PathLine {
                x: donutChart.centerX + donutChart.innerRadius * Math.cos(donutChart.proteinAngle * Math.PI / 180)
                y: donutChart.centerY + donutChart.innerRadius * Math.sin(donutChart.proteinAngle * Math.PI / 180)
            }
            PathArc {
                x: donutChart.centerX + donutChart.innerRadius
                y: donutChart.centerY
                radiusX: donutChart.innerRadius
                radiusY: donutChart.innerRadius
                useLargeArc: donutChart.proteinAngle > 180
                direction: PathArc.Counterclockwise
            }
        }

        // Carbs arc (Golden Yellow)
        ShapePath {
            fillColor: root.carbsColor
            strokeColor: "transparent"

            property real startAngle: donutChart.proteinAngle
            property real endAngle: donutChart.proteinAngle + donutChart.carbsAngle

            startX: donutChart.centerX + donutChart.outerRadius * Math.cos(startAngle * Math.PI / 180)
            startY: donutChart.centerY + donutChart.outerRadius * Math.sin(startAngle * Math.PI / 180)

            PathArc {
                x: donutChart.centerX + donutChart.outerRadius * Math.cos((donutChart.proteinAngle + donutChart.carbsAngle) * Math.PI / 180)
                y: donutChart.centerY + donutChart.outerRadius * Math.sin((donutChart.proteinAngle + donutChart.carbsAngle) * Math.PI / 180)
                radiusX: donutChart.outerRadius
                radiusY: donutChart.outerRadius
                useLargeArc: donutChart.carbsAngle > 180
            }
            PathLine {
                x: donutChart.centerX + donutChart.innerRadius * Math.cos((donutChart.proteinAngle + donutChart.carbsAngle) * Math.PI / 180)
                y: donutChart.centerY + donutChart.innerRadius * Math.sin((donutChart.proteinAngle + donutChart.carbsAngle) * Math.PI / 180)
            }
            PathArc {
                x: donutChart.centerX + donutChart.innerRadius * Math.cos(donutChart.proteinAngle * Math.PI / 180)
                y: donutChart.centerY + donutChart.innerRadius * Math.sin(donutChart.proteinAngle * Math.PI / 180)
                radiusX: donutChart.innerRadius
                radiusY: donutChart.innerRadius
                useLargeArc: donutChart.carbsAngle > 180
                direction: PathArc.Counterclockwise
            }
        }

        // Fat arc (Sky Blue)
        ShapePath {
            fillColor: root.fatColor
            strokeColor: "transparent"

            property real startAngle: donutChart.proteinAngle + donutChart.carbsAngle

            startX: donutChart.centerX + donutChart.outerRadius * Math.cos(startAngle * Math.PI / 180)
            startY: donutChart.centerY + donutChart.outerRadius * Math.sin(startAngle * Math.PI / 180)

            PathArc {
                x: donutChart.centerX + donutChart.outerRadius
                y: donutChart.centerY
                radiusX: donutChart.outerRadius
                radiusY: donutChart.outerRadius
                useLargeArc: donutChart.fatAngle > 180
            }
            PathLine {
                x: donutChart.centerX + donutChart.innerRadius
                y: donutChart.centerY
            }
            PathArc {
                x: donutChart.centerX + donutChart.innerRadius * Math.cos((donutChart.proteinAngle + donutChart.carbsAngle) * Math.PI / 180)
                y: donutChart.centerY + donutChart.innerRadius * Math.sin((donutChart.proteinAngle + donutChart.carbsAngle) * Math.PI / 180)
                radiusX: donutChart.innerRadius
                radiusY: donutChart.innerRadius
                useLargeArc: donutChart.fatAngle > 180
                direction: PathArc.Counterclockwise
            }
        }
    }

    // Center circle with calories - modern style
    Rectangle {
        anchors.centerIn: parent
        width: donutChart.width * 0.58
        height: width
        radius: width / 2
        color: "#3d3d3d"

        // Subtle inner shadow effect
        Rectangle {
            anchors.fill: parent
            anchors.margins: 3
            radius: width / 2
            color: "#353535"

            Column {
                anchors.centerIn: parent
                spacing: 4

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.caloriesValue
                    color: "#ffffff"
                    font.pixelSize: 26
                    font.family: "PoetsenOne"
                    font.weight: Font.Bold

                    Behavior on text {
                        SequentialAnimation {
                            NumberAnimation { target: parent; property: "scale"; to: 1.1; duration: 100 }
                            NumberAnimation { target: parent; property: "scale"; to: 1.0; duration: 100 }
                        }
                    }
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 3

                    Text {
                        text: "/"
                        color: "#54a0ff"
                        font.pixelSize: 11
                        font.family: "PoetsenOne"
                    }

                    Text {
                        text: root.caloriesGoal + " kcal"
                        color: "#888888"
                        font.pixelSize: 11
                        font.family: "PoetsenOne"
                    }
                }
            }
        }
    }

    HandCursor {
        id: pieChartArea
        enabled: root.enableNavigation
        // Navigate to Nutrition page when pie chart is clicked
        onClicked: {
            if (root.enableNavigation) {
                console.log("Signal: Navigating to Nutrition page")
                root.chartClicked()
            }
        }
    }
}