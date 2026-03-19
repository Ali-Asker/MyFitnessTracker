#pragma once
#include <QtWidgets/QMainWindow>

namespace Ui {
    class GUIClass;
}

// The GUI class serves as the main window for the fitness tracking application. 
// It inherits from QMainWindow, which provides a framework for building a GUI application with menus, 
// toolbars, and a central widget. The class includes a constructor and destructor, 
// as well as a private member variable that holds the user interface elements defined in the ui_FitnessApplication.h file. 
// This class will be responsible for initializing the UI and handling user interactions within the application.
class GUI : public QMainWindow
{
    Q_OBJECT

public:
    GUI(QWidget* parent = nullptr);
    ~GUI();

private slots:
    void onCreateWorkout();

private:
    Ui::GUIClass* ui;
};