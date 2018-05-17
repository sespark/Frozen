import QtQuick 2.0
import VPlay 2.0
import "../../common"

DialogBase {
  id: levelTimeLimitDialog

  // Buttons ------------------------------------------

  PlatformerTextButton {
    id: allTime

    screenText: "All Time"

    width: 175

    anchors.centerIn: parent
    anchors.verticalCenterOffset: -50

    onClicked: {
      setTimeLimit(0)
    }
  }

  PlatformerTextButton {
    id: thisWeek

    screenText: "This Week"

    width: 175

    anchors.centerIn: parent

    onClicked: {
      setTimeLimit(24 * 7)
    }
  }

  PlatformerTextButton {
    id: today

    screenText: "Today"

    width: 175

    anchors.centerIn: parent
    anchors.verticalCenterOffset: 50

    onClicked: {
      setTimeLimit(24)
    }
  }

  function setTimeLimit(newTimeLimit) {
    // set new time limit
    levelScene.timeLimit = newTimeLimit

    // close dialog
    levelTimeLimitDialog.opacity = 0
  }
}

