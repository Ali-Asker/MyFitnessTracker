cmake_minimum_required(VERSION 3.16)

find_package(Qt6 REQUIRED COMPONENTS Core Qml Quick)

# Set Qt policies to use custom resource prefix (not :/qt/qml/)
qt_policy(SET QTP0001 OLD)

qt_add_qml_module(FitnessDesigner
    URI FitnessDesigner
    VERSION 1.0
    RESOURCE_PREFIX /
    
    QML_FILES
        FitnessDesignerContent/Main.qml
        FitnessDesignerContent/SideMenuBar.qml
        FitnessDesignerContent/HomePage.ui.qml
        FitnessDesignerContent/WorkoutPage.ui.qml
        FitnessDesignerContent/NutritionPage.ui.qml
    
    RESOURCES
        FitnessDesignerContent/fonts/poetsenone-regular.ttf
        FitnessDesignerContent/fonts/inter-extrabold.ttf
)
