import QtQuick 2.0
import VPlay 2.0
import "../../common"

DialogBase {
  id: removeLevelDialog

  Text {
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 100

    text: "What do you want to do?"

    color: "white"
  }

  // Buttons ------------------------------------------

  PlatformerTextButton {
    id: saveAndExitButton

    screenText: "Save and Exit"

    width: 175

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 150

    onClicked: {
      // when clicking "save and exit" the level gets saved, we
      // emit the gameScene's backPressed signal and close the dialog
      editorOverlay.saveLevel()
      editorOverlay.scene.backPressed()

      removeLevelDialog.opacity = 0
    }
  }

  PlatformerTextButton {
    id: discardAndExitButton

    screenText: "Exit"

    width: 175

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 100

    onClicked: {
      // when clicking "exit" we only emit the gameScene's backPressed
      // signal and close the dialog
      editorOverlay.scene.backPressed()

      removeLevelDialog.opacity = 0
    }
  }

  PlatformerTextButton {
    id: cancelButton

    screenText: "Cancel"

    width: 175

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 50

    // when clicking "exit" we only close the dialog and return to
    // the editor
    onClicked: removeLevelDialog.opacity = 0
  }
}

