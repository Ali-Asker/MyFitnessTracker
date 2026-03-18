import QtQuick
import QtQuick.Controls
import QtQuick.Shapes

Rectangle {
    id: minimize1
    width: 211
    height: 70
    color: "transparent"
    radius: 5
    property alias minimizeText: minimize.text
    state: "property_1_Default"
    clip: true

    Shape {
        id: element
        height: 36
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 15
        anchors.rightMargin: 160
        layer.samples: 16
        layer.enabled: true
        ShapePath {
            id: vector_ShapePath_0
            strokeWidth: 2
            strokeStyle: ShapePath.SolidLine
            strokeColor: "#ffffff"
            PathSvg {
                id: vector_PathSvg_0
                path: "M 25.714285714285715 36 L 25.714285714285715 30.85714285714286 C 25.714285714285715 29.493172287940983 26.25612189940044 28.185067457812174 27.220594678606307 27.220594678606307 C 28.185067457812174 26.25612189940044 29.493172287940983 25.71428571428571 30.85714285714286 25.714285714285715 L 36 25.714285714285715 M 25.714285714285715 0 L 25.714285714285715 5.142857142857143 C 25.714285714285715 6.506827712059021 26.25612189940044 7.814932542187827 27.220594678606307 8.779405321393694 C 28.185067457812174 9.743878100599561 29.493172287940983 10.285714285714286 30.85714285714286 10.285714285714286 L 36 10.285714285714286 M 0 25.714285714285715 L 5.142857142857143 25.714285714285715 C 6.506827712059021 25.714285714285715 7.814932542187827 26.25612189940044 8.779405321393694 27.220594678606307 C 9.743878100599561 28.185067457812174 10.285714285714286 29.493172287940983 10.285714285714286 30.85714285714286 L 10.285714285714286 36 M 0 10.285714285714286 L 5.142857142857143 10.285714285714286 C 6.506827712059021 10.285714285714286 7.814932542187827 9.743878100599561 8.779405321393694 8.779405321393694 C 9.743878100599561 7.814932542187827 10.285714285714286 6.506827712059021 10.285714285714286 5.142857142857143 L 10.285714285714286 0"
            }
            joinStyle: ShapePath.RoundJoin
            fillRule: ShapePath.WindingFill
            fillColor: "transparent"
        }
        antialiasing: true
        anchors.verticalCenterOffset: -2
    }

    Text {
        id: minimize
        width: 92
        height: 24
        color: "#ffffff"
        text: qsTr("Minimize")
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 73
        anchors.topMargin: 23
        font.pixelSize: 20
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.NoWrap
        font.weight: Font.ExtraBold
        font.family: "Inter"
    }
    states: [
        State {
            name: "property_1_Variant3"

            PropertyChanges {
                target: vector_ShapePath_0
                strokeColor: "#000000"
            }

            PropertyChanges {
                target: minimize
                color: "#202020"
            }

            PropertyChanges {
                target: minimize1
                color: "#5d5d5d"
            }
        },
        State {
            name: "property_1_Variant2"

            PropertyChanges {
                target: minimize1
                color: "#989898"
            }

            PropertyChanges {
                target: vector_ShapePath_0
                strokeColor: "#ffffff"
            }

            PropertyChanges {
                target: minimize
                color: "#ffffff"
            }
        },
        State {
            name: "property_1_Default"

            PropertyChanges {
                target: vector_ShapePath_0
                strokeColor: "#ffffff"
            }

            PropertyChanges {
                target: minimize
                color: "#ffffff"
            }

            PropertyChanges {
                target: minimize1
                color: "transparent"
            }
        }
    ]
}

/*##^##
Designer {
    D{i:0;uuid:"a2bb77ef-0756-5f52-b6bc-c79f651c1efe"}D{i:1;uuid:"3af6a889-444a-586f-a2c1-9a79d7875911"}
D{i:2;uuid:"3af6a889-444a-586f-a2c1-9a79d7875911_ShapePath_0"}D{i:3;uuid:"3af6a889-444a-586f-a2c1-9a79d7875911-PathSvg_0"}
D{i:4;uuid:"2650cdc4-968d-5a33-8fdd-e4d2d2d077db"}
}
##^##*/

