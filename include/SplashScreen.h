// SplashScreen.h
// A frameless splash window shown at startup before the MainWindow appears.
//
// How it works:
//   1. SplashScreen is shown immediately in main().
//   2. A QTimer fires every 30ms, advancing an internal progress value.
//   3. paintEvent() draws everything manually (logo, title, tagline,
//      animated progress bar) — no child widgets needed.
//   4. When progress reaches 100, the "ready" signal is emitted.
//   5. main() connects that signal to show MainWindow and close the splash.

#pragma once

#include <QWidget>
#include <QTimer>

class SplashScreen : public QWidget
{
    Q_OBJECT

public:
    explicit SplashScreen(QWidget *parent = nullptr);

signals:
    // Emitted once the progress bar reaches 100%.
    // main() listens for this to open the MainWindow.
    void ready();

protected:
    // All drawing is done here — no child widgets
    void paintEvent(QPaintEvent *event) override;

private slots:
    void onTick(); // Called by the timer every 30ms to advance progress

private:
    QTimer *timer;
    int     progress;
};