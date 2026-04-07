import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: nutritionPage

    color: "#252525"

    // ==========================================
    // PROPERTIES - Nutrition Data
    // ==========================================
    property string userName: "User"
    property int calorieGoal: 2000
    
    // Form input values
    property string mealTitle: ""
    property string mealDescription: ""
    property int mealCalories: 0
    property int mealProtein: 0
    property int mealSugar: 0
    property int mealCarbs: 0
    property int mealFats: 0

    // Today's totals (computed from saved meals)
    property int totalCalories: computeTodayTotal("calories")
    property int totalProtein: computeTodayTotal("protein")
    property int totalCarbs: computeTodayTotal("carbs")
    property int totalFats: computeTodayTotal("fats")
    property int totalSugar: computeTodayTotal("sugar")

    // Signal emitted when nutrition data changes (for HomePage connection)
    signal nutritionUpdated(int calories, int protein, int carbs, int fats, int sugar)

    // ==========================================
    // HELPER FUNCTIONS
    // ==========================================
    function getGreeting() {
        var hour = new Date().getHours()
        if (hour < 12) return "Good Morning"
        if (hour < 17) return "Good Afternoon"
        return "Good Evening"
    }

    function getTodayDate() {
        var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        var months = ["January", "February", "March", "April", "May", "June",
                      "July", "August", "September", "October", "November", "December"]
        var now = new Date()
        return days[now.getDay()] + ", " + months[now.getMonth()] + " " + now.getDate()
    }

    function formatShortDate(daysAgo) {
        var months = ["January", "February", "March", "April", "May", "June",
                      "July", "August", "September", "October", "November", "December"]
        var date = new Date()
        date.setDate(date.getDate() - daysAgo)
        return months[date.getMonth()] + " " + date.getDate()
    }


    // ==========================================
    // DATA MODEL - Saved Meals
    // ==========================================
    ListModel {
        id: savedMealsModel
        // Sample data - will be populated dynamically
    }

    // ==========================================
    // UI COMPONENTS
    // ==========================================
    
    // Date header at top
    Text {
        id: dateHeader

        anchors.left: parent.left
        anchors.leftMargin: Math.max(16, parent.width * 0.02)
        anchors.top: parent.top
        anchors.topMargin: Math.max(15, parent.height * 0.02)
        anchors.right: parent.right
        anchors.rightMargin: Math.max(16, parent.width * 0.02)

        height: Math.max(40, parent.height * 0.06)

        color: "#afafaf"
        font.family: "PoetsenOne"
        font.pixelSize: Math.max(24, Math.min(36, parent.width / 30))
        font.weight: Font.Normal
        horizontalAlignment: Text.AlignLeft
        text: getTodayDate()
        textFormat: Text.PlainText
        verticalAlignment: Text.AlignVCenter
    }

    // Main content area with auto-layout
    ColumnLayout {
        id: nutrition_Content

        anchors.left: parent.left
        anchors.leftMargin: Math.max(16, parent.width * 0.02)
        anchors.top: dateHeader.bottom
        anchors.topMargin: Math.max(10, parent.height * 0.015)
        anchors.right: parent.right
        anchors.rightMargin: Math.max(16, parent.width * 0.02)
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Math.max(16, parent.height * 0.02)

        spacing: Math.max(10, parent.height * 0.015)

        // ==========================================
        // WEEKLY NUTRITION CHART
        // ==========================================
        Rectangle {
            id: chartContainer

            Layout.fillWidth: true
            Layout.preferredHeight: Math.max(180, parent.height * 0.35)
            Layout.minimumHeight: 150

            color: "#004466"
            radius: 8

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 8

                // Chart area with 6 days
                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 8

                    Repeater {
                        model: 6
                        
                        // Each day column
                        Item {
                            id: dayColumn
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            
                            property int daysAgo: 5 - index
                            property int dayCalories: computeDayTotal(daysAgo, "calories")
                            property int dayProtein: computeDayTotal(daysAgo, "protein")
                            property int dayCarbs: computeDayTotal(daysAgo, "carbs")
                            property int dayFats: computeDayTotal(daysAgo, "fats")
                            
                            // Max values for scaling (use goals or reasonable defaults)
                            property real maxProtein: 150
                            property real maxCarbs: 250
                            property real maxFats: 100
                            
                            ColumnLayout {
                                anchors.fill: parent
                                spacing: 4

                                // Calorie count header
                                Text {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 14
                                    text: dayCalories + " / " + nutritionPage.calorieGoal + " kcal"
                                    color: dayCalories > nutritionPage.calorieGoal ? "#ff6b6b" :
                                                                                     dayCalories >= nutritionPage.calorieGoal * 0.9 ? "#4CAF50" : "#ffaa00"
                                    font.pixelSize: Math.max(9, Math.min(12, dayColumn.width / 12))
                                    font.family: "PoetsenOne"
                                    horizontalAlignment: Text.AlignHCenter
                                    elide: Text.ElideRight
                                }

                                // Bar chart area - using Item with anchored bars
                                Item {
                                    id: barArea
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    Layout.minimumHeight: 60

                                    Row {
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.bottom: parent.bottom
                                        anchors.leftMargin: 4
                                        anchors.rightMargin: 4
                                        height: parent.height
                                        spacing: 3

                                        // Carbs bar (Orange)
                                        Item {
                                            width: (parent.width - 6) / 3
                                            height: parent.height

                                            Rectangle {
                                                id: carbsBar
                                                anchors.bottom: parent.bottom
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                width: parent.width
                                                height: dayColumn.dayCarbs > 0 ?
                                                            Math.max(20, (dayColumn.dayCarbs / dayColumn.maxCarbs) * (parent.height - 5)) : 0
                                                color: "#ff9800"
                                                radius: 3
                                                
                                                Behavior on height { NumberAnimation { duration: 300 } }

                                                Text {
                                                    anchors.centerIn: parent
                                                    text: dayColumn.dayCarbs + "g"
                                                    color: "#ffffff"
                                                    font.pixelSize: Math.max(8, Math.min(11, carbsBar.width / 3))
                                                    font.family: "PoetsenOne"
                                                    font.weight: Font.Bold
                                                    visible: carbsBar.height > 18 && carbsBar.width > 20
                                                }
                                            }
                                        }

                                        // Protein bar (Cyan)
                                        Item {
                                            width: (parent.width - 6) / 3
                                            height: parent.height

                                            Rectangle {
                                                id: proteinBar
                                                anchors.bottom: parent.bottom
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                width: parent.width
                                                height: dayColumn.dayProtein > 0 ?
                                                            Math.max(20, (dayColumn.dayProtein / dayColumn.maxProtein) * (parent.height - 5)) : 0
                                                color: "#00bcd4"
                                                radius: 3
                                                
                                                Behavior on height { NumberAnimation { duration: 300 } }

                                                Text {
                                                    anchors.centerIn: parent
                                                    text: dayColumn.dayProtein + "g"
                                                    color: "#ffffff"
                                                    font.pixelSize: Math.max(8, Math.min(11, proteinBar.width / 3))
                                                    font.family: "PoetsenOne"
                                                    font.weight: Font.Bold
                                                    visible: proteinBar.height > 18 && proteinBar.width > 20
                                                }
                                            }
                                        }

                                        // Fats bar (Purple)
                                        Item {
                                            width: (parent.width - 6) / 3
                                            height: parent.height

                                            Rectangle {
                                                id: fatsBar
                                                anchors.bottom: parent.bottom
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                width: parent.width
                                                height: dayColumn.dayFats > 0 ?
                                                            Math.max(20, (dayColumn.dayFats / dayColumn.maxFats) * (parent.height - 5)) : 0
                                                color: "#9c27b0"
                                                radius: 3
                                                
                                                Behavior on height { NumberAnimation { duration: 300 } }

                                                Text {
                                                    anchors.centerIn: parent
                                                    text: dayColumn.dayFats + "g"
                                                    color: "#ffffff"
                                                    font.pixelSize: Math.max(8, Math.min(11, fatsBar.width / 3))
                                                    font.family: "PoetsenOne"
                                                    font.weight: Font.Bold
                                                    visible: fatsBar.height > 18 && fatsBar.width > 20
                                                }
                                            }
                                        }
                                    }
                                }

                                // Date label
                                Text {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 16
                                    text: formatShortDate(daysAgo)
                                    color: daysAgo === 0 ? "#4CAF50" : "#88ccff"
                                    font.pixelSize: Math.max(9, Math.min(12, dayColumn.width / 10))
                                    font.family: "PoetsenOne"
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                        }
                    }
                }

                // Legend
                RowLayout {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 18
                    spacing: 15

                    Item { Layout.fillWidth: true }

                    Row {
                        spacing: 4
                        Rectangle { width: 15; height: 15; radius: 2; color: "#ff9800" }
                        Text { text: "Carbs"; color: "#cccccc"; font.pixelSize: 14; font.family: "PoetsenOne" }
                    }
                    Row {
                        spacing: 4
                        Rectangle { width: 15; height: 15; radius: 2; color: "#00bcd4" }
                        Text { text: "Protein"; color: "#cccccc"; font.pixelSize: 14; font.family: "PoetsenOne" }
                    }
                    Row {
                        spacing: 4
                        Rectangle { width: 15; height: 15; radius: 2; color: "#9c27b0" }
                        Text { text: "Fats"; color: "#cccccc"; font.pixelSize: 14; font.family: "PoetsenOne" }
                    }

                    Item { Layout.fillWidth: true }
                }
            }
        }

        // ==========================================
        // BOTTOM PANELS ROW
        // ==========================================
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 280

            spacing: 15

            // ==========================================
            // LEFT PANEL - Add Meal Form
            // ==========================================
            Rectangle {
                id: add_Nutrition_bg

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: 280

                color: "#3d3d3d"
                radius: 8

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Math.max(10, parent.width * 0.02)
                    spacing: Math.max(6, parent.height * 0.02)

                    // Section Title
                    Text {
                        text: "ADD MEAL"
                        color: "#888888"
                        font.pixelSize: 14
                        font.family: "PoetsenOne"
                        font.letterSpacing: 2
                    }

                    // Meal Title Input
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Math.max(32, add_Nutrition_bg.height * 0.08)
                        Layout.minimumHeight: 28
                        color: "#555555"
                        radius: 4

                        TextInput {
                            id: titleInput
                            anchors.fill: parent
                            anchors.margins: 8
                            color: "#ffffff"
                            font.pixelSize: Math.max(12, Math.min(14, parent.width / 30))
                            font.family: "PoetsenOne"
                            clip: true
                            verticalAlignment: TextInput.AlignVCenter
                            
                            Text {
                                anchors.fill: parent
                                text: "Meal Title (e.g Chicken Curry)"
                                color: "#888888"
                                font.pixelSize: parent.font.pixelSize
                                font.family: "PoetsenOne"
                                verticalAlignment: Text.AlignVCenter
                                visible: !parent.text && !parent.activeFocus
                            }
                        }
                    }

                    // Description Input
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Math.max(45, add_Nutrition_bg.height * 0.12)
                        Layout.minimumHeight: 40
                        color: "#555555"
                        radius: 4

                        TextInput {
                            id: descriptionInput
                            anchors.fill: parent
                            anchors.margins: 8
                            color: "#ffffff"
                            font.pixelSize: Math.max(10, Math.min(12, parent.width / 35))
                            font.family: "PoetsenOne"
                            wrapMode: TextInput.Wrap
                            clip: true
                            
                            Text {
                                anchors.fill: parent
                                text: "Description: (Chicken, Rice, Curry Sauce, etc.)"
                                color: "#888888"
                                font.pixelSize: parent.font.pixelSize
                                font.family: "PoetsenOne"
                                wrapMode: Text.Wrap
                                visible: !parent.text && !parent.activeFocus
                            }
                        }
                    }

                    // Calories Row
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Math.max(28, add_Nutrition_bg.height * 0.07)
                        Layout.minimumHeight: 26
                        spacing: 8

                        Text {
                            text: "Calories"
                            color: "#ff5555"
                            font.pixelSize: Math.max(12, Math.min(16, add_Nutrition_bg.width / 25))
                            font.family: "PoetsenOne"
                            font.weight: Font.Bold
                            Layout.preferredWidth: Math.max(55, add_Nutrition_bg.width * 0.12)
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: "#555555"
                            radius: 4

                            TextInput {
                                id: caloriesInput
                                anchors.fill: parent
                                anchors.margins: 6
                                color: "#ffffff"
                                font.pixelSize: Math.max(11, Math.min(14, add_Nutrition_bg.width / 30))
                                font.family: "PoetsenOne"
                                validator: IntValidator { bottom: 0; top: 9999 }
                                verticalAlignment: TextInput.AlignVCenter
                                
                                Text {
                                    text: "(e.g 1600)"
                                    color: "#888888"
                                    font.pixelSize: parent.font.pixelSize
                                    verticalAlignment: Text.AlignVCenter
                                    visible: !parent.text && !parent.activeFocus
                                }
                            }
                        }

                        Text {
                            text: "Kcal"
                            color: "#ff9999"
                            font.pixelSize: Math.max(11, Math.min(14, add_Nutrition_bg.width / 30))
                            font.family: "PoetsenOne"
                        }
                    }

                    // Protein & Sugar Row
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Math.max(26, add_Nutrition_bg.height * 0.065)
                        Layout.minimumHeight: 24
                        spacing: 8

                        Text {
                            text: "Protein"
                            color: "#00bcd4"
                            font.pixelSize: Math.max(11, Math.min(14, add_Nutrition_bg.width / 30))
                            font.family: "PoetsenOne"
                            font.weight: Font.Bold
                            Layout.preferredWidth: Math.max(45, add_Nutrition_bg.width * 0.1)
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: "#555555"
                            radius: 4

                            TextInput {
                                id: proteinInput
                                anchors.fill: parent
                                anchors.margins: 5
                                color: "#ffffff"
                                font.pixelSize: Math.max(10, Math.min(12, add_Nutrition_bg.width / 35))
                                font.family: "PoetsenOne"
                                validator: IntValidator { bottom: 0; top: 999 }
                                verticalAlignment: TextInput.AlignVCenter
                                
                                Text {
                                    text: "(e.g 20g)"
                                    color: "#888888"
                                    font.pixelSize: parent.font.pixelSize
                                    verticalAlignment: Text.AlignVCenter
                                    visible: !parent.text && !parent.activeFocus
                                }
                            }
                        }

                        Text {
                            text: "Sugar"
                            color: "#e91e63"
                            font.pixelSize: Math.max(11, Math.min(14, add_Nutrition_bg.width / 30))
                            font.family: "PoetsenOne"
                            font.weight: Font.Bold
                            Layout.preferredWidth: Math.max(40, add_Nutrition_bg.width * 0.08)
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: "#555555"
                            radius: 4

                            TextInput {
                                id: sugarInput
                                anchors.fill: parent
                                anchors.margins: 5
                                color: "#ffffff"
                                font.pixelSize: Math.max(10, Math.min(12, add_Nutrition_bg.width / 35))
                                font.family: "PoetsenOne"
                                validator: IntValidator { bottom: 0; top: 999 }
                                verticalAlignment: TextInput.AlignVCenter
                                
                                Text {
                                    text: "(e.g 26g)"
                                    color: "#888888"
                                    font.pixelSize: parent.font.pixelSize
                                    verticalAlignment: Text.AlignVCenter
                                    visible: !parent.text && !parent.activeFocus
                                }
                            }
                        }
                    }

                    // Carbs & Fats Row
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Math.max(26, add_Nutrition_bg.height * 0.065)
                        Layout.minimumHeight: 24
                        spacing: 8

                        Text {
                            text: "Carbs"
                            color: "#ff9800"
                            font.pixelSize: Math.max(11, Math.min(14, add_Nutrition_bg.width / 30))
                            font.family: "PoetsenOne"
                            font.weight: Font.Bold
                            Layout.preferredWidth: Math.max(45, add_Nutrition_bg.width * 0.1)
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: "#555555"
                            radius: 4

                            TextInput {
                                id: carbsInput
                                anchors.fill: parent
                                anchors.margins: 5
                                color: "#ffffff"
                                font.pixelSize: Math.max(10, Math.min(12, add_Nutrition_bg.width / 35))
                                font.family: "PoetsenOne"
                                validator: IntValidator { bottom: 0; top: 999 }
                                verticalAlignment: TextInput.AlignVCenter
                                
                                Text {
                                    text: "(e.g 13g)"
                                    color: "#888888"
                                    font.pixelSize: parent.font.pixelSize
                                    verticalAlignment: Text.AlignVCenter
                                    visible: !parent.text && !parent.activeFocus
                                }
                            }
                        }

                        Text {
                            text: "Fats"
                            color: "#9c27b0"
                            font.pixelSize: Math.max(11, Math.min(14, add_Nutrition_bg.width / 30))
                            font.family: "PoetsenOne"
                            font.weight: Font.Bold
                            Layout.preferredWidth: Math.max(35, add_Nutrition_bg.width * 0.07)
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: "#555555"
                            radius: 4

                            TextInput {
                                id: fatsInput
                                anchors.fill: parent
                                anchors.margins: 5
                                color: "#ffffff"
                                font.pixelSize: Math.max(10, Math.min(12, add_Nutrition_bg.width / 35))
                                font.family: "PoetsenOne"
                                validator: IntValidator { bottom: 0; top: 999 }
                                verticalAlignment: TextInput.AlignVCenter
                                
                                Text {
                                    text: "(e.g 6g)"
                                    color: "#888888"
                                    font.pixelSize: parent.font.pixelSize
                                    verticalAlignment: Text.AlignVCenter
                                    visible: !parent.text && !parent.activeFocus
                                }
                            }
                        }
                    }

                    // Spacer
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: 5
                    }

                    // Buttons row at bottom
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.preferredHeight: Math.max(40, parent.height * 0.12)
                        Layout.minimumHeight: 40
                        Layout.maximumHeight: 60
                        Layout.alignment: Qt.AlignBottom

                        spacing: 10

                        // Clear button
                        Rectangle {
                            id: clear_Button

                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            color: clearArea.pressed ? "#3a3a3a" : (clearArea.containsMouse ? "#5a5a5a" : "#4a4a4a")
                            radius: 5

                            Behavior on color { ColorAnimation { duration: 150 } }

                            Text {
                                anchors.centerIn: parent
                                color: "#ffffff"
                                font.family: "PoetsenOne"
                                font.pixelSize: Math.max(16, Math.min(22, parent.width / 6))
                                font.weight: Font.Bold
                                text: "Clear"
                            }
                            HandCursor {
                                id: clearArea
                                onClicked: clearForm()
                            }
                        }

                        // Post button
                        Rectangle {
                            id: add_Button

                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            color: postArea.pressed ? "#1e5d20" : (postArea.containsMouse ? "#3d9a40" : "#2d7a30")
                            radius: 5

                            Behavior on color { ColorAnimation { duration: 150 } }

                            Text {
                                anchors.centerIn: parent
                                color: "#ffffff"
                                font.family: "PoetsenOne"
                                font.pixelSize: Math.max(16, Math.min(22, parent.width / 6))
                                font.weight: Font.Bold
                                text: "Post"
                            }
                            HandCursor {
                                id: postArea
                                onClicked: addMeal()
                            }
                        }
                    }
                }
            }

            // ==========================================
            // RIGHT PANEL - Saved Nutrients
            // ==========================================
            Rectangle {
                id: saved_Nutrition_bg

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: 280

                color: "#3d3d3d"
                radius: 8

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Math.max(10, parent.width * 0.02)
                    spacing: 10

                    // Section Title
                    Text {
                        text: "SAVED NUTRIENTS"
                        color: "#888888"
                        font.pixelSize: 14
                        font.family: "PoetsenOne"
                        font.letterSpacing: 2
                    }

                    // Scrollable list of saved meals
                    ListView {
                        id: savedMealsList
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        spacing: 8
                        model: savedMealsModel

                        delegate: Rectangle {
                            width: savedMealsList.width
                            height: Math.max(60, savedMealsList.height * 0.18)
                            color: "#5a5a5a"
                            radius: 4

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: Math.max(8, parent.width * 0.02)
                                spacing: 8

                                // Meal info
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    spacing: 2

                                    Text {
                                        text: model.title
                                        color: "#601010"
                                        font.pixelSize: Math.max(12, Math.min(16, savedMealsList.width / 25))
                                        font.family: "PoetsenOne"
                                        font.weight: Font.Bold
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                    }

                                    Text {
                                        text: model.calories + " kcal | P: " + model.protein + "g | C: " + model.carbs + "g | F: " + model.fats + "g"
                                        color: "#aaaaaa"
                                        font.pixelSize: Math.max(9, Math.min(11, savedMealsList.width / 35))
                                        font.family: "PoetsenOne"
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                    }

                                    Text {
                                        text: model.description || ""
                                        color: "#888888"
                                        font.pixelSize: Math.max(8, Math.min(10, savedMealsList.width / 40))
                                        font.family: "PoetsenOne"
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                        visible: model.description !== ""
                                    }
                                }

                                // Delete button
                                Rectangle {
                                    width: Math.max(24, parent.height * 0.5)
                                    height: width
                                    color: deleteArea.pressed ? "#aa2020" : (deleteArea.containsMouse ? "#cc3030" : "#601010")
                                    radius: 4

                                    Behavior on color { ColorAnimation { duration: 150 } }

                                    Text {
                                        anchors.centerIn: parent
                                        text: "×"
                                        color: "#ffffff"
                                        font.pixelSize: parent.width * 0.6
                                        font.weight: Font.Bold
                                    }

                                    HandCursor {
                                        id: deleteArea
                                        onClicked: deleteMeal(index)
                                    }
                                }
                            }
                        }

                        // Empty state
                        Text {
                            anchors.centerIn: parent
                            text: "No meals logged yet.\nAdd a meal to get started!"
                            color: "#666666"
                            font.pixelSize: Math.max(12, Math.min(16, savedMealsList.width / 20))
                            font.family: "PoetsenOne"
                            horizontalAlignment: Text.AlignHCenter
                            visible: savedMealsModel.count === 0
                        }
                    }
                }
            }
        }
    }
}
