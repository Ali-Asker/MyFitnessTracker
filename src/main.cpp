#include "GUI.h"
#include <QtWidgets/QApplication>

int main(int argc, char* argv[])
{
	// The main function initializes the QApplication, which is necessary for any Qt application.
    QApplication app(argc, argv);
    GUI window;
    window.show();
    return app.exec();
}