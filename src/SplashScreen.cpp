// SplashScreen.cpp
// Draws a dark frameless splash window with:
//   - App name + tagline centered on screen
//   - A thin animated green progress bar at the bottom
//   - A small "Loading…" status label that updates as progress grows
// Everything is painted manually in paintEvent() for full control.

#include "SplashScreen.h"

#include <QFont>
#include <QGuiApplication>
#include <QLinearGradient>
#include <QPaintEvent>
#include <QPainter>
#include <QPainterPath>
#include <QScreen>

// Total duration of the splash in milliseconds.
// With a 30ms tick and 100 steps: 30 * 100 = 3000ms = 3 seconds.
static constexpr int TICK_MS = 30;
static constexpr int TOTAL_STEPS = 100;

SplashScreen::SplashScreen(QWidget *parent)
    : QWidget(parent)
    , progress(0)
{
    // ── Window flags ─────────────────────────────────────────────────────────
    // Frameless: no title bar, no borders — just our painted surface
    // Tool: keeps it off the taskbar
    // StayOnTop: stays above other windows while loading
    setWindowFlags(Qt::FramelessWindowHint | Qt::Tool | Qt::WindowStaysOnTopHint);
    setAttribute(Qt::WA_TranslucentBackground, false);

    // Fixed size — centered on screen below
    setFixedSize(520, 300);

    // Center the splash on the primary screen
    QScreen *screen = QGuiApplication::primaryScreen();
    if (screen) {
        QRect sg = screen->availableGeometry();
        move(sg.center() - rect().center());
    }

    // ── Timer ─────────────────────────────────────────────────────────────────
    // Each tick advances progress by 1 and triggers a repaint
    timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, &SplashScreen::onTick);
    timer->start(TICK_MS);
}

// ── onTick ────────────────────────────────────────────────────────────────────
void SplashScreen::onTick()
{
    progress++;
    update(); // schedule a repaint

    if (progress >= TOTAL_STEPS) {
        timer->stop();
        emit ready(); // tell main() we're done
    }
}

// ── paintEvent ────────────────────────────────────────────────────────────────
// Everything visible is drawn here: background, logo mark, text, bar.
void SplashScreen::paintEvent(QPaintEvent *)
{
    QPainter p(this);
    p.setRenderHint(QPainter::Antialiasing);

    const QRect r = rect();
    const int w = r.width();
    const int h = r.height();
    const QColor bg = QColor("#1a1a1a");
    const QColor accent = QColor("#39FF14"); // neon green — matches the app theme
    const QColor dim = QColor("#444444");
    const QColor white = QColor("#e8e8e8");
    const QColor grey = QColor("#777777");

    // ── Background ────────────────────────────────────────────────────────────
    p.fillRect(r, bg);

    // Subtle green glow in the top-left corner for depth
    QRadialGradient glow(80, 80, 180);
    glow.setColorAt(0, QColor(57, 255, 20, 30)); // very faint green
    glow.setColorAt(1, Qt::transparent);
    p.fillRect(r, glow);

    // ── Thin border ───────────────────────────────────────────────────────────
    p.setPen(QPen(QColor("#2e2e2e"), 1));
    p.drawRect(r.adjusted(0, 0, -1, -1));

    // ── Logo mark: a simple hexagon with a lightning bolt feel ───────────────
    // Drawn as a rounded square rotated 45° with the accent colour
    {
        p.save();
        p.translate(w / 2, 80);

        // Outer ring
        p.setPen(QPen(accent, 2));
        p.setBrush(QColor(57, 255, 20, 18)); // very faint fill
        p.drawEllipse(QPointF(0, 0), 34, 34);

        // Inner "M" mark — two chevrons suggesting a pulse/metric line
        QPen pulsePen(accent, 2.5, Qt::SolidLine, Qt::RoundCap, Qt::RoundJoin);
        p.setPen(pulsePen);
        p.setBrush(Qt::NoBrush);

        // Draw a simple heartbeat-style path
        QPainterPath pulse;
        pulse.moveTo(-22, 4);
        pulse.lineTo(-10, 4);
        pulse.lineTo(-5, -14);
        pulse.lineTo(0, 18);
        pulse.lineTo(5, -6);
        pulse.lineTo(10, 4);
        pulse.lineTo(22, 4);
        p.drawPath(pulse);

        p.restore();
    }

    // ── App name ──────────────────────────────────────────────────────────────
    QFont titleFont("Segoe UI", 26, QFont::Bold);
    p.setFont(titleFont);
    p.setPen(white);
    QRect titleRect(0, 128, w, 36);
    p.drawText(titleRect, Qt::AlignHCenter | Qt::AlignVCenter, "MyFitnessTracker");

    // ── Tagline ───────────────────────────────────────────────────────────────
    QFont tagFont("Segoe UI", 10, QFont::Normal);
    p.setFont(tagFont);
    p.setPen(grey);
    QRect tagRect(0, 166, w, 22);
    p.drawText(tagRect, Qt::AlignHCenter | Qt::AlignVCenter, "Track. Analyse. Improve.");

    // ── Progress bar track (background) ──────────────────────────────────────
    const int barH = 3;    // very thin bar — clean and modern
    const int barPad = 48; // horizontal padding on each side
    const int barY = h - 44;
    const int barW = w - barPad * 2;

    p.setPen(Qt::NoPen);
    p.setBrush(dim);
    p.drawRoundedRect(barPad, barY, barW, barH, 2, 2);

    // ── Progress bar fill ─────────────────────────────────────────────────────
    int filled = static_cast<int>(barW * progress / 100.0);
    if (filled > 0) {
        // Gradient from a slightly darker green to the full neon accent
        QLinearGradient grad(barPad, 0, barPad + barW, 0);
        grad.setColorAt(0, QColor("#28b80f"));
        grad.setColorAt(1, accent);
        p.setBrush(grad);
        p.drawRoundedRect(barPad, barY, filled, barH, 2, 2);
    }

    // ── Status text below the bar ─────────────────────────────────────────────
    // Changes message as loading progresses so it feels alive
    QString status;
    if (progress < 30)
        status = "Initialising...";
    else if (progress < 60)
        status = "Loading components...";
    else if (progress < 90)
        status = "Almost ready...";
    else
        status = "Welcome!";

    QFont statusFont("Segoe UI", 8);
    p.setFont(statusFont);
    p.setPen(grey);
    QRect statusRect(0, barY + 10, w, 20);
    p.drawText(statusRect, Qt::AlignHCenter | Qt::AlignVCenter, status);

    // ── Version label (bottom-right corner) ──────────────────────────────────
    QFont versionFont("Segoe UI", 7);
    p.setFont(versionFont);
    p.setPen(QColor("#444"));
    p.drawText(r.adjusted(0, 0, -12, -8), Qt::AlignRight | Qt::AlignBottom, "v1.0");
}
