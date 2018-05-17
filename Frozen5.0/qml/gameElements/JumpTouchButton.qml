import VPlay 2.0
import QtQuick 2.0

Item {
  id: jumpTouchButton

  // should only be visible and enabled on touch devices, when
  // not in edit mode
  visible: !system.desktopPlatform && gameScene.state != "edit"
  enabled: visible

  // set size
  height: 60
  width: 80

  // anchor to the bottom right of the gameWindowAnchorItem
  anchors.right: gameScene.gameWindowAnchorItem.right
  anchors.bottom: gameScene.gameWindowAnchorItem.bottom

  signal pressed
  signal released

  // this is a background of the button image
  // it is only visible while the button is pressed, as visual feedback for the user
  Rectangle {
    id: background

    anchors.fill: parent

    // the radius of the edges; setting the radius to height gives this a circle shape
    radius: height

    // set color and opacity
    color: "#ffffff"
    opacity: 0.5

    // not visible by default, gets set to visible in the onPressed event
    visible: false
  }

  MultiResolutionImage {
    id: image

    source: "../../assets/ui/arrow_up.png"

    // fill the background
    anchors.fill: background

    fillMode: Image.PreserveAspectFit

    // make it half the size of the background
    scale: 0.5
  }

  // handle touch events
  MouseArea {
    anchors.fill: parent

    onPressed: {
      jumpTouchButton.pressed() // start jump
      background.visible = true // make background visible
    }

    // end jump when released
    onReleased: {
      jumpTouchButton.released() // start jump
      background.visible = false // make background invisible again
    }
  }
}