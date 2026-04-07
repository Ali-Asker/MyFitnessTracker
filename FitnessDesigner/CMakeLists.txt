cmake_minimum_required(VERSION 3.16)

find_package(Qt6 REQUIRED COMPONENTS Core Qml Quick)

# Set Qt policies to use custom resource prefix (not :/qt/qml/)
qt_policy(SET QTP0001 OLD)

# Auto-discover QML files so new components are available without manually editing this file.
file(GLOB_RECURSE FITNESSDESIGNER_QML_FILES CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/FitnessDesignerContent/*.qml"
)

qt_add_qml_module(FitnessDesigner
    URI FitnessDesigner
    VERSION 1.0
    RESOURCE_PREFIX /
    
    QML_FILES
        ${FITNESSDESIGNER_QML_FILES}
    
    RESOURCES
        FitnessDesignerContent/fonts/poetsenone-regular.ttf
        FitnessDesignerContent/fonts/inter-extrabold.ttf
)
