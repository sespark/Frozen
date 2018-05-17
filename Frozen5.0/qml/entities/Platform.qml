import QtQuick 2.0
import VPlay 2.0
import "../editorElements"

PlatformerEntityBaseDraggable {
    id: platform
    entityType: "platform"

    // set the size to the sprite's size
    width: image.width
    height: image.height

    // define colliderComponent for collision detection while dragging
    colliderComponent: collider

    // set image
    image.source: "../../assets/ground/ice_spike2.png"

    BoxCollider {
        id: collider

        // set size and position to fit the sprite
        width: parent.width
        height: parent.height / 2

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top

        // this entity shouldn't move
        bodyType: Body.Static

        // Category5: solids
        categories: Box.Category5
        // Category1: player body, Category2: player feet sensor,
        // Category3: opponent body, Category4: opponent sensor
        collidesWith: Box.Category1 | Box.Category2 | Box.Category3 | Box.Category4
    }
}
