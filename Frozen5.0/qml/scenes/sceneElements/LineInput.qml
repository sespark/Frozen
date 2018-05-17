//import QtQuick 2.0
import QtQuick 2.7

FocusScope {
    id: wrapper

    property alias hintText: hint.text

    property alias inputText: input.text
    property alias validator: input.validator
    property alias echoMode: input.echoMode
    property alias input: input

    property int font_size: 15
    property int maxLength: 15

    signal accepted
    signal textChanged
    signal edittingFinished

    Rectangle {
        anchors.fill: parent
        border.color: "#F0F8FF"
        color: "#778899"
        radius: 10

        Text {
            id: hint
            anchors {
                fill: parent
                leftMargin: 14
            }
            verticalAlignment: Text.AlignVCenter
            text: ""
            font.pixelSize: font_size
            color: "#707070"
            opacity: input.length ? 0 : 1
        }

        TextInput {
            id: input
            focus: true
            anchors {
                left: hint.left
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 15
            color: "black"
            onAccepted: wrapper.accepted()
            maximumLength: maxLength
            selectByMouse: true
            mouseSelectionMode: TextInput.SelectWords

            onTextChanged: wrapper.textChanged()

            validator: RegExpValidator {
                regExp: /[A-Za-z]{0,12}/
            }

            onEditingFinished: edittingFinished()
        }
    }
}
