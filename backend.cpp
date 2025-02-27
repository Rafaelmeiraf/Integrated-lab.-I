#include "backend.h"

Backend::Backend(QSettings *settings, QQmlApplicationEngine *engine, QObject *parent)
    : QObject{parent}, m_stateScreen{false}, m_settings{settings}, m_stateDay{true}
{

    //######################################################
    //################## Iniciar timers ####################
    //######################################################

    m_timerLauncher = new QTimer(this);
    connect(m_timerLauncher, SIGNAL(timeout()), this, SLOT(timeoutTimerLauncher()));
    m_timerLauncher->setInterval(500);

    m_timerReconnect = new QTimer(this);
    m_timerReconnect->setInterval(1000);
    connect(m_timerReconnect, SIGNAL(timeout()), this, SLOT(timeoutTimerReconnect()));

    //######################################################
    //############## Configurar QSerialPort ################
    //######################################################

    m_serial = new QSerialPort(this);
    m_serial->setPortName("COM7"); //ttyACM0 linux
    m_serial->setBaudRate(9600);
    m_serial->setDataBits(QSerialPort::Data8);
    m_serial->setParity(QSerialPort::NoParity);
    m_serial->setStopBits(QSerialPort::TwoStop);
    m_serial->setFlowControl(QSerialPort::NoFlowControl);

    if (m_serial->open(QIODevice::ReadWrite)) {
        qDebug() << "STM Connected - SUCCESS";
        connect(m_serial, SIGNAL(readyRead()), this, SLOT(readDataSTM()));
    }
    else {
        qDebug() << "STM Connected - FAIL. Trying again soon...";
        m_timerReconnect->start();
    }

    connect(m_serial, &QSerialPort::errorOccurred, this, &Backend::reconnectSTM);

    //######################################################
    //######## Configurar comunicações com exterior ########
    //######################################################
/*
    QString path = QCoreApplication::applicationDirPath();

    QString buildFolder = "build";
    int index = path.indexOf(buildFolder);

    if (index != -1) {
        path = path.left(index - 1);
    }

    QString program = path + "/server.exe";
    qDebug() << program;
    QStringList arguments;

    m_process = new QProcess(parent);
    m_process->start(program, arguments);
*/
    m_socket = new QTcpSocket( this );
    connect(m_socket, SIGNAL(readyRead()), this, SLOT(readDataSocket()) );

    m_socket->connectToHost("localhost", 12345);
    if( m_socket->waitForConnected() ) {
       qDebug() << "Server Connected - SUCCESS";
    }

    //######################################################
    //########### Criar referências para o QML #############
    //######################################################

    m_initWindow = engine->rootObjects().at(0)->findChild<QObject*>("initWindow");
    m_launcherWindow = engine->rootObjects().at(0)->findChild<QObject*>("launcherWindow");
    m_registerWindow = engine->rootObjects().at(0)->findChild<QObject*>("registerWindow");
    m_mainWindow = engine->rootObjects().at(0)->findChild<QObject*>("mainWindow");

    m_text_field_plate = engine->rootObjects().at(0)->findChild<QObject*>("plate");
    m_text_field_boss = engine->rootObjects().at(0)->findChild<QObject*>("boss");
    m_text_field_user = engine->rootObjects().at(0)->findChild<QObject*>("user");

    m_button_register = engine->rootObjects().at(0)->findChild<QObject*>("registerButton");
    m_button_register_user = engine->rootObjects().at(0)->findChild<QObject*>("registerUserButton");
    m_button_desemparelhar = engine->rootObjects().at(0)->findChild<QObject*>("desemparelharButton");
    m_button_emergency = engine->rootObjects().at(0)->findChild<QObject*>("emergencyButton");

    connect(m_button_register, SIGNAL(clicked()), this, SLOT(readDataRegisterQML()));
    connect(m_button_register_user, SIGNAL(clicked()), this, SLOT(readDataUserQML()));
    connect(m_button_desemparelhar, SIGNAL(clicked()), this, SLOT(desemparelhar()));
    connect(m_button_emergency, SIGNAL(clicked()), this, SLOT(emergency()));

    //######################################################
    //############# Iniciar outras variáveis ###############
    //######################################################

    if (settings->value("register", "false").toString() == "true"){
        m_stateRegister = true;
    }
    else{
        m_stateRegister = false;
    }

    m_plate = settings->value("plate", "vazio").toString();
    m_boss = settings->value("boss", "vazio").toString();
    m_user = "123456";
    m_info = "";
    qDebug() << settings->value("plate", "plate -> nao atribuido").toString();
    qDebug() << settings->value("boss", "boss -> nao atribuido").toString();
    qDebug() << settings->value("register", "register -> nao atribuido").toString();
    QString info ="000 "  + m_plate  + " " + m_boss + "\n";
    m_socket->write(info.toUtf8());
}


