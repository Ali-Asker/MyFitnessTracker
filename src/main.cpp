#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QUrl>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    // Load the interactive HomePage (wraps all Qt Bridge .ui.qml components)
    const QUrl mainQmlUrl(QStringLiteral("qrc:/FitnessDesignerContent/MyFitnessComponents/HomePage.qml"));
    engine.load(mainQmlUrl);
    if (engine.rootObjects().isEmpty()) {
        return -1;
    }

    return app.exec();
}
