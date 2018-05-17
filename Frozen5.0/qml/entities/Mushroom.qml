import QtQuick 2.0
import VPlay 2.0
import "../editorElements"

PlatformerEntityBaseDraggable {
    id: mushroom
    entityType: "mushroom"

    // this property is true when the player collected the mushroom
    property bool collected: false

    // when the mushroom is collected, it shouldn't be visible anymore
    image.visible: !collected

    // define colliderComponent for collision detection while dragging
    colliderComponent: collider

    // set image
    image.source: "../../assets/powerups/blue-potion.png"

    BoxCollider {
        id: collider

        // make the collider a little smaller than the sprite
        width: parent.width - 2
        height: parent.height - 2
        anchors.centerIn: parent

        // disable collider when mushroom is collected
        active: !collected

        // the collider is static (shouldn't move) and only test
        // for collisions
        bodyType: Body.Static
        collisionTestingOnlyMode: true

        // Category6: powerup
        categories: Box.Category6
        // Category1: player body
        collidesWith: Box.Category1
    }

    function collect() {
        console.debug("collect mushroom")
        mushroom.collected = true

        audioManager.playSound("collectMushroom")
    }

    // reset mushroom
    function reset() {
        mushroom.collected = false
    }
}
