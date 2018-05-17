import QtQuick 2.0
import VPlay 2.0
import "../../common"

DialogBase {
  id: levelOrderDialog

  // Buttons ------------------------------------------

  PlatformerTextButton {
    id: newest

    screenText: "Newest"

    width: 175

    anchors.centerIn: parent
    anchors.verticalCenterOffset: -50

    onClicked: {
      setOrder("created_at")
    }
  }

  PlatformerTextButton {
    id: highestRated

    screenText: "Highest Rated"

    width: 175

    anchors.centerIn: parent

    onClicked: {
      setOrder("average_quality")
    }
  }

  PlatformerTextButton {
    id: mostDownloaded

    screenText: "Most Downloaded"

    width: 175

    anchors.centerIn: parent
    anchors.verticalCenterOffset: 50

    onClicked: {
      setOrder("times_downloaded")
    }
  }

  function setOrder(newOrder) {
    // set new order
    levelScene.order = newOrder

    // close dialog
    levelOrderDialog.opacity = 0
  }
}

