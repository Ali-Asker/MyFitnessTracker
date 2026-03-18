import QtQuick
import QtQuick.Controls

Rectangle {
    id: homePage
    width: 1920
    height: 1080
    color: "#252525"
    radius: 10

    Image {
        id: element
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: -2
        anchors.topMargin: -5
        source: "assets"
    }

    Rectangle {
        id: windowsControl
        width: 216
        height: 52
        color: "transparent"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 1704
        Minimize {
            id: minimize
            width: 72
            height: 52
            anchors.left: parent.left
            anchors.top: parent.top
            state: "property_1_Default"
        }

        FullSize {
            id: fullSize
            width: 72
            height: 52
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 72
            state: "property_1_Default"
        }

        Exit {
            id: exit
            width: 72
            height: 52
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 144
            state: "property_1_Default"
        }
    }
}

/*##^##
Designer {
    D{i:0;uuid:"ec44807d-a2cb-5296-b14d-09664d9e888e"}D{i:1;uuid:"7e6ba4ff-1f1f-5df5-a7ef-46356281e71a"}
D{i:2;uuid:"76e0be1a-48f0-5af3-ae12-b4a19d927a2f"}D{i:3;uuid:"043cf628-48cb-5b56-a879-bb6e25f523aa"}
D{i:4;uuid:"b4e9be83-4a2a-5d29-a7fb-785f5bb161ca"}D{i:5;uuid:"6aa156c0-e82b-59b0-bb7b-edad7c8f8c9b"}
}
##^##*/

