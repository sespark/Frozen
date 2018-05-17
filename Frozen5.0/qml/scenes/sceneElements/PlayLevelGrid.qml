/*import QtQuick 2.0
import VPlay 2.0

Item {
    id: playLevelGride

    anchors.top: playScene.gameWindowAnchorItem.top
    anchors.bottom: playScene.gameWindowAnchorItem.bottom

    // 要左右都anchos才能显示出来
    anchors.left: playScene.left
    anchors.right: playScene.right

    anchors.margins: 5
    anchors.topMargin: 0
    anchors.bottomMargin: 0

    anchors.leftMargin: playScene.width * 0.2
    property var playLevelMetaDataArray

    onPlayLevelMetaDataArrayChanged: {
        console.debug("onPlayLevelMetaDataArrayChanged")
        playLevelListRepeater.model = playLevelMetaDataArray
    }

    Flickable {
        id: playLevelGrideFlickable

        anchors.fill: parent
        clip: true

        contentWidth: grid1.width
        contentHeight: grid1.height

        flickableDirection: Flickable.VerticalFlick

        Grid {
            id: grid1

            anchors.top: parent.top
            anchors.topMargin: 10

            columns: 5
            spacing: 10

            // the repeater adds a levelItemDelegate item for each level
            Repeater {
                id: playLevelListRepeater

                // delegate is the default property of Repeater
                delegate: PlayLevelSelectionItem {
                }
            }
        }
    }
}*/
import QtQuick 2.0
import VPlay 2.0

Item {
    id: playLevelGrid
    //关卡的显示和加载

    //anchoring
    anchors.top: playScene.gameWindowAnchorItem.top
    anchors.bottom: playScene.gameWindowAnchorItem.bottom
    anchors.left: playScene.left
    anchors.right: playScene.right

    anchors.margins: 5
    anchors.topMargin: 0
    anchors.bottomMargin: 0

    property var playLevelMetaDataArray
    property alias grid: grid
    property int finishLevelID: playScene.finishLevelID

    onPlayLevelMetaDataArrayChanged: {
        levelListRepeater.model = playLevelMetaDataArray
    }

    Flickable {
        id: playLevelGridFlickable

        anchors.fill: parent

        clip: true

        contentWidth: grid.width

        contentHeight: grid.height + 2 * offset.height

        flickableDirection: Flickable.VerticalFlick

        Item {
            id: offset
            width: parent.width
            height: 5

            anchors.top: parent.top
        }

        Grid {
            id: grid

            anchors.top: offset.bottom
            anchors.centerIn: parent

            columns: 4
//            rows:3
            spacing: 10

            Repeater {
                id: levelListRepeater

                delegate: PlayLevelSelectionItem {
                }
            }
        }
    }

    function playLevelFinish() {
        //音乐repeater将元素保存为数组形式，所以当前关卡明是1,则解锁的是第二关，及数组下标为1的关卡
        var levelSelectionItem = levelListRepeater.itemAt(
                    levelEditor.currentLevelName)
        levelSelectionItem.isPass = true
    }

    function refreshLevel() {}
}
