import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts

Rectangle {
    id: nutritionPage

    color: "#252525"

    property int mealCount: 0

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
        id: nutrition_Content

        anchors.left: parent.left
        anchors.leftMargin: 24
        anchors.top: good_Morning_USER_.bottom
        anchors.topMargin: 15
        anchors.right: parent.right
        anchors.rightMargin: 24
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24

        spacing: 15

        // Calendar widget - full width, ~40% of content height
        Rectangle {
            id: calendar

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.maximumHeight: parent.height * 0.42

            color: "#0277bd"
            radius: 5
        }

        // Bottom row with two equal panels
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            spacing: 15

            // Left Panel - Add Nutrition with Clear/Post buttons
            Rectangle {
                id: add_Nutrition_bg

                Layout.fillWidth: true
                Layout.fillHeight: true

                color: "#3d3d3d"
                radius: 5

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 15

                    spacing: 10

                    // Content area (placeholder for form fields)
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    // Buttons row at bottom
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        Layout.maximumHeight: 50
                        Layout.alignment: Qt.AlignBottom

                        spacing: 10

                        // Clear button
                        Rectangle {
                            id: clear_Button

                            Layout.fillWidth: true
                            Layout.preferredHeight: 50

                            color: clearArea.pressed ? "#3a3a3a" : (clearArea.containsMouse ? "#5a5a5a" : "#4a4a4a")
                            radius: 3

                            Behavior on color { ColorAnimation { duration: 150 } }

                            Text {
                                id: clear

                                anchors.centerIn: parent

                                color: "#ffffff"
                                font.family: "Arial Rounded MT Bold"
                                font.pixelSize: 24
                                font.weight: Font.Normal
                                text: "Clear"
                            }
                            MouseArea {
                                id: clearArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: nutritionPage.mealCount = 0
                            }
                        }

                        // Post button
                        Rectangle {
                            id: add_Button

                            Layout.fillWidth: true
                            Layout.preferredHeight: 50

                            color: postArea.pressed ? "#1e3d20" : (postArea.containsMouse ? "#3d7a40" : "#2d5a30")
                            radius: 3

                            Behavior on color { ColorAnimation { duration: 150 } }

                            Text {
                                id: post

                                anchors.centerIn: parent

                                color: "#ffffff"
                                font.family: "Arial Rounded MT Bold"
                                font.pixelSize: 24
                                font.weight: Font.Normal
                                text: "Post"
                            }
                            MouseArea {
                                id: postArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: nutritionPage.mealCount++
                            }
                        }
                    }
                }
            }

            // Right Panel - Saved Nutrition with 2 gray bars
            Rectangle {
                id: saved_Nutrition_bg

                Layout.fillWidth: true
                Layout.fillHeight: true

                color: "#3d3d3d"
                radius: 5

                ColumnLayout {
                    id: recent

                    anchors.fill: parent
                    anchors.margins: 15

                    spacing: 10
                    clip: true

                    Rectangle {
                        id: saved_Nutrients

                        Layout.fillWidth: true
                        Layout.preferredHeight: 75
                        Layout.minimumHeight: 50

                        color: "#5a5a5a"
                    }

                    Rectangle {
                        id: saved_Nutrients_1

                        Layout.fillWidth: true
                        Layout.preferredHeight: 75
                        Layout.minimumHeight: 50

                        color: "#5a5a5a"
                    }

                    // Spacer
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }
            }
        }
    }
}
