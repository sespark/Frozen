import QtQuick 2.0
import VPlay 2.0
import "../../common"

Item {
    id: playLevelSelectionItem

    //    property bool beforeIsPass: false
    //    property int finishLevelNumber: 0
    //    property bool isPass: playLevelGrid.finishLevelID >= modelData.levelName - 1 ? true : false
    property bool isPass: true
    property alias levelName: levelName

    signal finish

    width: 70
    height: 70

    PlatformerImageButton {
        id: level
        width: parent.width
        height: parent.height
        radius: 15
        //        color: "#6CA6CD"
        //  color: "#8DB6CD"           //手机上有点偏灰色
        //color: "#00BFFF"         //太蓝了不合适
        //color: "#1E90FF"
        //color: "#AEEEEE"             //手机上有点灰暗
        //       color: "lightBlue"
        //        color: "#63B8FF" //嗯....说不出的感觉  有点好看？

        //        image.source:  "../../../assets/img/text-dialog-background.png"
        borderColor: "transparent"

        anchors {
            top: parent.top
            bottom: parent.bottom
        }

        //        image.source: playLevelSelectionItem.isPass ? "" : "../../../assets/ui/document-encrypted.svg"
        Image {
            id: lock_img
            source: playLevelSelectionItem.isPass ? "" : "../../../assets/img/level-base-locked.png"
            anchors.centerIn: parent
        }

        opacity: playLevelSelectionItem.isPass ? 0.4 : 0.2

        Text {
            id: levelName
            text: modelData.levelName

            height: 16
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            //            color: "white"

            //            color: "black"
            color: "#436EEE"
            fontSizeMode: Text.Fit
            font.pixelSize: 15
            minimumPixelSize: 8
        }
        onClicked: {
            if (isPass) {
                playScene.playLevelPressed(modelData)

                audioManager.playSound("start")
                playScene.isPlayScene = true
                levelScene.isLevelScene = false
            }
        }
    }
}
