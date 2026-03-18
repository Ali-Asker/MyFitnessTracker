import QtQuick
import QtQuick.Controls
import QtQuick.Shapes

Rectangle {
    id: exit1
    width: 72
    height: 52
    color: "transparent"
    state: "property_1_Default"

    Rectangle {
        id: exit
        color: "#474747"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
    }

    Rectangle {
        id: element
        width: 11
        height: 11
        color: "transparent"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 30
        anchors.topMargin: 20
        Shape {
            id: line_1_Stroke_
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: -1
            anchors.rightMargin: -1
            anchors.topMargin: -1
            anchors.bottomMargin: 0
            layer.samples: 16
            layer.enabled: true
            ShapePath {
                id: line_1_Stroke__ShapePath_0
                strokeWidth: 1
                strokeColor: "transparent"
                PathSvg {
                    id: line_1_Stroke__PathSvg_0
                    path: "M 11.46015453338623 0.14644645154476166 C 11.65541721880436 -0.04881550371646881 11.972000151872635 -0.04881547391414642 12.167262077331543 0.14644645154476166 C 12.362524002790451 0.34170837700366974 12.362524032592773 0.6582905501127243 12.167262077331543 0.8535532355308533 L 0.8535533547401428 12.167261123657227 C 0.6582912057638168 12.362523272633553 0.3417087644338608 12.362523272633553 0.1464466154575348 12.167261123657227 C -0.0488155335187912 11.9719989746809 -0.0488155335187912 11.655416682362556 0.1464466154575348 11.46015453338623 L 11.46015453338623 0.14644645154476166 Z"
                }
                fillRule: ShapePath.WindingFill
                fillColor: "#ffffff"
            }
            antialiasing: true
        }

        Shape {
            id: line_2_Stroke_
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: -1
            anchors.rightMargin: -1
            anchors.topMargin: -1
            anchors.bottomMargin: 0
            layer.samples: 16
            layer.enabled: true
            ShapePath {
                id: line_2_Stroke__ShapePath_0
                strokeWidth: 1
                strokeColor: "transparent"
                PathSvg {
                    id: line_2_Stroke__PathSvg_0
                    path: "M 12.167262077331543 11.46015453338623 C 12.362524032592773 11.65541721880436 12.362524002790451 11.972000151872635 12.167262077331543 12.167262077331543 C 11.972000151872635 12.362524002790451 11.65541721880436 12.362524032592773 11.46015453338623 12.167262077331543 L 0.1464466154575348 0.8535533547401428 C -0.0488155335187912 0.6582912057638168 -0.0488155335187912 0.3417087644338608 0.1464466154575348 0.1464466154575348 C 0.3417087644338608 -0.0488155335187912 0.6582912057638168 -0.0488155335187912 0.8535533547401428 0.1464466154575348 L 12.167262077331543 11.46015453338623 Z"
                }
                fillRule: ShapePath.WindingFill
                fillColor: "#ffffff"
            }
            antialiasing: true
        }
    }
    states: [
        State {
            name: "property_1_Variant3"

            AnchorChanges {
                target: element
                anchors.verticalCenter: undefined
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: undefined
                anchors.baseline: undefined
            }

            PropertyChanges {
                target: element
                anchors.rightMargin: 31
                anchors.bottomMargin: 21
            }

            PropertyChanges {
                target: exit
                color: "#a62e2e"
            }

            PropertyChanges {
                target: line_1_Stroke__ShapePath_0
                fillColor: "#737373"
            }

            PropertyChanges {
                target: line_2_Stroke__ShapePath_0
                fillColor: "#737373"
            }
        },
        State {
            name: "property_1_Variant2"

            AnchorChanges {
                target: element
                anchors.verticalCenter: undefined
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: undefined
                anchors.baseline: undefined
            }

            PropertyChanges {
                target: element
                anchors.rightMargin: 31
                anchors.bottomMargin: 21
            }

            PropertyChanges {
                target: exit
                color: "#501616"
            }

            PropertyChanges {
                target: line_1_Stroke__ShapePath_0
                fillColor: "#ffffff"
            }

            PropertyChanges {
                target: line_2_Stroke__ShapePath_0
                fillColor: "#ffffff"
            }
        },
        State {
            name: "property_1_Default"

            AnchorChanges {
                target: element
                anchors.verticalCenter: undefined
                anchors.left: parent.left
                anchors.right: undefined
                anchors.top: parent.top
                anchors.bottom: undefined
                anchors.horizontalCenter: undefined
                anchors.baseline: undefined
            }

            PropertyChanges {
                target: exit
                color: "#474747"
            }

            PropertyChanges {
                target: line_1_Stroke__ShapePath_0
                fillColor: "#ffffff"
            }

            PropertyChanges {
                target: line_2_Stroke__ShapePath_0
                fillColor: "#ffffff"
            }
        }
    ]
}

/*##^##
Designer {
    D{i:0;uuid:"990d0270-1299-5b38-a81b-114533d67273"}D{i:1;uuid:"4a65b94d-c530-5f94-9982-5d495451d1b1"}
D{i:2;uuid:"b2fea41f-785a-5524-a34b-a6005d941b7d"}D{i:3;uuid:"a7125017-7343-50ca-963c-e2f08de365d5"}
D{i:4;uuid:"a7125017-7343-50ca-963c-e2f08de365d5_ShapePath_0"}D{i:5;uuid:"a7125017-7343-50ca-963c-e2f08de365d5-PathSvg_0"}
D{i:6;uuid:"7deaebe6-75bf-5b37-8763-3ecbabbde4a6"}D{i:7;uuid:"7deaebe6-75bf-5b37-8763-3ecbabbde4a6_ShapePath_0"}
D{i:8;uuid:"7deaebe6-75bf-5b37-8763-3ecbabbde4a6-PathSvg_0"}
}
##^##*/

