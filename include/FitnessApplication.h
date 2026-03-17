#pragma once

#include <QtWidgets/QMainWindow>
#include "ui_FitnessApplication.h"

// The FitnessApplication class serves as the main window for the fitness tracking application. 
// It inherits from QMainWindow, which provides a framework for building a GUI application with menus, 
// toolbars, and a central widget. The class includes a constructor and destructor, 
// as well as a private member variable that holds the user interface elements defined in the ui_FitnessApplication.h file. 
// This class will be responsible for initializing the UI and handling user interactions within the application.
class FitnessApplication : public QMainWindow
{
    Q_OBJECT

public:
    FitnessApplication(QWidget *parent = nullptr);
    ~FitnessApplication();

private slots:
    // Slot for handling the creation of a new workout log when the corresponding button is clicked.
    void onCreateWorkout();

private:
    Ui::FitnessApplicationClass *ui;
};