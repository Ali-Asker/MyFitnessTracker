import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

// Compact circular progress indicator for individual nutrients
Item {
    id: root
    
    // Properties
    property string nutrientName: "Protein"
    property real currentValue: 0
    property real goalValue: 100
    property color nutrientColor: "#ff6b6b"
    property string unit: "g"
    
    // Calculate percentage
    property real percentage: goalValue > 0 ? Math.min(currentValue / goalValue, 1) : 0
    
    // Adaptive sizing based on available space - use more of it!
    property real circleSize: Math.min(width * 0.95, height - 30)
    
    Column {
        anchors.centerIn: parent
        width: parent.width
        spacing: 8
        
        // Circular progress
        Item {
            anchors.horizontalCenter: parent.horizontalCenter
            width: root.circleSize
            height: root.circleSize
            
            // Background circle using Canvas
            Canvas {
                id: backgroundCircle
                anchors.fill: parent
                
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    
                    var centerX = width / 2;
                    var centerY = height / 2;
                    var radius = (Math.min(width, height) - 16) / 2;
                    
                    ctx.lineWidth = 10;
                    ctx.strokeStyle = "#3d3d3d";
                    ctx.lineCap = "round";
                    
                    ctx.beginPath();
                    ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
                    ctx.stroke();
                }
                
                Component.onCompleted: requestPaint()
            }
            
            // Progress circle using Canvas
            Canvas {
                id: progressCircle
                anchors.fill: parent
                
                property real animatedPercentage: 0
                
                Behavior on animatedPercentage {
                    NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
                }
                
                onAnimatedPercentageChanged: requestPaint()
                
                Component.onCompleted: {
                    animatedPercentage = root.percentage
                }
                
                // Watch for changes to currentValue or goalValue
                Connections {
                    target: root
                    function onCurrentValueChanged() {
                        progressCircle.animatedPercentage = root.percentage
                    }
                    function onGoalValueChanged() {
                        progressCircle.animatedPercentage = root.percentage
                    }
                }
                
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.reset();
                    
                    var centerX = width / 2;
                    var centerY = height / 2;
                    var radius = (Math.min(width, height) - 16) / 2;
                    
                    ctx.lineWidth = 10;
                    ctx.strokeStyle = root.nutrientColor;
                    ctx.lineCap = "round";
                    
                    var startAngle = -Math.PI / 2; // Start from top
                    var endAngle = startAngle + (animatedPercentage * 2 * Math.PI);
                    
                    ctx.beginPath();
                    ctx.arc(centerX, centerY, radius, startAngle, endAngle);
                    ctx.stroke();
                }
            }
            
            // Center content
            Column {
                anchors.centerIn: parent
                spacing: 2
                
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Math.round(root.currentValue)
                    color: "#ffffff"
                    font.pixelSize: Math.max(20, root.circleSize * 0.26)
                    font.family: "PoetsenOne"
                    font.weight: Font.Bold
                    
                    Behavior on text {
                        SequentialAnimation {
                            NumberAnimation { target: parent; property: "scale"; to: 1.15; duration: 100 }
                            NumberAnimation { target: parent; property: "scale"; to: 1.0; duration: 100 }
                        }
                    }
                }
                
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "/" + Math.round(root.goalValue) + root.unit
                    color: "#888888"
                    font.pixelSize: root.circleSize * 0.1
                    font.family: "PoetsenOne"
                }
            }
            
            // Percentage badge
            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                width: root.circleSize * 0.32
                height: root.circleSize * 0.16
                radius: height / 2
                color: root.percentage >= 1.0 ? "#4CAF50" : root.nutrientColor
                opacity: 0.9
                
                Text {
                    anchors.centerIn: parent
                    text: Math.round(root.percentage * 100) + "%"
                    color: "#ffffff"
                    font.pixelSize: root.circleSize * 0.09
                    font.family: "PoetsenOne"
                    font.weight: Font.Bold
                }
            }
        }
        
        // Label
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.nutrientName
            color: root.nutrientColor
            font.pixelSize: Math.max(11, root.circleSize * 0.13)
            font.family: "PoetsenOne"
            font.letterSpacing: 1
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
