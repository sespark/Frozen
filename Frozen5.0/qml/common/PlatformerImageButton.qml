import QtQuick 2.0
import QtQuick.Controls.Styles 1.0
import VPlay 2.0

ButtonVPlay {
    id: imageButton

    height: parent.height

    // properties of the ButtonStyle background Rectangle
    property int borderWidth: 1
    property color borderColor: "transparent"
    property int radius: 3
    property color color: "white"

    // aliases to enable access to these components from the outside
    property alias image: image
    property alias hoverRectangle: hoverRectangle

    // we override the default V-Play style with our own style
    style: ButtonStyle {
        background: Rectangle {
            border.width: imageButton.borderWidth
            border.color: imageButton.borderColor
            radius: imageButton.radius

            // add a gradient as background
            gradient: Gradient {
                // take color as the first color
                GradientStop {
                    position: 0.0
                    color: imageButton.color
                }
                // tint color, to make it a little darker and use it as second color
                GradientStop {
                    position: 1.0
                    color: Qt.tint(imageButton.color, "#24000000")
                }
            }
        }
    }

    onClicked: audioManager.playSound("click")

    // the image displayed
    MultiResolutionImage {
        id: image

        anchors.fill: parent
        anchors.margins: 1

        fillMode: Image.PreserveAspectFit
    }

    // this white rectangle covers the button when the mouse hovers above it
    Rectangle {
        id: hoverRectangle

        anchors.fill: parent

        radius: imageButton.radius
        color: "#36648B"

        // when the mouse hovers over the button, this rectangle is slightly visible
        opacity: hovered ? 0.3 : 0
    }
}
