import VPlay 2.0
import QtQuick 2.0

// This sensor is always at the bottom of the level, directly
// below the player. So the player touches it just before he
// would fall out of bounds at the bottom of the level.
// When he touches it, he dies.
EntityBase {
  id: resetSensor
  entityType: "resetSensor"

  // the player
  property var player

  // set the position to below the player, at the bottom of the level
  x: player.x
  y: 0

  // set size
  width: player.width
  height: 10

  // only visible and enabled when playing, not when editing
  visible: !player.inLevelEditingMode
  enabled: !player.inLevelEditingMode

  // this is emitted, when the sensor collides with the player
  signal contact

  // this collider checks if the player hits the bottom of the level
  BoxCollider {
    anchors.fill: parent
    collisionTestingOnlyMode: true

    // Category7: reset sensor
    categories: Box.Category6
    // Category1: player body
    collidesWith: Box.Category1

    fixture.onBeginContact: {
      var otherEntity = other.getBody().target

      // If the player hits the sensor, we emit a signal which will be used to
      // reset the player.
      if(otherEntity.entityType === "player") {
        // We could also directly modify the player position here, but the
        // signal approach is a bit cleaner and helps separating the components.
        resetSensor.contact()
      }
    }
  }

  // The rectangle and text are just for you to see how the
  // sensor moves - set visible to true, to see it.
  Rectangle {
    visible: false

    y: -resetSensor.height

    width: parent.width
    height: parent.height

    anchors.horizontalCenter: parent.horizontalCenter
    color: "yellow"
    opacity: 0.5

    Text {
      y: -resetSensor.height

      anchors.centerIn: parent
      text: "reset sensor"
      color: "white"
      font.pixelSize: 9
    }
  }
}

