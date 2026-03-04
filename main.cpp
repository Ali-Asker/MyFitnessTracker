#include "FitnessApplication.h"
#include <QtWidgets/QApplication>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    FitnessApplication window;
    window.show();
    return app.exec();
}
