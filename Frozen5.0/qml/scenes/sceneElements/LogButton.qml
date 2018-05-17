import QtQuick 2.0

Rectangle {
    id: container

    property string text: "Button"
    property bool mouseEnabled: true

    signal clicked

    width: buttonLabel.width + 10
    height: buttonLabel.height + 5

    border {
        width: 1
        color: Qt.darker(activePalette.button)
    }
    antialiasing: true //fan bie ming
    radius: 8

    // color the button with a gradient
    gradient: Gradient {
        GradientStop {
            position: 0.0
            color: {
                if (mouseArea.pressed)
                    return activePalette.dark
                else
                    return "lightBlue"
            }
        }
        GradientStop {
            position: 1.0
            color: activePalette.button
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: container.clicked()
        enabled: mouseEnabled
    }

    Text {
        id: buttonLabel
        anchors.centerIn: container
        color: activePalette.buttonText
        text: container.text
        font.pixelSize: container.width * 0.15
    }
}
