import QtQuick 2.0
import VPlay 2.0
import "../editorElements"


// this is the base class for all opponents
PlatformerEntityBaseDraggable {
    id: opponent
    entityType: "opponent" //敌人

    // the opponent's start position
    // These are the coordinates, to which the opponent gets reset,
    // when resetting the level.
    property int startX
    property int startY

    // this is true while the opponent is alive
    property bool alive: true

    // After an opponent dies, we want to show it's dead-sprite for a short
    // time, and then hide it.
    // If this property is true, the opponent is invisible.
    property bool hidden: false //怪物死了，显示死亡动画，然后消失

    z: 1 // to make opponent appear in front of the platforms

    // set the opponent's size to it's sprite's size
    width: image.width
    height: image.height

    // hide opponent after its death
    image.visible: !hidden

    // update the entity's start position when the entity is created or moved
    onEntityCreated: updateStartPosition()
    onEntityReleased: updateStartPosition()

    // this timer hides the opponent a few seconds after its death
    Timer {
        id: hideTimer
        interval: 2000

        onTriggered: hidden = true
    }

    function updateStartPosition() {
        startX = x
        startY = y
    }

    // this function resets all properties, which all opponents have in common
    function reset_super() {
        // reset alive property
        alive = true

        // stop hideTimer, to avoid unwanted, delayed hiding of the opponent
        hideTimer.stop()
        // reset hidden
        hidden = false

        // reset position
        x = startX
        y = startY

        // reset velocity
        collider.linearVelocity.x = 0
        collider.linearVelocity.y = 0

        // reset force
        collider.force = Qt.point(0, 0)
    }

    function die() {
        alive = false

        hideTimer.start()

        if (variationType == "walker")
            audioManager.playSound("opponentWalkerDie")
        else if (variationType == "jumper")
            audioManager.playSound("opponentJumperDie")

        // for every killed opponent, the time gets set back a little bit
        gameScene.time -= 5
    }
}
