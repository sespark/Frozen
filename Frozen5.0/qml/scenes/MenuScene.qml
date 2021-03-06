import QtQuick 2.0
import VPlay 2.0
import "../common"
import "dialogs"
import "sceneElements"

SceneBase {
    id: menuScene

    signal levelScenePressed
    signal playScenePressed

    property int velocityX: 30

    ParallaxScrollingBackground {
        anchors.centerIn: parent

        movementVelocity: Qt.point(30, 0)
        ratio: Qt.point(1.3, 1.0)
        sourceImage: "../../assets/backgroundImage/arcticskies1.png"
    }

    // header
    Item {
        id: header
        height: 95

        anchors.top: menuScene.gameWindowAnchorItem.top
        anchors.left: menuScene.gameWindowAnchorItem.left
        anchors.right: menuScene.gameWindowAnchorItem.right
        anchors.margins: 5
        Text {
            id: title
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }
            text: qsTr("Frozen")
            font.bold: true
            font.pointSize: header.height * 0.7
            font.pixelSize: 85
            //            color: "#70DBDB"         //蓝绿
            //            color: "#C1CDCD"         //偏白带一点蓝,就很白
            //            color: "#8DB6CD"          //很白
            //            color: "#1E90FF"        //太蓝了，深蓝了
            color: "#87CEFF"
            FontLoader {
                id: loader
                source: "../../assets/fonts/bazaroni.ttf"
            }
            font.family: loader.name
        }

        Column {
            visible: loginScene.login.logining

            id: userInfo
            spacing: 6

            width: 50
            height: header.height

            anchors {
                left: title.right
                leftMargin: 20
                top: header.top
                topMargin: 10
            }

            Text {
                id: userName

                text: loginScene.login.userName
            }

            PlatformerTextButton {
                id: logout
                screenText: "log Out"
                width: 40

                borderWidth: 0
                color: "lightBlue"
                radius: 10

                onClicked: {
                    //                    gameWindow.state = "login"
                    loginScene.login.logining = false
                    loginScene.login.isLogin = false
                    loginScene.login.nameFlag = false
                    loginScene.login.passwdFlag = false
                    loginScene.login.userPassLevelNumber = 0
                    playScene.finishLevelID = 0

                    playScene.resetLevel(-1)
                    readid.userName = ""
                    readid.userPassWord = ""
                    readid.hasUserInfo = false
                }
            }
        }

        PlatformerTextButton {
            id: logout1

            visible: !loginScene.login.logining
            screenText: "Log In"
            width: 37

            borderWidth: 0

            anchors {
                left: title.right
                leftMargin: 20
                top: header.top
                topMargin: 35
            }

            onClicked: {
                gameWindow.state = "login"
                loginScene.login.nameFlag = false
                loginScene.login.passwdFlag = false
            }
            color: "lightBlue"
            radius: 10
        }
    }

    //原来的play按钮
    PlatformerImageButton {
        id: playButton

        image.source: "../../assets/ui/playButton2.png"

        width: 150
        height: 40

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: header.bottom
        anchors.topMargin: 40

        color: "#cce6ff"

        radius: height / 4
        borderColor: "transparent"

        onClicked: {
            playScenePressed()
        }
    }

    PlatformerImageButton {
        id: levelSceneButton

        image.source: "../../assets/ui/levelsButton.png"

        width: 150
        height: 40

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: playButton.bottom
        anchors.topMargin: 30

        color: "#cce6ff"

        radius: height / 4
        borderColor: "transparent"

        onClicked: {
            levelScene.state = "myLevels"
            levelScene.subState = "createdLevels"
            levelScenePressed()
        }
    }

    MultiResolutionImage {
        id: musicButton

        // show music icon
        source: "../../assets/ui/music.png"
        // reduce opacity, if music is disabled
        opacity: settings.musicEnabled ? 0.9 : 0.4

        anchors.top: header.bottom
        anchors.topMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 30

        MouseArea {
            anchors.fill: parent

            onClicked: {
                // switch between enabled and disabled
                if (settings.musicEnabled)
                    settings.musicEnabled = false
                else
                    settings.musicEnabled = true
            }
        }
    }

    MultiResolutionImage {
        id: soundButton

        // show sound_on or sound_off icon, depending on if sound is enabled or not
        source: settings.soundEnabled ? "../../assets/ui/sound_on.png" : "../../assets/ui/sound_off.png"
        // reduce opacity, if sound is disabled
        opacity: settings.soundEnabled ? 0.9 : 0.4

        anchors.top: musicButton.bottom
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 30

        MouseArea {
            anchors.fill: parent

            onClicked: {
                // switch between enabled and disabled
                if (settings.soundEnabled) {
                    settings.soundEnabled = false
                } else {
                    settings.soundEnabled = true

                    // play sound to signal, that sound is now on
                    audioManager.playSound("playerJump")
                }
            }
        }
    }

    Connections {
        target: nativeUtils
        onMessageBoxFinished: {
            if (accepted) {
                nativeUtils.openUrl("https://v-play.net/")
            }
        }
    }

    function resetLevel() {
        var i = "2"
        for (i; i <= "9"; i++) {
            var levelSelectionItem = playScene.levelListRepeater.itemAt(i)
            levelSelectionItem.isPass = false
        }
        //        levelSelectionItem = playScene.levelListRepeater.itemAt("1")
        //        levelSelectionItem.isPass = true
    }
}
