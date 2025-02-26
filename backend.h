#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QSerialPort>
#include <QTimer>
#include <QSettings>
#include <QTcpSocket>
#include <QProcess>
#include <QCoreApplication>
#include <QRandomGenerator>

class Backend : public QObject
{
    Q_OBJECT
public:
    explicit Backend(QSettings *settings, QQmlApplicationEngine *engine = nullptr, QObject *parent = nullptr);

signals:

private slots:
    void readDataSTM();
    void readDataRegisterQML();
    void readDataUserQML();
    void readDataSocket();

    void timeoutTimerLauncher();
    void timeoutTimerReconnect();

    void desemparelhar();
    void emergency();
    void reconnectSTM(QSerialPort::SerialPortError error);

private:
    QSerialPort *m_serial;
    QObject *m_initWindow;
    QObject *m_launcherWindow;
    QObject *m_registerWindow;
    QObject *m_mainWindow;
    bool m_stateScreen;
    bool m_stateRegister;
    bool m_stateDay;
    QTimer *m_timerLauncher;
    QTimer *m_timerReconnect;
    QSettings *m_settings;
    QObject *m_text_field_plate;
    QObject *m_text_field_boss;
    QObject *m_text_field_user;
    QObject *m_button_register;
    QObject *m_button_register_user;
    QObject *m_button_desemparelhar;
    QObject *m_button_emergency;
    QString m_plate;
    QString m_boss;
    QString m_user;
    QString m_info;
    QTcpSocket *m_socket;
    QProcess *m_process;

    void cleanBuffer();
};

#endif // BACKEND_H
