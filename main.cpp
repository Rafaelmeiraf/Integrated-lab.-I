#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSettings>
#include "backend.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("TP_Lab_Integrados", "Main");

    QSettings settings("IPCA", "CarShareApp");

    Backend run = Backend(&settings, &engine, 0);

    return app.exec();
}
