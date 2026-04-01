import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts

Rectangle {
    id: homePage

    color: "#252525"

    property int widgetCount: 0

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
        text: "Good Morning, USER!"
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

        // Header widget - full width, takes ~25% of content height
        Rectangle {
            id: header_Widget

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumHeight: parent.height * 0.28

            color: "#474747"
            radius: 5
        }

        // Widgets row - 4 columns with equal width
        RowLayout {
            id: widgetsRow

            Layout.fillWidth: true
            Layout.fillHeight: true

            spacing: 15

            // Column 1: Tall blue widget (full height)
            Rectangle {
                id: essential_Widget1

                Layout.fillWidth: true
                Layout.fillHeight: true

                color: "#004a7c"
                radius: 5
            }

            // Column 2: Blue widget (shorter, aligned to top)
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                Rectangle {
                    id: widget_blue

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.maximumHeight: parent.height * 0.45

                    color: "#004a7c"
                    radius: 5
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
                        onClicked: homePage.widgetCount++
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }

            // Column 4: Tall blue widget (full height)
            Rectangle {
                id: essential_Widget2

                Layout.fillWidth: true
                Layout.fillHeight: true

                color: "#004a7c"
                radius: 5
            }
        }
    }
}
