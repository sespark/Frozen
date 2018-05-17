import QtQuick 2.0
import QtQuick.Controls.Styles 1.0
import VPlay 2.0

ButtonVPlay {
    id: textButton

    width: screenText.width + 20
    height: 30

    // background color
    property color color: "#ffffff"

    // we use screenText instead of the ButtonVPlay text property,
    // because the existing text property causes bad fonts
    property alias screenText: screenText.text

    property int radius: 3
    property int textSize: 12
    // alias to access the text color
    property alias textColor: screenText.color
    property string borderColor: "black"
    property int borderWidth: 1

    // we override the default V-Play style with our own
    style: ButtonStyle {
        background: Rectangle {
            border.width: textButton.borderWidth
            border.color: textButton.borderColor
            radius: textButton.radius

            // add a gradient as background
            gradient: Gradient {
                // take color as the first color
                GradientStop {
                    position: 0.0
                    color: textButton.color
                }
                // tint color, to make it a little darker and use it as second color
                GradientStop {
                    position: 1.0
                    color: Qt.tint(textButton.color, "#24000000")
                }
            }
        }
    }

    onClicked: audioManager.playSound("click")

    // text displayed in the button
    Text {
        id: screenText

        anchors.centerIn: parent

        font.pixelSize: textButton.textSize
    }

    // this white rectangle covers the button when the mouse hovers above it
    Rectangle {
        anchors.fill: parent

        radius: 3

        color: "white"
        opacity: hovered ? 0.3 : 0
    }
}
