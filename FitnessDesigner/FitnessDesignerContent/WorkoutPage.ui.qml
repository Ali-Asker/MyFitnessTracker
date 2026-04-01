import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts

Rectangle {
    id: workoutPage

    color: "#252525"

    property int calendarMonthIndex: 0
    readonly property var monthNames: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    property int workoutWidgetCount: 0

    // Greeting text at top
    Text {
        id: good_Morning_User_

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
        text: "Good Morning, User!"
        textFormat: Text.PlainText
        verticalAlignment: Text.AlignVCenter
    }

    // Main content area - 3x4 grid of widgets
    GridLayout {
        id: workout_Content

        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.top: good_Morning_User_.bottom
        anchors.topMargin: 15
        anchors.right: parent.right
        anchors.rightMargin: 24
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24

        columns: 4
        rows: 3
        rowSpacing: 15
        columnSpacing: 15

        // Row 1
        Rectangle { Layout.fillWidth: true; Layout.fillHeight: true; color: "#004a7c"; radius: 5 }
        Rectangle { Layout.fillWidth: true; Layout.fillHeight: true; color: "#004a7c"; radius: 5 }
        Rectangle { Layout.fillWidth: true; Layout.fillHeight: true; color: "#004a7c"; radius: 5 }
        Rectangle { Layout.fillWidth: true; Layout.fillHeight: true; color: "#004a7c"; radius: 5 }

        // Row 2
        Rectangle { Layout.fillWidth: true; Layout.fillHeight: true; color: "#004a7c"; radius: 5 }
        Rectangle { Layout.fillWidth: true; Layout.fillHeight: true; color: "#004a7c"; radius: 5 }
        Rectangle { Layout.fillWidth: true; Layout.fillHeight: true; color: "#004a7c"; radius: 5 }
        Rectangle { Layout.fillWidth: true; Layout.fillHeight: true; color: "#004a7c"; radius: 5 }

        // Row 3
        Rectangle { Layout.fillWidth: true; Layout.fillHeight: true; color: "#004a7c"; radius: 5 }
        Rectangle { Layout.fillWidth: true; Layout.fillHeight: true; color: "#004a7c"; radius: 5 }
        Rectangle { Layout.fillWidth: true; Layout.fillHeight: true; color: "#004a7c"; radius: 5 }

        // Add Widget button (bottom right)
        Rectangle {
            id: widget

            Layout.fillWidth: true
            Layout.fillHeight: true

            color: workoutAddArea.pressed ? "#5a5959" : (workoutAddArea.containsMouse ? "#929191" : "#828181")
            radius: 5

            Behavior on color { ColorAnimation { duration: 150 } }

            Item {
                anchors.centerIn: parent
                width: childrenRect.width
                height: childrenRect.height

                Column {
                    spacing: 10
                    anchors.horizontalCenter: parent.horizontalCenter

                    Item {
                        id: _x_1
                        width: 26.52
                        height: 25.37
                        anchors.horizontalCenter: parent.horizontalCenter

                        Shape {
                            id: line_3
                            x: 0.58
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
                            width: 26.52
                            rotation: 0

                            ShapePath {
                                fillColor: "#00000000"
                                strokeColor: "#ffffff"
                                strokeWidth: 6
                                PathSvg {
                                    path: "M 0 0 L 26.520000457763672 0"
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
                        text: "Add Widget"
                    }
                }
            }

            MouseArea {
                id: workoutAddArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: workoutPage.workoutWidgetCount++
            }
        }
    }
}
