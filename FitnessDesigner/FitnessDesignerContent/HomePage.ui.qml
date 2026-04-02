import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import QtQuick.Controls

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
                        // Signal handler: onClicked is triggered when mouse is clicked
                        onClicked: {
                            widgetSelectionPopup.open()
                        }
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

    // Widget Selection Popup - triggered by signal handler above
    Popup {
        id: widgetSelectionPopup
        anchors.centerIn: parent
        width: 500
        height: 400
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        // Popup background
        background: Rectangle {
            color: "#2d2d2d"
            radius: 10
            border.color: "#474747"
            border.width: 2
        }

        // Popup content
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            // Title
            Text {
                Layout.fillWidth: true
                text: "Select a Widget to Add"
                color: "#ffffff"
                font.family: "PoetsenOne"
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
            }

            // Grid of 4 widget options
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
                            text: "📊"
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
                        // Signal handler: handles click on this widget option
                        onClicked: {
                            console.log("Steps Tracker widget selected")
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
                            text: "🍎"
                            font.pixelSize: 48
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Calorie Counter"
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
                        // Signal handler: handles click on this widget option
                        onClicked: {
                            console.log("Calorie Counter widget selected")
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
                        // Signal handler: handles click on this widget option
                        onClicked: {
                            console.log("Heart Rate Monitor widget selected")
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
                        // Signal handler: handles click on this widget option
                        onClicked: {
                            console.log("Water Intake widget selected")
                            homePage.widgetCount++
                            widgetSelectionPopup.close()
                        }
                    }
                }
            }

            // Cancel button
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
                    // Signal handler: handles cancel button click
                    onClicked: {
                        widgetSelectionPopup.close()
                    }
                }
            }
        }

        // Signal handler: triggered when popup is opened
        onOpened: {
            console.log("Widget selection popup opened")
        }

        // Signal handler: triggered when popup is closed
        onClosed: {
            console.log("Widget selection popup closed, total widgets:", homePage.widgetCount)
        }
    }
}
