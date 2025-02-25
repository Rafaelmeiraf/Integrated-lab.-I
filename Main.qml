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
    property bool menuOpened: false
    property bool buttonPressed: true


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
                    codePopup.close()
                    code.text = ""
                }
            }

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
                        text: "Desemparelhar"
                        font.pointSize: 11
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        topPadding: 10
                        bottomPadding: 10
                        leftPadding: 10
                        rightPadding: 10
                        onClicked: {menu.close(); codePopup.open();}
                    }
                }
            }

            Rectangle {
                id: bodyMain
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
                                registerUser.close()
                            }
                            else{
                                text3.visible = true
                                text3Timer.start()
                            }
                        }
                    }
                }

                Popup {
                    id: codePopup
                    width: parent.width/2
                    height: parent.height - 100
                    anchors.centerIn: parent
                    background: Rectangle {
                        color: "#f3f6f4"
                        border.color: "#f3f6f4"
                        border.width: 2
                        radius: 5
                    }
                    modal: true
                    closePolicy: Popup.NoAutoClose

                    MouseArea {
                        id: close
                        width: 40
                        height: 40
                        anchors.top: parent.top

                        anchors.right: parent.right

                        onPressed: {codePopup.close(); code.text = "";}

                        Image {
                            source: "images/icon_close.png"
                            anchors.centerIn: parent
                            width: 25
                            height: 25
                            fillMode: Image.PreserveAspectFit
                        }
                    }

                    Text{
                        id: text1Code
                        text: "Desemparelhar o dispositivo"
                        font.pointSize: 15
                        color: "black"
                        anchors.top: parent.top
                        anchors.topMargin: 40
                        anchors.left: parent.left
                        anchors.right: parent.right
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text{
                        id: text2Code
                        text: "Para desemparelhar o dispositivo do veículo atual insira o PIN de desemparelhamento e pressione OK"
                        font.pointSize: 12
                        color: "black"
                        anchors.top: text1Code.bottom
                        anchors.topMargin: 20
                        anchors.left: parent.left
                        anchors.leftMargin: 40
                        anchors.right: parent.right
                        anchors.rightMargin: 40
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }

                    TextField {
                        id: code
                        objectName: "code"
                        placeholderText: "Introduza o PIN"
                        placeholderTextColor: "black"
                        color: "black"
                        font.pointSize: 11
                        anchors.top: text2Code.bottom
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
                        id: text3Code
                        visible: false
                        text: "Insira o PIN de desemparelhamento correto"
                        font.pointSize: 10
                        color: "red"
                        anchors.bottom: confirmeCodeButton.top
                        anchors.bottomMargin: 10
                        anchors.left: parent.left
                        anchors.leftMargin: 75
                        anchors.right: parent.right
                        anchors.rightMargin: 75
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }

                    Timer {
                        id: text3CodeTimer
                        interval: 2000
                        repeat: false
                        onTriggered: text3Code.visible = false
                    }

                    Button {
                        id: confirmeCodeButton
                        objectName: "confirmeCodeButton"
                        text: "OK"
                        font.pointSize: 11
                        font.bold: true
                        anchors.top: code.bottom
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
                            if (code.text === "123456"){
                                codePopup.close()
                            }
                            else{
                                text3Code.visible = true
                                text3CodeTimer.start()
                            }
                        }
                    }
                }
            }
        }
    }
}
