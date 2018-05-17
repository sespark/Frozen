import QtQuick 2.7
import "./sceneElements"
import VPlay 2.0
import Login 1.0

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

    //    property string userName
    //    property string userPW
    //    property int userPassLevelNumber: 0
    SystemPalette {
        id: activePalette
    }

    Login {
        id: login
    }

    //    SpriteSequenceVPlay {
    //        width: 42
    //        height: 40

    //        //        anchors {
    //        //            top: parent.top
    //        //            left: parent.left
    //        //            topMargin: parent.height * 0.5
    //        //            leftMargin: parent.width * 0.2
    //        //        }
    //        x: 100
    //        y: 100

    //        SpriteVPlay {
    //            name: "1"
    //            frameCount: 3
    //            frameHeight: 40
    //            frameWidth: 42
    //            frameRate: 10
    //            startFrameColumn: 1
    //            source: "../../assets/opponent/creatures/haywire/left-0.png"
    //            to: {
    //                2: 1
    //            }
    //        }

    //        SpriteVPlay {
    //            name: "2"
    //            frameCount: 3
    //            frameHeight: 40
    //            frameWidth: 42
    //            frameRate: 10
    //            startFrameColumn: 1
    //            source: "../../assets/opponent/creatures/haywire/left-1.png"
    //            to: {
    //                3: 1
    //            }
    //        }

    //        SpriteVPlay {
    //            name: "3"
    //            frameCount: 3
    //            frameHeight: 40
    //            frameWidth: 42
    //            frameRate: 10
    //            startFrameColumn: 1
    //            source: "../../assets/opponent/creatures/haywire/left-2.png"
    //        }
    //    }
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
                topMargin: space1.height
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
                if (userName.inputText != "")
                    login.getUserInfo(userName.inputText)
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
                if (btn_register.visible && userName.inputText != "") {
                    //                    gameWindow.state = "menu"
                    login.login_clicked(passWord.inputText)
                    if (login.isLogin)
                        gameWindow.state = "menu"
                } else {
                    login.okBtn_clicked(passWord.inputText,
                                        passWordAgain.inputText,
                                        userName.inputText)
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
                else
                    loginBack()
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
}
