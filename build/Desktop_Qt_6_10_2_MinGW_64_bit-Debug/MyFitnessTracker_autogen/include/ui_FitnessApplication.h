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
#include <QtWidgets/QGridLayout>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QStatusBar>
#include <QtWidgets/QToolBar>
#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_FitnessApplicationClass
{
public:
    QWidget *centralWidget;
    QWidget *verticalLayoutWidget;
    QVBoxLayout *verticalLayout_2;
    QPushButton *createWorkout;
    QWidget *gridLayoutWidget;
    QGridLayout *gridLayout;
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
        centralWidget->setMaximumSize(QSize(600, 340));
        verticalLayoutWidget = new QWidget(centralWidget);
        verticalLayoutWidget->setObjectName("verticalLayoutWidget");
        verticalLayoutWidget->setGeometry(QRect(0, 0, 601, 32));
        verticalLayout_2 = new QVBoxLayout(verticalLayoutWidget);
        verticalLayout_2->setSpacing(6);
        verticalLayout_2->setContentsMargins(11, 11, 11, 11);
        verticalLayout_2->setObjectName("verticalLayout_2");
        verticalLayout_2->setContentsMargins(0, 0, 0, 0);
        createWorkout = new QPushButton(verticalLayoutWidget);
        createWorkout->setObjectName("createWorkout");
        createWorkout->setMinimumSize(QSize(0, 0));
        createWorkout->setMaximumSize(QSize(30, 30));

        verticalLayout_2->addWidget(createWorkout);

        gridLayoutWidget = new QWidget(centralWidget);
        gridLayoutWidget->setObjectName("gridLayoutWidget");
        gridLayoutWidget->setGeometry(QRect(0, 30, 601, 331));
        gridLayout = new QGridLayout(gridLayoutWidget);
        gridLayout->setSpacing(6);
        gridLayout->setContentsMargins(11, 11, 11, 11);
        gridLayout->setObjectName("gridLayout");
        gridLayout->setContentsMargins(0, 0, 0, 0);
        FitnessApplicationClass->setCentralWidget(centralWidget);
        menuBar = new QMenuBar(FitnessApplicationClass);
        menuBar->setObjectName("menuBar");
        menuBar->setGeometry(QRect(0, 0, 600, 21));
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
        createWorkout->setText(QCoreApplication::translate("FitnessApplicationClass", "+", nullptr));
    } // retranslateUi

};

namespace Ui {
    class FitnessApplicationClass: public Ui_FitnessApplicationClass {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_FITNESSAPPLICATION_H
