import QtQuick 2.0
import VPlay 2.0
import "../../common"

DialogBase {
  id: finishDialog

  // this dialog should not be closeable
  closeableByClickOnBackground: false

  // this holds the score, the player achieved
  property real score

  Text {
    anchors.centerIn: parent
    anchors.verticalCenterOffset: -20

    text: "Finished!"

    color: "white"
  }

  Text {
    anchors.centerIn: parent

    text: "Score: " + score

    color: "white"
  }

  Text {
    anchors.centerIn: parent
    anchors.verticalCenterOffset: 20

    // this property holds the current leaderboard
    property var currentLeaderboard: {
      if(levelEditor.currentLevelData.levelMetaData) {
        // if id exists, return it
        if(levelEditor.currentLevelData.levelMetaData.id)
          return levelEditor.currentLevelData.levelMetaData.id
        // else if publishedLevelId exists, return it
        else if(levelEditor.currentLevelData.levelMetaData.publishedLevelId)
          return levelEditor.currentLevelData.levelMetaData.publishedLevelId
      }
      // else return defaultLeaderboard
      return undefined
    }

    // show the user's current highscore and rank
    text: "Your Highscore: " + gameNetwork.userHighscoreForLeaderboard(currentLeaderboard)
          + " (#" + gameNetwork.userPositionForLeaderboard(currentLeaderboard) + ")"

    color: "#80bfff"

    // only visible if level has been published
    visible: currentLeaderboard !== undefined
  }

  // Buttons ------------------------------------------

  PlatformerTextButton {
    id: okButton

    screenText: "Restart"

    width: 100

    anchors.bottom: parent.bottom
    anchors.bottomMargin: 50
    anchors.left: parent.left
    anchors.leftMargin: 100

    onClicked: {
      // close dialog
      finishDialog.opacity = 0

      // reset state to play
      gameScene.state = "play"

      // reset and restart level
      gameScene.resetLevel()
    }
  }

  PlatformerTextButton {
    id: cancelButton

    screenText: "Menu"

    width: 100

    anchors.bottom: parent.bottom
    anchors.bottomMargin: 50
    anchors.right: parent.right
    anchors.rightMargin: 100

    onClicked: {
      // close dialog
      finishDialog.opacity = 0

      // reset state to play
      gameScene.state = "play"

      // go back to menu
      gameScene.backPressed()
    }
  }
}

