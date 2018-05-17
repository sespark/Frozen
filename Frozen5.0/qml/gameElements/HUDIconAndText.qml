import QtQuick 2.0
import VPlay 2.0

Rectangle {
    // 时间和金币的显示框和文字
    property alias text: textItem.text
    property alias icon: icon

    // only visible when playing
    visible: gameScene.state != "edit"

    // we set the width dynamically to the size of the text
    // and the image, plus a little margin
    width: textItem.width + icon.width + 10
    height: 20

    // anchor to the top left corner
    anchors.top: gameScene.gameWindowAnchorItem.top
    anchors.left: gameScene.gameWindowAnchorItem.left
    anchors.margins: 4

    // round the edges
    radius: 3

    // background color of the rectangle
    color: "#80ffffff"

    // the icon
    MultiResolutionImage {
        id: icon

        // width = height
        height: parent.height
        width: height

        // anchor to the left of the rectangle
        anchors.left: parent.left
        anchors.leftMargin: 2
    }

    // the text
    Text {
        id: textItem

        height: parent.height

        // center the text vertically
        verticalAlignment: Text.AlignVCenter

        // anchor to the left of the icon
        anchors.left: icon.right
        anchors.leftMargin: 2
    }
}
