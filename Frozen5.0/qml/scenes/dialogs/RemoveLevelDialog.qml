import QtQuick 2.0
import VPlay 2.0
import "../../common"

DialogBase {
  id: removeLevelDialog

  // is set from LevelScene
  // we need this to know which level to delete
  property var levelData

  Text {
    anchors.centerIn: parent

    text: "Do you really want to remove this level?"

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
      // if level is published, unpublish level
      if(levelData.publishedLevelId) {
        levelEditor.unpublishLevel(levelData)
        delete levelData.publishedLevelId
      }

      // remove level
      levelScene.removeLevelPressed(levelData)

      // close dialog
      removeLevelDialog.opacity = 0
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
    onClicked: removeLevelDialog.opacity = 0
  }
}

