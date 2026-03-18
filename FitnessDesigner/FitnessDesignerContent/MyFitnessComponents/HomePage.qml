import QtQuick 6.0
import QtQuick.Window 6.0

Window {
    id: appWindow
    width:  1920
    height: 1080
    visible: true
    title: "Fitness Freedom"
    flags: Qt.FramelessWindowHint | Qt.Window
    color: "transparent"

    Rectangle {
        id: root
        anchors.fill: parent
        color: "#252525"
        radius: 10

        // ── Sidebar (Menu.ui.qml) — pinned left, full height ──
        Menu {
            id: sideMenu
            x: 0
            y: 0
            width:  259
            height: 1080
            // Start in expanded state
            Component.onCompleted: state = "property_1_Default"

            // Animate width change when state switches
            Behavior on width {
                NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
            }
        }

        // ── MouseAreas overlaid on sidebar buttons ────────────

        // Minimize/Expand toggle (bottom of sidebar)
        MouseArea {
            x: 24
            y: 980
            width:  sideMenu.state === "property_1_Default" ? 211 : 70
            height: 70
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (sideMenu.state === "property_1_Default")
                    sideMenu.state = "property_1_Variant2"
                else
                    sideMenu.state = "property_1_Default"
            }
        }

        // Nutrition nav button
        MouseArea {
            x: 24
            y: 235
            width:  sideMenu.state === "property_1_Default" ? 211 : 70
            height: 70
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: console.log("Navigate: Nutrition")
        }

        // Workout nav button
        MouseArea {
            x: 24
            y: 340
            width:  sideMenu.state === "property_1_Default" ? 211 : 70
            height: 70
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: console.log("Navigate: Workout")
        }

        // ── Main content area ─────────────────────────────────
        Item {
            id: contentArea
            x:      sideMenu.width
            y:      52          // below window controls
            width:  root.width - sideMenu.width
            height: root.height - 52

            Behavior on x {
                NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
            }
        }

        // ── Window controls — exact Figma position: left 1704px ──
        Item {
            id: winControlsArea
            x:      1704
            y:      0
            width:  216
            height: 52

            // Minimize window button
            Item {
                x: 0; y: 0; width: 72; height: 52
                Minimize_1 {
                    id: minBtn
                    anchors.fill: parent
                    Component.onCompleted: state = "property_1_Default"
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked:              appWindow.showMinimized()
                    onContainsMouseChanged: minBtn.state = containsMouse ? "property_1_Variant2" : "property_1_Default"
                    onPressedChanged:       minBtn.state = pressed       ? "property_1_Variant3" : "property_1_Default"
                }
            }

            // Maximize/restore button
            Item {
                x: 72; y: 0; width: 72; height: 52
                FullSize {
                    id: fullBtn
                    anchors.fill: parent
                    Component.onCompleted: state = "property_1_Default"
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (appWindow.visibility === Window.Maximized)
                            appWindow.showNormal()
                        else
                            appWindow.showMaximized()
                    }
                    onContainsMouseChanged: fullBtn.state = containsMouse ? "property_1_Variant2" : "property_1_Default"
                    onPressedChanged:       fullBtn.state = pressed       ? "property_1_Variant3" : "property_1_Default"
                }
            }

            // Exit button
            Item {
                x: 144; y: 0; width: 72; height: 52
                Exit {
                    id: exitBtn
                    anchors.fill: parent
                    Component.onCompleted: state = "property_1_Default"
                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked:              Qt.quit()
                    onContainsMouseChanged: exitBtn.state = containsMouse ? "property_1_Variant2" : "property_1_Default"
                    onPressedChanged:       exitBtn.state = pressed       ? "property_1_Variant3" : "property_1_Default"
                }
            }
        }

        // ── Drag region to move the frameless window ──────────
        MouseArea {
            x:      sideMenu.width
            y:      0
            width:  winControlsArea.x - sideMenu.width
            height: 52
            property point clickPos
            onPressed:         (mouse) => { clickPos = Qt.point(mouse.x, mouse.y) }
            onPositionChanged: (mouse) => {
                appWindow.x += mouse.x - clickPos.x
                appWindow.y += mouse.y - clickPos.y
            }
        }
    }
}
