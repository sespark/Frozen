import QtQuick 2.0
import VPlay 2.0
import "../common"

PlatformerImageButton {
    //游戏进入play或者levels界面的按钮（My levels,Community..)
    id: itemGroupButton

    width: parent.buttonWidth
    height: parent.height

    // make the color grey when selected, white otherwise
    color: selected ? "#c0c0c0" : "#ffffff" //Button被点击过后的颜色变化，用于levelEditor中的按键（如笔、手掌、实体），还有几个界面中的选择按钮

    property bool selected: false
}
