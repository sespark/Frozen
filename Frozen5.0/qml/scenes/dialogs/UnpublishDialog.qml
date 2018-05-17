import QtQuick 2.0
import VPlay 2.0
import "../../common"

DialogBase {
  id: unpublishDialog

  property var levelData

  Text {
    anchors.centerIn: parent

    text: "Do you really want to unpublish this level?"

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
      // unpublish this level
      levelEditor.unpublishLevel(levelData)

      // close dialog
      unpublishDialog.opacity = 0
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
    onClicked: unpublishDialog.opacity = 0
  }
}

