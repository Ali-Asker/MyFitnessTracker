import QtQuick
import QtQuick.Shapes
import QtQuick.Window

Rectangle {
    id: mainRoot

    // Make the root element fill the view - enables responsive resizing
    // The view's SizeRootObjectToView mode will size the root to the window
    anchors.fill: parent

    // Set minimum sizes to prevent layout collapse
    property int minimumWidth: 900
    property int minimumHeight: 600

    color: "#252525"

    property int currentPage: 0

    SideMenuBar {
        id: sideMenu
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        currentPage: mainRoot.currentPage
        onNavigate: (page) => {
            mainRoot.currentPage = page
        }
    }

    Item {
        id: pageStack
        anchors.left: sideMenu.right
        anchors.leftMargin: 15
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        HomePage {
            anchors.fill: parent
            visible: mainRoot.currentPage === 0
        }
        NutritionPage {
            anchors.fill: parent
            visible: mainRoot.currentPage === 1
        }
        WorkoutPage {
            anchors.fill: parent
            visible: mainRoot.currentPage === 2
        }
    }

    Item {
        id: windowsControl
        anchors.right: parent.right
        anchors.top: parent.top
        z: 2000
        height: 36
        width: 150

        function win() {
            return mainRoot.Window.window
        }

        Item {
            id: minimize_2
            height: 36
            width: 50

            Rectangle {
                id: minimizeBg
                anchors.fill: parent
                color: minimizeArea.pressed ? "#5a5a5a" : (minimizeArea.containsMouse ? "#555555" : "#474747")
                Behavior on color { ColorAnimation { duration: 150 } }
            }
            Shape {
                x: 19.79
                y: 17.65
                height: 0
                width: 10.42
                ShapePath {
                    fillColor: "#00000000"
                    strokeColor: "#ffffff"
                    strokeWidth: 1
                    PathSvg {
                        path: "M 0 0 L 10.416666984558105 0"
                    }
                }
            }
            MouseArea {
                id: minimizeArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: {
                    const w = windowsControl.win()
                    if (w)
                        w.showMinimized()
                }
            }
        }
        Item {
            id: fullSize
            x: 50
            height: 36
            width: 50

            Rectangle {
                id: maximizeBg
                anchors.fill: parent
                color: maximizeArea.pressed ? "#5a5a5a" : (maximizeArea.containsMouse ? "#555555" : "#474747")
                Behavior on color { ColorAnimation { duration: 150 } }
            }
            Item {
                x: 16
                y: 9
                height: 18
                width: 18
                Rectangle {
                    x: 6
                    y: 2
                    height: 10
                    width: 10
                    color: "#ffffff"
                }
                Rectangle {
                    x: 2
                    y: 6
                    height: 10
                    width: 10
                    color: "#ffffff"
                }
                Rectangle {
                    x: 3
                    y: 7
                    height: 8
                    width: 8
                    color: maximizeArea.pressed ? "#5a5a5a" : (maximizeArea.containsMouse ? "#555555" : "#474747")
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
            }
            MouseArea {
                id: maximizeArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: {
                    const w = windowsControl.win()
                    if (!w)
                        return
                    if (w.visibility === Window.Maximized)
                        w.showNormal()
                    else
                        w.showMaximized()
                }
            }
        }
        Item {
            id: exit
            x: 100
            height: 36
            width: 50

            Rectangle {
                id: exitBg
                anchors.fill: parent
                color: exitArea.pressed ? "#aa2020" : (exitArea.containsMouse ? "#e81123" : "#474747")
                Behavior on color { ColorAnimation { duration: 150 } }
            }
            Item {
                x: 21
                y: 14
                height: 7.83
                width: 7.86
                Shape {
                    x: -1.62
                    y: 3.91
                    height: 0
                    width: 11.09
                    rotation: -44.89
                    ShapePath {
                        fillColor: "#00000000"
                        strokeColor: "#ffffff"
                        strokeWidth: 1
                        PathSvg {
                            path: "M 0 0 L 11.09451961517334 0"
                        }
                    }
                }
                Shape {
                    x: -1.62
                    y: 3.92
                    height: 0
                    width: 11.09
                    rotation: 44.89
                    ShapePath {
                        fillColor: "#00000000"
                        strokeColor: "#ffffff"
                        strokeWidth: 1
                        PathSvg {
                            path: "M 0 0 L 11.09451961517334 0"
                        }
                    }
                }
            }
            MouseArea {
                id: exitArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: {
                    const w = windowsControl.win()
                    if (w)
                        w.close()
                }
            }
        }
    }

    MouseArea {
        id: dragArea
        x: sideMenu.width + 8
        y: 8
        width: parent.width - sideMenu.width - 8 - 150 - 8
        height: 40
        hoverEnabled: true
        cursorShape: Qt.SizeAllCursor
        z: 1500
        onPressed: {
            const w = mainRoot.Window.window
            if (w)
                w.startSystemMove()
        }
    }

    Rectangle {
        id: leftResizeHandle
        width: 6
        color: "transparent"
        z: 3000
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeHorCursor
            onPressed: {
                const w = mainRoot.Window.window
                if (w)
                    w.startSystemResize(Qt.LeftEdge)
            }
        }
    }

    Rectangle {
        id: rightResizeHandle
        width: 6
        color: "transparent"
        z: 3000
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeHorCursor
            onPressed: {
                const w = mainRoot.Window.window
                if (w)
                    w.startSystemResize(Qt.RightEdge)
            }
        }
    }

    Rectangle {
        id: topResizeHandle
        height: 6
        color: "transparent"
        z: 3000
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeVerCursor
            onPressed: {
                const w = mainRoot.Window.window
                if (w)
                    w.startSystemResize(Qt.TopEdge)
            }
        }
    }

    Rectangle {
        id: bottomResizeHandle
        height: 6
        color: "transparent"
        z: 3000
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeVerCursor
            onPressed: {
                const w = mainRoot.Window.window
                if (w)
                    w.startSystemResize(Qt.BottomEdge)
            }
        }
    }
}
