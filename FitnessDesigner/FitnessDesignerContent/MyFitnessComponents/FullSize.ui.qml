import QtQuick
import QtQuick.Controls

Rectangle {
    id: fullSize
    width: 72
    height: 52
    color: "transparent"
    state: "property_1_Default"

    Rectangle {
        id: scene
        color: "#474747"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
    }

    Rectangle {
        id: copy
        width: 18
        height: 18
        color: "transparent"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 27
        anchors.topMargin: 17
        Rectangle {
            id: back
            width: 12
            height: 12
            color: "transparent"
            radius: 2.5
            border.color: "#ffffff"
            border.width: 1
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 6
        }

        Rectangle {
            id: front
            width: 12
            height: 12
            color: "#474747"
            radius: 2.5
            border.color: "#ffffff"
            border.width: 1
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 6
        }
    }
    states: [
        State {
            name: "property_1_Variant3"

            AnchorChanges {
                target: copy
                anchors.verticalCenter: undefined
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: undefined
                anchors.baseline: undefined
            }

            PropertyChanges {
                target: copy
                anchors.rightMargin: 27
                anchors.bottomMargin: 17
            }

            PropertyChanges {
                target: front
                color: "#b2afaf"
                border.color: "#737373"
            }

            PropertyChanges {
                target: scene
                color: "#b2afaf"
            }

            PropertyChanges {
                target: back
                border.color: "#737373"
            }
        },
        State {
            name: "property_1_Variant2"

            AnchorChanges {
                target: copy
                anchors.verticalCenter: undefined
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: undefined
                anchors.baseline: undefined
            }

            PropertyChanges {
                target: copy
                anchors.rightMargin: 27
                anchors.bottomMargin: 17
            }

            PropertyChanges {
                target: front
                color: "#989898"
                border.color: "#ffffff"
            }

            PropertyChanges {
                target: scene
                color: "#989898"
            }

            PropertyChanges {
                target: back
                border.color: "#ffffff"
            }
        },
        State {
            name: "property_1_Default"

            AnchorChanges {
                target: copy
                anchors.verticalCenter: undefined
                anchors.left: parent.left
                anchors.right: undefined
                anchors.top: parent.top
                anchors.bottom: undefined
                anchors.horizontalCenter: undefined
                anchors.baseline: undefined
            }

            PropertyChanges {
                target: front
                color: "#474747"
                border.color: "#ffffff"
            }

            PropertyChanges {
                target: scene
                color: "#474747"
            }

            PropertyChanges {
                target: back
                border.color: "#ffffff"
            }
        }
    ]
}

/*##^##
Designer {
    D{i:0;uuid:"37a9c9f5-bc15-5b6e-b628-b81552d274bb"}D{i:1;uuid:"48b116f2-2df5-5132-8712-47abe80cd31e"}
D{i:2;uuid:"264888f8-8a3c-5859-8660-1618272ed042"}D{i:3;uuid:"1653ade8-0174-5a18-aa92-b4d5b9b226cf"}
D{i:4;uuid:"46ec05db-31cb-5d76-a9d5-38f34ebdfcdb"}
}
##^##*/

