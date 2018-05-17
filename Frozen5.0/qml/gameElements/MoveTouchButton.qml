import VPlay 2.0
import QtQuick 2.0

Item {
  // should only be visible and enabled on touch devices, when
  // not in edit mode
  visible: !system.desktopPlatform && gameScene.state != "edit"
  enabled: visible

  // set size
  height: 60
  width: 160

  // anchor to the bottom left of the gameWindowAnchorItem
  anchors.left: gameScene.gameWindowAnchorItem.left
  anchors.bottom: gameScene.gameWindowAnchorItem.bottom

  // the TwoAxisController, which controls the player's left/right movement
  property var controller

  // this is a background of the left button image
  // it is only visible while the button is pressed, as visual feedback for the user
  Rectangle {
    id: backgroundLeft

    // make this fill the left half of this item
    width: parent.width / 2
    height: parent.height

    anchors.left: parent.left

    // the radius of the edges; setting the radius to height gives this a circle shape
    radius: height

    // set color and opacity
    color: "#ffffff"
    opacity: 0.5

    // not visible by default, gets set to visible in the onPressed event
    visible: false
  }

  MultiResolutionImage {
    id: imageLeft

    source: "../../assets/ui/arrow_left.png"

    // fill the left background
    anchors.fill: backgroundLeft

    fillMode: Image.PreserveAspectFit

    // make it half the size of the background
    scale: 0.5
  }

  // this is a background of the right button image
  // it is only visible while the button is pressed, as visual feedback for the user
  Rectangle {
    id: backgroundRight

    width: parent.width / 2
    height: parent.height

    anchors.right: parent.right

    radius: height

    // set color and opacity
    color: "#ffffff"
    opacity: 0.5

    visible: false
  }

  MultiResolutionImage {
    id: imageRight

    source: "../../assets/ui/arrow_right.png"

    // fill the right background
    anchors.fill: backgroundRight

    fillMode: Image.PreserveAspectFit

    // make it half the size of the background
    scale: 0.5
  }

  // handle touch events
  MultiPointTouchArea {
    anchors.fill: parent

    // set controller's xAxis depending on where the user presses
    // make backgrounds visible
    onPressed: {
      if(touchPoints[0].x < width/2) {
        controller.xAxis = -1
        backgroundLeft.visible = true
      }
      else {
        controller.xAxis = 1
        backgroundRight.visible = true
      }
    }

    onUpdated: {
      if(touchPoints[0].x < width/2)
        controller.xAxis = -1
      else
        controller.xAxis = 1
    }

    onReleased: {
      // reset xAxis to zero
      controller.xAxis = 0

      // make backgrounds invisible again
      backgroundLeft.visible = false
      backgroundRight.visible = false
    }
  }
}