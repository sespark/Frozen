import QtQuick 2.0
import VPlay 2.0

Opponent {
  id: opponentJumper
  variationType: "jumper"

  // this property determines in which the opponent will jump next
  // (-1 = left, 1 = right)
  property int direction: -1

  // the opponents jumpForce in vertical and horizontal
  // direction
  property int verticalJumpForce: 510
  property int horizontalJumpForce: 40

  // set image
  // if opponent is alive, use normal sprite,
  // else, use dead sprite
  image.source: alive ? "../../assets/opponent/opponent_jumper.png"
                      : "../../assets/opponent/opponent_jumper_dead.png"

  // define colliderComponent for collision detection while dragging
  colliderComponent: collider

  // if the opponent dies, stop it's jumpTimer
  onAliveChanged: {
    if(!alive) {
      jumpTimer.stop()
    }
  }

  // the opponents main collider
  PolygonCollider {
    id: collider    //调整碰撞的形状

    // vertices, forming the shape of the collider
    vertices: [
      Qt.point(1, 1),
      Qt.point(31, 1),
      Qt.point(31, 30),
      Qt.point(23, 31),
      Qt.point(9, 31),
      Qt.point(1, 30)
    ]

    // the bodyType is dynamic
    bodyType: Body.Dynamic

    // the collider should not be active in edit mode or
    // when dead
    active: inLevelEditingMode || !alive ? false : true

    // Category3: opponent body
    categories: Box.Category3
    // Category2: player body, Category2: player feet sensor,
    // Category5: solids
    collidesWith: Box.Category1 | Box.Category2 | Box.Category5

    // to avoid, that the opponent slides on the ground
    friction: 1
  }

  // this collider checks for collisions from the bottom and starts
  // the jumpTimer, on collision
  BoxCollider {
    id: bottomSensor

    // set size and position
    width: 30
    height: 3

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.bottom

    // the bodyType is dynamic
    bodyType: Body.Dynamic

    // only active when the main collider is active
    active: collider.active

    // Category4: opponent sensor
    categories: Box.Category4
    // Category5: solids
    collidesWith: Box.Category5

    // this collider is for collision testing only
    collisionTestingOnlyMode: true

    // this is called whenever the contact with another entity begins
    fixture.onContactChanged: {
      var otherEntity = other.getBody().target

      // When the opponent stands on a solid object, we want it
      // to wait a little and then jump again.
      // Since we set the collidesWith property, we can be sure
      // that it won't collide with any unwanted entities.
      if(collider.linearVelocity.y === 0 && !jumpTimer.running)
        jumpTimer.start()
    }
  }

  // this timer is started in the bottomSensor and makes the opponent jump
  // when triggered
  Timer {
    id: jumpTimer

    interval: 300

    onTriggered: {
      // jump in the current direction
      collider.applyLinearImpulse(Qt.point(direction * horizontalJumpForce, -verticalJumpForce))

      // alternate direction after every jump
      direction *= -1
    }
  }

  // make properties editable via itemEditor
  EditableComponent {
    editableType: "Balance"
    defaultGroup: "OpponentJumper"

    targetEditor: gameScene.itemEditor

    properties: {
      "horizontalJumpForce": {"min": 0, "max": 200, "stepSize": 10, "label": "Horizontal Jump"},
      "verticalJumpForce": {"min": 0, "max": 800, "stepSize": 10, "label": "Vertical Jump"}
    }
  }

  // reset the opponent
  function reset() {
    // We set alive to false here, and reset it to true later,
    // to deactivate the collider while the opponent is reset.
    alive = false

    // this is the reset function of the base entity Opponent.qml
    reset_super()

    // reset direction
    direction = -1

    // reset timer
    if(jumpTimer.running)
      jumpTimer.stop()

    alive = true
  }
}

