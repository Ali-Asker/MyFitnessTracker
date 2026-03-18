import QtQuick
import QtQuick.Controls
import QtQuick.Shapes

Rectangle {
    id: minimize
    width: 72
    height: 52
    color: "transparent"

    // ── Background ───────────────────────────────────────
    Rectangle {
        id: scene
        anchors.fill: parent
        color: "#474747"
    }

    // ── Dash line — drawn natively, no ShapePath needed ──
    Rectangle {
        id: dashLine
        width: 16
        height: 1
        color: "#ffffff"
        anchors.centerIn: parent
    }

    // ── States ───────────────────────────────────────────
    states: [
        State {
            name: "property_1_Default"
            PropertyChanges { target: scene;    color: "#474747" }
            PropertyChanges { target: dashLine; color: "#ffffff" }
        },
        State {
            name: "property_1_Variant2"
            PropertyChanges { target: scene;    color: "#989898" }
            PropertyChanges { target: dashLine; color: "#ffffff" }
        },
        State {
            name: "property_1_Variant3"
            PropertyChanges { target: scene;    color: "#b2afaf" }
            PropertyChanges { target: dashLine; color: "#737373" }
        }
    ]
}