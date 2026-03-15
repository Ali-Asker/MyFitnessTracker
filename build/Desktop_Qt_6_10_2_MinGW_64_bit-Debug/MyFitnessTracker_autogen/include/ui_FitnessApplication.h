/********************************************************************************
** Form generated from reading UI file 'FitnessApplication.ui'
**
** Created by: Qt User Interface Compiler version 6.10.2
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_FITNESSAPPLICATION_H
#define UI_FITNESSAPPLICATION_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QStatusBar>
#include <QtWidgets/QToolBar>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_FitnessApplicationClass
{
public:
    QWidget *centralWidget;
    QPushButton *createWorkout;
    QMenuBar *menuBar;
    QToolBar *mainToolBar;
    QStatusBar *statusBar;

    void setupUi(QMainWindow *FitnessApplicationClass)
    {
        if (FitnessApplicationClass->objectName().isEmpty())
            FitnessApplicationClass->setObjectName("FitnessApplicationClass");
        FitnessApplicationClass->resize(600, 400);
        centralWidget = new QWidget(FitnessApplicationClass);
        centralWidget->setObjectName("centralWidget");
        createWorkout = new QPushButton(centralWidget);
        createWorkout->setObjectName("createWorkout");
        createWorkout->setGeometry(QRect(230, 110, 131, 29));
        FitnessApplicationClass->setCentralWidget(centralWidget);
        menuBar = new QMenuBar(FitnessApplicationClass);
        menuBar->setObjectName("menuBar");
        menuBar->setGeometry(QRect(0, 0, 600, 25));
        FitnessApplicationClass->setMenuBar(menuBar);
        mainToolBar = new QToolBar(FitnessApplicationClass);
        mainToolBar->setObjectName("mainToolBar");
        FitnessApplicationClass->addToolBar(Qt::ToolBarArea::TopToolBarArea, mainToolBar);
        statusBar = new QStatusBar(FitnessApplicationClass);
        statusBar->setObjectName("statusBar");
        FitnessApplicationClass->setStatusBar(statusBar);

        retranslateUi(FitnessApplicationClass);

        QMetaObject::connectSlotsByName(FitnessApplicationClass);
    } // setupUi

    void retranslateUi(QMainWindow *FitnessApplicationClass)
    {
        FitnessApplicationClass->setWindowTitle(QCoreApplication::translate("FitnessApplicationClass", "FitnessApplication", nullptr));
        createWorkout->setText(QCoreApplication::translate("FitnessApplicationClass", "Create Workout", nullptr));
    } // retranslateUi

};

namespace Ui {
    class FitnessApplicationClass: public Ui_FitnessApplicationClass {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_FITNESSAPPLICATION_H
