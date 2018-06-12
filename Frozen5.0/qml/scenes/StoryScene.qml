import QtQuick 2.0
import VPlay 2.0
import "../common"
import "./sceneElements"

SceneBase {
    id: storyScene

    property bool isSkip: false

    signal nextPress

    MultiResolutionImage {
        anchors.fill: parent

        source: "../../assets/backgroundImage/bg10.png"
        Text {
            id: story
            anchors.centerIn: parent
            text: qsTr("    企鹅公主被魔王困于深海，远海的企鹅骑士，
你是否愿意以身犯险，前往魔窟，救出公主？")
            color: "black"
            font.family: superMarioFont.name
        }
    }

    MultiResolutionImage {
        id: next
        height: 30
        width: 30

        anchors {
            bottom: parent.bottom
            bottomMargin: 30
            right: parent.right
            rightMargin: 20
        }

        source: "../../assets/ui/arrow_right.png"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                isSkip = true
                nextPress()
            }
        }
    }
}
