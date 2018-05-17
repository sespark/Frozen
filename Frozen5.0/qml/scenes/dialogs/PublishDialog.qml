import QtQuick 2.0
import VPlay 2.0
import "../../common"

DialogBase {
  id: publishDialog

  Text {
    anchors.centerIn: parent

    text: "Do you really want to publish this level?"

    color: "white"
  }

  // Buttons ------------------------------------------

  PlatformerTextButton {
    id: okButton

    screenText: "Ok"

    width: 100

    anchors.bottom: parent.bottom
    anchors.bottomMargin: 50
    anchors.left: parent.left
    anchors.leftMargin: 100

    onClicked: {
      // save level and publish it
      editorOverlay.saveLevel()
      levelEditor.publishLevel()

      // close dialog
      publishDialog.opacity = 0
    }
  }

  PlatformerTextButton {
    id: cancelButton

    screenText: "Cancel"

    width: 100

    anchors.bottom: parent.bottom
    anchors.bottomMargin: 50
    anchors.right: parent.right
    anchors.rightMargin: 100

    // when clicking "cancel" we only close the dialog
    onClicked: publishDialog.opacity = 0
  }
}

