#include <QGuiApplication>
#include <QQuickView>
#include <QUrl>
#include <QtGui/QtGui>

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);

    QQuickView view;
    view.setTitle(QStringLiteral("MyFitnessTracker"));
    // Use a frameless window so only the custom QML chrome is visible
    view.setFlags(Qt::FramelessWindowHint | Qt::Window);
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    
    // Set minimum window size to prevent layout collapse
    view.setMinimumSize(QSize(900, 600));
    // Set initial window size
    view.resize(1366, 768);
    
    view.setSource(QUrl(QStringLiteral("qrc:/Main.qml")));
    if (view.status() != QQuickView::Ready) {
        return -1;
    }

    view.show();
    return app.exec();
}