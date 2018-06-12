import QtQuick 2.7
import VPlay 2.0
import Login 1.0

import "./sceneElements"
import "../common"

SceneBase {
    id: login_gui

    property int velocityX: 30
    property double passWordTopMargin: (rect1.height - userName.height - rect1.height * 0.2
                                        - btn_login.height - 8 - passWord.height) / 2.0

    property string loginButtonText: "Login" //登陆按钮text
    property string quitButtonText: "Quit" // 退出以及取消注册按钮text
    property int rect1Height: login_gui.height * 0.4 // 登录矩形框的高度
    property bool passWordAgainVisible: false // 注册界面再次输入密码文本框的可见度
    property bool registerButtonVisible: true // 注册界面注册
    property double lineInputHeightRate: 0.15
    property alias login: login

    SystemPalette {
        id: activePalette
    }

    Login {
        id: login
    }

    ParallaxScrollingBackground {
        anchors.centerIn: parent

        movementVelocity: Qt.point(loginScene.velocityX, 0)
        ratio: Qt.point(1.3, 1.0)
        sourceImage: "../../assets/backgroundImage/arcticskies1.png"
    }

    //顶烂
    Item {
        id: top_bar
        width: login_gui.width
        height: login_gui.height * 0.2
        anchors.top: login_gui.top

        Text {
            id: title
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }
            text: qsTr("Frozen")
            font.bold: true
            font.pointSize: login_gui.height * 0.1
            font.pixelSize: top_bar.height
            color: "#E6E6FA"
            FontLoader {
                id: loader
                source: "../../assets/fonts/bazaroni.ttf"
            }
            font.family: loader.name
        }

        PlatformerImageButton {
            id: menuButton

            image.source: "../../assets/ui/home.png"

            width: 40
            height: 30

            anchors.top: parent.gameWindowAnchorItem
            anchors.topMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 5

            // go back to MenuScene
            onClicked: {
                gameWindow.state = "menu"

                loginScene.login.nameFlag = false
                loginScene.login.passwdFlag = false
            }
        }
    }

    //空白栏
    Item {
        id: space1
        width: login_gui.width
        height: login_gui.height * 0.1
        anchors.top: top_bar.bottom
        Text {
            id: title1
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }
            text: qsTr("Login")
            font.bold: true
            font.pointSize: login_gui.height * 0.1
            font.pixelSize: space1.height * 0.5
            color: "#F0F8FF"
        }
    }

    //登陆框
    Rectangle {
        id: rect1
        width: login_gui.width * 0.3
        height: rect1Height
        anchors {
            top: space1.bottom
            horizontalCenter: parent.horizontalCenter
        }
        border.color: "#FFFAFA"
        color: "transparent"

        LineInput {
            id: userName
            width: rect1.width * 0.8
            height: rect1.height * lineInputHeightRate
            font_size: height * 0.3
            anchors {
                horizontalCenter: rect1.horizontalCenter
                top: rect1.top
                topMargin: rect1.height * 0.1
            }
            hintText: "请输入用户号"
            maxLength: 12
            onEdittingFinished: {
                // 输入结束时，查找输入的用户名
                if (userName.inputText != "") {
                    login.getUserInfo(userName.inputText)
                }
            }
        }

        LineInput {
            id: passWord
            width: rect1.width * 0.8
            height: rect1.height * lineInputHeightRate
            font_size: height * 0.2
            anchors {
                horizontalCenter: rect1.horizontalCenter
                top: userName.bottom
                topMargin: passWordTopMargin
            }
            hintText: "请输入密码"
            echoMode: TextInput.Password
            maxLength: 6
            validator: RegExpValidator {
                regExp: /[0-9]{0,6}/
            }
        }

        LineInput {
            id: passWordAgain
            width: rect1.width * 0.8
            height: rect1.height * lineInputHeightRate
            font_size: height * 0.2
            anchors {
                horizontalCenter: rect1.horizontalCenter
                bottom: btn_login.top
                bottomMargin: rect1.height * 0.1
            }
            hintText: "请再次输入密码"
            echoMode: TextInput.Password
            maxLength: 6
            validator: RegExpValidator {
                regExp: /[0-9]{0,6}/
            }

            visible: passWordAgainVisible
        }

        LogButton {
            id: btn_login
            width: rect1.width * 0.25
            height: rect1.height * 0.2
            anchors {
                left: rect1.left
                leftMargin: rect1.width * 0.1
                bottom: rect1.bottom
                bottomMargin: 8
            }
            text: loginButtonText
            onClicked: {
                if (registerButtonVisible && userName.inputText != "") {
                    login.getUserInfo(userName.inputText)
                    login.login_clicked(passWord.inputText)
                    if (login.isLogin) {
                        gameWindow.state = "menu"

                        readid.userName = login.userName
                        readid.userPassWord = login.userPassword

                        playScene.finishLevelID = login.userPassLevelNumber
                        console.debug(
                                    "logButton:===============================playScene.finishLevelID: " + playScene.finishLevelID)
                        playScene.resetLevel(login.userPassLevelNumber)
                    }

                    // 设置输入信息错误/正确的不同颜色
                    if (login.nameFlag) {
                        setUserNameColor(true)
                    } else if (!login.nameFlag)
                        setUserNameColor(false)
                    if (login.passwdFlag)
                        setPassWordColor(true)
                    else
                        setPassWordColor(false)
                } else if (!registerButtonVisible && userName.inputText != "") {
                    login.okBtn_clicked(passWord.inputText,
                                        passWordAgain.inputText,
                                        userName.inputText)

                    // 设置输入信息错误/正确的不同颜色
                    if (login.nameFlag)
                        setUserNameColor(false)
                    else if (!login.nameFlag)
                        setUserNameColor(true)
                    if (login.passwdFlag) {
                        setPassWordColor(true)
                        setPassWordAgainColor(true)
                    } else {
                        setPassWordColor(false)
                        setPassWordAgainColor(false)
                    }

                    //注册成功，返回登录界面
                    if (login.registerSuccess)
                        loginBack()
                }
            }
        }

        LogButton {
            id: btn_register
            width: rect1.width * 0.25
            height: rect1.height * 0.2
            anchors {
                left: btn_login.right
                leftMargin: (rect1.width - (btn_login.width + btn_quit.width
                                            + (rect1.width * 0.1 * 2) + btn_register.width)) / 2.0
                bottom: rect1.bottom
                bottomMargin: 8
            }
            text: "Register"
            visible: registerButtonVisible
            onClicked: {
                resetTextColor()
                register()
                login.receivedb()
            }
        }

        LogButton {
            id: btn_quit
            width: rect1.width * 0.25
            height: rect1.height * 0.2
            anchors {
                right: rect1.right
                rightMargin: rect1.width * 0.1
                bottom: rect1.bottom
                bottomMargin: 8
            }
            text: quitButtonText
            onClicked: {
                if (!passWordAgain.visible)
                    Qt.quit()
                else {
                    loginBack()
                    resetTextColor()
                }
            }
        }
    }

    function register() {

        rect1Height = login_gui.height * 0.5

        registerButtonVisible = false

        passWordAgainVisible = true
        passWordTopMargin = (rect1Height - (rect1Height * lineInputHeightRate * 3
                                            + (rect1Height * 0.2) + btn_login.height + 8)) / 2.0

        loginButtonText = "OK"
        quitButtonText = "Cancel"

        //wen ben kuang neirong qing kong
        userName.input.clear()
        passWord.input.clear()
        passWordAgain.input.clear()

        lineInputHeightRate = 0.15
    }

    function loginBack() {

        rect1Height = login_gui.height * 0.4

        registerButtonVisible = true

        passWordAgainVisible = false
        passWordTopMargin = (rect1.height - userName.height - rect1.height * 0.2
                             - btn_login.height - 8 - passWord.height) / 2.0

        loginButtonText = "Login"
        quitButtonText = "Quit"

        //wen ben kuang neirong qing kong
        userName.input.clear()
        passWord.input.clear()
        passWordAgain.input.clear()

        lineInputHeightRate = 0.15
    }

    function addPassLevelNumber() {}
    function resetTextColor() {
        userName.input.color = "black"
        passWord.input.color = "black"
        passWordAgain.input.color = "black"

        userName.hint.color = "#707070"
        passWord.hint.color = "#707070"
        passWordAgain.hint.color = "#707070"
    }

    function setUserNameColor(nameFlag) {
        if (nameFlag) {
            userName.input.color = "black"
            userName.hint.color = "#707070"
        } else if (!nameFlag) {
            userName.input.color = "red"
            userName.hint.color = "red"
        }
    }
    function setPassWordColor(passFlag) {
        if (passFlag) {
            passWord.input.color = "black"
            passWord.hint.color = "#707070"
        } else if (!passFlag) {

            passWord.input.color = "red"
            passWord.hint.color = "red"
        }
    }
    function setPassWordAgainColor(passFlag) {
        if (passFlag) {
            passWordAgain.input.color = "black"
            passWordAgain.hint.color = "#707070"
        } else if (!passFlag) {

            passWordAgain.input.color = "red"
            passWordAgain.hint.color = "red"
        }
    }
}
