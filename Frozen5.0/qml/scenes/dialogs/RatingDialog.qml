import QtQuick 2.0
import VPlay 2.0
import "../../common"

DialogBase {
  id: ratingDialog

  // the level that should be rated
  property var levelData

  signal levelRated

  // Buttons ------------------------------------------

  PlatformerImageButton {
    image.source: "../../../assets/ui/rate_5stars.png"

    width: 175
    height: 30

    anchors.centerIn: parent
    anchors.verticalCenterOffset: -100

    onClicked: rateLevel(5)
  }

  PlatformerImageButton {
    image.source: "../../../assets/ui/rate_4stars.png"

    width: 175
    height: 30

    anchors.centerIn: parent
    anchors.verticalCenterOffset: -50

    onClicked: rateLevel(4)
  }

  PlatformerImageButton {
    image.source: "../../../assets/ui/rate_3stars.png"

    width: 175
    height: 30

    anchors.centerIn: parent

    onClicked: rateLevel(3)
  }

  PlatformerImageButton {
    image.source: "../../../assets/ui/rate_2stars.png"

    width: 175
    height: 30

    anchors.centerIn: parent
    anchors.verticalCenterOffset: 50

    onClicked: rateLevel(2)
  }

  PlatformerImageButton {
    image.source: "../../../assets/ui/rate_1star.png"

    width: 175
    height: 30

    anchors.centerIn: parent
    anchors.verticalCenterOffset: 100

    onClicked: rateLevel(1)
  }

  function rateLevel(rating) {
    // rate level
    levelEditor.rateLevel( { levelId: levelData.levelId, quality: rating } )

    // reload levels
    levelScene.reloadLevels()

    // close dialog
    ratingDialog.opacity = 0
  }
}
