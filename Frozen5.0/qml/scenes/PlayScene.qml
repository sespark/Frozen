import QtQuick 2.0
import VPlay 2.0
import "../common"
import "./sceneElements"

SceneBase {
    id: playScene

    property bool playButtonVisible: true
    property bool isPlayScene: false
    property alias playLevelGrid: playLevelGrid

    property int finishLevelID
    onFinishLevelIDChanged: {
        console.debug(
                    "-=======================================================-=playScene finishLevelId" + finishLevelID)
    }
    //    property alias currentLevelData
    //    signal levelPressed(string selectedLevelFileName)
    //点击关卡
    signal playLevelPressed(var levelData)
    //    signal levelFinish(var levelData)

    //点击返回按钮
    signal backPressed

    MultiResolutionImage {
        id: backgroud
        source: "../../assets/backgroundImage/ice_land.jpg"

        anchors.fill: parent.gameWindowAnchorItem
        x: 0
        y: 0
    }

    PlatformerImageButton {
        id: menuButton

        image.source: "../../assets/ui/home.png"

        width: 40
        height: 30

        anchors.top: parent.gameWindowAnchorItem.top
        anchors.topMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 5

        // go back to MenuScene
        onClicked: backPressed()
    }

    Rectangle {
        id: mainBar

        width: parent.gameWindowAnchorItem.width
        height: 40

        anchors.top: parent.gameWindowAnchorItem.top
        anchors.left: parent.gameWindowAnchorItem.left

        // background gradient
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: "transparent"
            }
            GradientStop {
                position: 0.5
                //                color: "#80ffffff"
                color: "transparent"
            }
            GradientStop {
                position: 1.0
                color: "transparent"
            }
        }
    }
    PlayLevelGrid {
        id: playLevelGrid

        anchors.top: playScene.gameWindowAnchorItem.top
        anchors.bottom: playScene.gameWindowAnchorItem.bottom
        anchors.topMargin: playScene.height * 0.2
        anchors.left: playScene.gameWindowAnchorItem.left
        anchors.leftMargin: playScene.width * 0.2
        visible: true

        playLevelMetaDataArray: gameWindow.levelEditor.applicationJSONLevels
        //        Settings.getValue: modelData.levelName
    }

    function finish() {
        playLevelGrid.playLevelFinish()
    }

    function resetLevel(levelID) {
        playLevelGrid.resetLevel(levelID)
    }
}