void Backend::readDataSTM() {
    if( m_serial->canReadLine() )
    {
        QByteArray data = m_serial->readLine();
        QString message = data.trimmed();
        qDebug() << "data: " << message;

        if (message == "button_pressed") {
            if(m_stateScreen){
                m_timerLauncher->stop();
                m_stateScreen = false;
                m_initWindow->setProperty("color", "black");
                m_launcherWindow->setProperty("visible", false);
                m_registerWindow->setProperty("visible", false);
                m_mainWindow->setProperty("visible", false);
                m_text_field_plate->setProperty("text", "");
                m_text_field_boss->setProperty("text", "");
                m_text_field_user->setProperty("text", "");

                if (m_user != "123456"){

                    //ENVIAR PARA PYTHON PARA TERMINAR VIAGEM
                    m_info = "004 " + m_user + "\n";
                    m_socket->write(m_info.toUtf8());


                    int index = QRandomGenerator::global()->bounded(16);
                    qDebug() << "Index:" << index;

                    if(index >= 0 && index <= 8){
                        m_info = "buzzer\n";
                        m_serial->write(m_info.toUtf8());

                        //ENVIAR PARA PYTHON PARA SINALIZAR OBJETO ESQUECIDO
                        m_info = "002 " + QString::number(index) + "\n";
                        m_socket->write(m_info.toUtf8());
                    }
                }
            }
            else{
                m_stateScreen = true;
                m_launcherWindow->setProperty("visible", true);
                m_timerLauncher->start();
                if(m_stateDay){
                    m_initWindow->setProperty("color", "#bcdde1");
                }
                else{
                    m_initWindow->setProperty("color", "#337ca4");
                }
            }
        }
        else if ((message == "night") && m_stateScreen){
            m_initWindow->setProperty("color", "#337ca4");
        }
        else if (message == "day" && m_stateScreen){
            m_initWindow->setProperty("color", "#bcdde1");
        }

        if ((message == "night")){
            m_stateDay = false;
        }
        else if (message == "day"){
            m_stateDay = true;
        }
        else if (message == "break_window"){
            qDebug() << "Janela partida";

            //ENVIAR PARA PYTHON PARA SINALIZAR VIDRO PARTIDO
            m_info = "003 .\n";
            m_socket->write(m_info.toUtf8());
        }
    }
}


void Backend::readDataRegisterQML(){
    QString plate = m_text_field_plate->property("text").toString();
    QString boss = m_text_field_boss->property("text").toString();

    qDebug() << "Plate:" << plate;
    qDebug() << "Boss:" << boss;

    if (plate != "" && boss != ""){
        m_text_field_plate->setProperty("text", "");
        m_text_field_boss->setProperty("text", "");

        m_settings->setValue("plate", plate);
        m_settings->setValue("boss", boss);
        m_settings->setValue("register", "true");

        // ENVIAR PARA PYTHON PARA CRIAR CHAT
        m_info = "000 " + plate + " " + boss + "\n";
        qDebug() << m_info;
        m_socket->write(m_info.toUtf8());

        m_stateRegister = true;

        if(m_stateScreen){
            m_registerWindow->setProperty("visible", false);
            m_mainWindow->setProperty("visible", true);
        }
    }
}


void Backend::readDataUserQML(){
    m_user = m_text_field_user->property("text").toString();
    m_text_field_user->setProperty("text", "");
    if(m_user != "123456"){

        //ENVIAR USER PARA PYTHON PARA INICIAR VIAGEM
        m_info = "004 " + m_user + "\n";
        m_socket->write(m_info.toUtf8());
    }
    qDebug() << "User:" << m_user;
}


void Backend::readDataSocket(){
    if(m_socket->canReadLine()){
        QByteArray data = m_socket->readLine();
        QString message = data.trimmed();
        qDebug() << "data Server: " << message;
    }
}


void Backend::timeoutTimerLauncher(){
    if(m_stateRegister){
        m_timerLauncher->stop();      
        m_launcherWindow->setProperty("visible", false);
        m_registerWindow->setProperty("visible", false);
        m_mainWindow->setProperty("visible", true);
    }
    else{
        m_timerLauncher->stop();
        m_launcherWindow->setProperty("visible", false);
        m_mainWindow->setProperty("visible", false);
        m_registerWindow->setProperty("visible", true);  
    }
}


void Backend::timeoutTimerReconnect(){
    if (m_serial->isOpen()) {
        m_timerReconnect->stop();
        return;
    }

    if (m_serial->open(QIODevice::ReadWrite)) {
        m_timerReconnect->stop();
        qDebug() << "STM Connected - SUCCESS";
        connect(m_serial, SIGNAL(readyRead()), this, SLOT(readDataSTM()));
    }
    else {
        qDebug() << "STM Connected - FAIL. Trying again soon...";
    }
}


void Backend::reconnectSTM(QSerialPort::SerialPortError error){
    if (error == QSerialPort::ResourceError || error == QSerialPort::DeviceNotFoundError) {
        qDebug() << "Erro detectado: " << m_serial->errorString();

        if (m_serial->isOpen()) {
            m_serial->close();
        }

        if (!m_timerReconnect->isActive()) {
            m_timerReconnect->start();
        }
    }
}


void Backend::desemparelhar(){
    if(m_user == "123456"){
        qDebug() << "DESEMPARELHADO";
        m_settings->setValue("plate", "vazio");
        m_settings->setValue("boss", "vazio");
        m_settings->setValue("register", "false");

        m_stateRegister = false;

        if(m_stateScreen){
            m_registerWindow->setProperty("visible", true);
            m_mainWindow->setProperty("visible", false);
        }
    }
}


void Backend::emergency(){
    qDebug() << "EMERGÊNCIA";
    // ENVIAR PARA PYTHON SINALIZAR EMERGÊNCIA
    m_info = "005 .\n";
    m_socket->write(m_info.toUtf8());
}
