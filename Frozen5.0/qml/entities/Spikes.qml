import QtQuick 2.0
import VPlay 2.0
import "../editorElements"

PlatformerEntityBaseDraggable {
  id: spikes
  entityType: "spikes"
  variationType: "up"

  // set the size to the sprite's size
  width: image.width
  height: image.height

  // define colliderComponent for collision detection while dragging
  colliderComponent: collider

  // set image
  image.source: "../../assets/spikes/spikes.png"

  BoxCollider {
    id: collider

    // set the collider's size to fit to the sprite
    width: parent.width
    height: parent.height / 2 + 1

    // set position
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom

    // the bodyType is static
    bodyType: Body.Static

    // the collider should not be active in edit mode
    active: !inLevelEditingMode

    // Category5: solids
    categories: Box.Category5
    // Category1: player body, Category2: player feet sensor,
    // Category3: opponent body, Category4: opponent sensor
    collidesWith: Box.Category1 | Box.Category2 | Box.Category3 | Box.Category4
  }
}

