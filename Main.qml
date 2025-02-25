import QtQuick
import QtQuick.Controls
import QtQuick.Window

// #bcdde1 -> claro
// #337ca4 -> escuro
ApplicationWindow {
    id: app
    visible: true
    width: 800
    height: 480
    title: "CarShare App"

    property string myUser: ""


    Rectangle {
        id: initWindow
        objectName: "initWindow"
        width: parent.width
        height: parent.height
        color: "black"


        //##################################################################################
        //############################## Launcher Screen ###################################
        //##################################################################################
        Item {
            id: launcherWindow
            objectName: "launcherWindow"
            visible: false
            anchors.fill: parent


            Rectangle {
                width: initWindow.width
                height: initWindow.height
                x: 0
                y: 0
                color: initWindow.color

                Image {
                    source: "images/icon_inicial.png"
                    anchors.centerIn: parent
                    width: 200
                    height: 120
                    fillMode: Image.PreserveAspectFit
                }
            }
        }


        //##################################################################################
        //############################## Register Screen ###################################
        //##################################################################################
        Item {
            id: registerWindow
            objectName: "registerWindow"
            visible: false
            anchors.fill: parent

            // FRISO
            Rectangle{
                x: 0
                y: 0
                width: initWindow.width
                height: 40
                color: initWindow.color

                Text{
                    id: clockTextRegister
                    anchors.centerIn: parent
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 20
                    color: "black"
                    text: Qt.formatTime(new Date(), "hh:mm")
                }

                Timer {
                    id: timerRegister
                    interval: 60000 // Atualiza a cada minuto
                    repeat: true
                    running: true
                    onTriggered: clockTextRegister.text = Qt.formatTime(new Date(), "hh:mm")
                }

                Text{
                    id: nameRegister
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 20
                    color: "black"
                    text: "CarShare"
                }
            }

            // RESTO DA JANELA
            Rectangle {
                id: bodyRegister
                x: 0
                y: 40
                width: initWindow.width
                height: initWindow.height - 40
                color: initWindow.color

                Rectangle{
                    x: 0
                    y: 0
                    width: initWindow.width
                    height: 2
                    color: "white"
                }

                Image {
                    id: configImage
                    source: "images/icon_inicial.png"
                    anchors.top: bodyRegister.top
                    anchors.topMargin: 20
                    anchors.horizontalCenter: bodyRegister.horizontalCenter
                    width: 150
                    height: 100
                    fillMode: Image.PreserveAspectFit
                }

                Text{
                    id: configText
                    anchors.top: configImage.bottom
                    anchors.topMargin: 10
                    anchors.horizontalCenter: bodyRegister.horizontalCenter
                    font.pixelSize: 20
                    font.bold: true
                    color: "black"
                    text: "Emparelhar o veículo"
                }

                TextField {
                    id: plate
                    objectName: "plate"
                    placeholderText: "Introduza a matrícula do automóvel"
                    placeholderTextColor: "black"
                    color: "black"
                    font.pointSize: 11
                    anchors.top: configText.bottom
                    anchors.topMargin: 50
                    anchors.left: bodyRegister.left
                    anchors.leftMargin: 200
                    anchors.right: bodyRegister.right
                    anchors.rightMargin: 200
                    topPadding: 10
                    bottomPadding: 10
                    leftPadding: 10
                    rightPadding: 10
                }

                TextField {
                    id: boss
                    objectName: "boss"
                    placeholderText: "Introduza o seu e-mail ou nº de telemóvel"
                    placeholderTextColor: "black"
                    color: "black"
                    font.pointSize: 11
                    anchors.top: plate.bottom
                    anchors.topMargin: 20
                    anchors.left: bodyRegister.left
                    anchors.leftMargin: 200
                    anchors.right: bodyRegister.right
                    anchors.rightMargin: 200
                    topPadding: 10
                    bottomPadding: 10
                    leftPadding: 10
                    rightPadding: 10
                }

                Text {
                    id: textEmparelhar
                    visible: false
                    text: "Preencha os dois campos para emparelhar o dispositivo ao seu veículo"
                    font.pointSize: 10
                    color: "red"
                    anchors.bottom: registerButton.top
                    anchors.bottomMargin: 20
                    anchors.left: parent.left
                    anchors.leftMargin: 75
                    anchors.right: parent.right
                    anchors.rightMargin: 75
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                }

                Timer {
                    id: textEmparelharTimer
                    interval: 2000
                    repeat: false
                    onTriggered: textEmparelhar.visible = false
                }

                Button {
                    id: registerButton
                    objectName: "registerButton"
                    text: "Emparelhar"
                    font.pointSize: 11
                    font.bold: true
                    anchors.top: boss.bottom
                    anchors.topMargin: 50
                    anchors.left: bodyRegister.left
                    anchors.leftMargin: 300
                    anchors.right: bodyRegister.right
                    anchors.rightMargin: 300
                    topPadding: 10
                    bottomPadding: 10
                    leftPadding: 10
                    rightPadding: 10
                    onClicked: {
                        if ((plate.text === "") || (boss.text === "")){
                            textEmparelhar.visible = true
                            textEmparelharTimer.start()
                        }
                    }
                }
            }
        }

        //##################################################################################
        //################################ Main Screen #####################################
        //##################################################################################
        Item {
            id: mainWindow
            objectName: "mainWindow"
            visible: false
            anchors.fill: parent
            onVisibleChanged: {
                if (mainWindow.visible){
                    registerUser.open()
                }
                else{
                    registerUser.close()
                    menu.close()
                    bodyMain.visible = false
                    bodyBoss.visible = false
                }
            }

            // FRISO
            Rectangle{
                x: 0
                y: 0
                width: initWindow.width
                height: 40
                color: initWindow.color

                Text{
                    id: clockTextMain
                    anchors.centerIn: parent
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 20
                    color: "black"
                    text: Qt.formatTime(new Date(), "hh:mm")
                }

                Timer {
                    id: timerMain
                    interval: 60000 // Atualiza a cada minuto
                    repeat: true
                    running: true
                    onTriggered: clockTextMain.text = Qt.formatTime(new Date(), "hh:mm")
                }

                Text{
                    id: nameMain
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 20
                    color: "black"
                    text: "CarShare"
                }

                MouseArea {
                    id: configs
                    width: 40
                    height: 40
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    onPressed: menu.open()

                    Image {
                        source: "images/icon_settings.png"
                        anchors.centerIn: parent
                        width: 25
                        height: 25
                        fillMode: Image.PreserveAspectFit
                    }
                }

                Popup {
                    id: menu
                    x: initWindow.width - width
                    y: 40
                    width: 150
                    height: 52
                    background: Rectangle {
                        color: "white"
                        border.color: "white"
                        border.width: 2
                        radius: 5
                    }

                    Button {
                        id: desemparelharButton
                        objectName: "desemparelharButton"
                        text: "Desemparelhar"
                        font.pointSize: 11
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        topPadding: 10
                        bottomPadding: 10
                        leftPadding: 10
                        rightPadding: 10
                        onClicked: {
                            menu.close()
                            if(app.myUser != "123456"){
                                textAviso.visible = true
                                timerAviso.start()
                            }
                        }
                    }
                }
            }

            // RESTO DA JANELA
            Rectangle {
                x: 0
                y: 40
                width: initWindow.width
                height: initWindow.height - 40
                color: initWindow.color

                // LINHA A BRANCO
                Rectangle{
                    x: 0
                    y: 0
                    width: initWindow.width
                    height: 2
                    color: "white"
                }

                // JANELA SE INICAR COM O BOSS PARA DESEMPARELHAR
                Rectangle {
                    id: bodyBoss
                    x: 0
                    y: 2
                    width: parent.width
                    height: parent.height
                    color: parent.color
                    visible: false

                    Text{
                        text: "ADMINISTRADOR"
                        font.pointSize: 30
                        color: "black"
                        anchors.top: parent.top
                        anchors.topMargin: 170
                        anchors.left: parent.left
                        anchors.right: parent.right
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                // JANELA APOS INICIO DE VIAGEM
                Rectangle {
                    id: bodyMain
                    x: 0
                    y: 2
                    width: parent.width
                    height: parent.height
                    color: parent.color
                    visible: false
                    onVisibleChanged: {
                        if (bodyMain.visible){
                            timerTrip.start()
                        }
                        else{
                            timerTrip.stop()
                            timeSeconds = 0
                            textAviso.visible = false
                        }
                    }

                    property int timeSeconds: 0

                    function formatTime(seconds) {
                        let hours = Math.floor(seconds / 3600);
                        let minutes = Math.floor((seconds % 3600) / 60);
                        let secs = seconds % 60;
                        return (hours < 10 ? "0" : "") + hours + ":" +
                               (minutes < 10 ? "0" : "") + minutes + ":" +
                               (secs < 10 ? "0" : "") + secs;
                    }

                    Timer {
                        id: timerTrip
                        interval: 1000
                        running: false
                        repeat: true
                        onTriggered: bodyMain.timeSeconds += 1
                    }

                    Timer {
                        id: timerAviso
                        interval: 2000
                        running: false
                        repeat: false
                        onTriggered: textAviso.visible = false
                    }

                    Text{
                        id: textAviso
                        visible: false
                        text: "Não tem permissão para desemparelhar o dispositivo"
                        font.pointSize: 13
                        color: "#b62e2e"
                        anchors.top: parent.top
                        anchors.topMargin: 10
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        anchors.right: parent.right
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text{
                        id: textBody1
                        text: "Aproveite a viagem com o CarShare!"
                        font.pointSize: 18
                        color: "black"
                        anchors.top: textAviso.bottom
                        anchors.topMargin: 20
                        anchors.left: parent.left
                        anchors.right: parent.right
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text{
                        id: textBody2
                        text: "Conduza com segurança!"
                        font.pointSize: 16
                        color: "black"
                        anchors.top: textBody1.bottom
                        anchors.topMargin: 20
                        anchors.left: parent.left
                        anchors.right: parent.right
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text{
                        id: textBody3
                        text: "Tempo de viagem: "
                        font.pointSize: 20
                        color: "black"
                        anchors.top: textBody2.bottom
                        anchors.topMargin: 50
                        anchors.left: parent.left
                        anchors.leftMargin: 210
                    }

                    Text {
                        id: textBody4
                        text: bodyMain.formatTime(bodyMain.timeSeconds)
                        font.pointSize: 20
                        font.bold: true
                        anchors.top: textBody3.top
                        anchors.left: textBody3.right
                        anchors.leftMargin: 20
                    }

                    Text{
                        id: textBody5
                        text: "Custo da viagem: "
                        font.pointSize: 20
                        color: "black"
                        anchors.top: textBody3.bottom
                        anchors.topMargin: 30
                        anchors.left: parent.left
                        anchors.leftMargin: 210
                    }

                    Text {
                        id: textBody6
                        text: (bodyMain.timeSeconds * 0.01).toFixed(2) + " \u20AC"
                        font.pointSize: 20
                        font.bold: true
                        anchors.top: textBody5.top
                        anchors.left: textBody5.right
                        anchors.leftMargin: 20
                    }

                    Button {
                        id: emergencyButton
                        objectName: "emergencyButton"
                        text: "Emergência"
                        font.pointSize: 15
                        font.bold: true
                        anchors.top: textBody6.bottom
                        anchors.topMargin: 60
                        anchors.left: parent.left
                        anchors.leftMargin: 250
                        anchors.right: parent.right
                        anchors.rightMargin: 250
                        topPadding: 10
                        bottomPadding: 10
                        leftPadding: 10
                        rightPadding: 10
                    }
                }

                // JANELA DE INICIO DE VIAGEM
                Popup {
                    id: registerUser
                    width: parent.width/2
                    height: parent.height - 150
                    anchors.centerIn: parent
                    background: Rectangle {
                        color: "#f3f6f4"
                        border.color: "#f3f6f4"
                        border.width: 2
                        radius: 5
                    }
                    modal: true
                    closePolicy: Popup.NoAutoClose

                    Text{
                        id: text1
                        text: "Viaje com a CarShare"
                        font.pointSize: 15
                        color: "black"
                        anchors.top: parent.top
                        anchors.topMargin: 10
                        anchors.left: parent.left
                        anchors.right: parent.right
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text{
                        id: text2
                        text: "Para iniciar a sua viagem introduza o seu número de telemóvel e pressione OK"
                        font.pointSize: 12
                        color: "black"
                        anchors.top: text1.bottom
                        anchors.topMargin: 20
                        anchors.left: parent.left
                        anchors.leftMargin: 30
                        anchors.right: parent.right
                        anchors.rightMargin: 30
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }

                    TextField {
                        id: user
                        objectName: "user"
                        placeholderText: "Introduza o seu nº de telemóvel"
                        placeholderTextColor: "black"
                        color: "black"
                        font.pointSize: 11
                        anchors.top: text2.bottom
                        anchors.topMargin: 30
                        anchors.left: parent.left
                        anchors.leftMargin: 75
                        anchors.right: parent.right
                        anchors.rightMargin: 75
                        topPadding: 10
                        bottomPadding: 10
                        leftPadding: 10
                        rightPadding: 10
                    }

                    Text {
                        id: text3
                        visible: false
                        text: "Insira o seu nº de telemóvel para iniciar a viagem"
                        font.pointSize: 10
                        color: "red"
                        anchors.bottom: registerUserButton.top
                        anchors.bottomMargin: 10
                        anchors.left: parent.left
                        anchors.leftMargin: 75
                        anchors.right: parent.right
                        anchors.rightMargin: 75
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }

                    Timer {
                        id: text3Timer
                        interval: 2000
                        repeat: false
                        onTriggered: text3.visible = false
                    }

                    Button {
                        id: registerUserButton
                        objectName: "registerUserButton"
                        text: "OK"
                        font.pointSize: 11
                        font.bold: true
                        anchors.top: user.bottom
                        anchors.topMargin: 50
                        anchors.left: parent.left
                        anchors.leftMargin: 150
                        anchors.right: parent.right
                        anchors.rightMargin: 150
                        topPadding: 10
                        bottomPadding: 10
                        leftPadding: 10
                        rightPadding: 10
                        onClicked: {
                            if (((user.text !== "") && (user.text.length >= 9)) || (user.text === "123456")){
                                app.myUser = user.text
                                registerUser.close()
                                if (app.myUser != "123456"){
                                    bodyMain.visible = true
                                }
                                else if(app.myUser == "123456"){
                                    bodyBoss.visible = true
                                }
                            }
                            else{
                                text3.visible = true
                                text3Timer.start()
                            }
                        }
                    }
                }
            }
        }
    }
}
