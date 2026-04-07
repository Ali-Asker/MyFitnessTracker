// main.cpp
// Entry point.
//
// Flow:
//   1. Show SplashScreen immediately (frameless, centered, auto-advances)
//   2. When SplashScreen emits ready(), show MainWindow and close splash
//   3. Hand off to the Qt event loop

#include <QApplication>
#include "SplashScreen.h"
#include "MainWindow.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    // ── Show the splash first ─────────────────────────────────────────────────
    SplashScreen splash;
    splash.show();

    // ── Create the main window but don't show it yet ──────────────────────────
    // We heap-allocate so it outlives this scope after the lambda captures it.
    MainWindow *window = new MainWindow();

    // ── When the splash finishes, open the main window ────────────────────────
    // Qt::QueuedConnection ensures the splash's timer has fully stopped before
    // we do the window switch (avoids a brief flicker on some platforms).
    QObject::connect(&splash, &SplashScreen::ready, window, [&splash, window]() {
        window->show();   // bring up the main app
        splash.close();   // dismiss the splash
    }, Qt::QueuedConnection);

    return app.exec();
}
