import VPlay 2.0
import QtQuick 2.0
import "../editorElements"

PlatformerEntityBaseDraggable {
    id: player
    entityType: "player"

    /**
   * Custom properties ----------------------------------------------------
   */
    // the player's start position
    property int startX
    property int startY

    // add aliases for easier access
    property alias horizontalVelocity: collider.linearVelocity.x
    property alias verticalVelocity: collider.linearVelocity.y

    // the number of collected coins
    property int score: 0

    // if this is true, the player can jump once, without touching the ground
    property bool doubleJumpEnabled: true

    // if isBig is true, the player sprite is higher, and the
    // player touch one enemy/spike without dying (like in Super Mario games)
    property bool isBig: false

    // if true, the player is invincible
    property bool invincible: false

    // the time in ms, the player is invincible, after collecting a star
    property int starInvincibilityTime: 4000

    // this property is used to determine if the player touches any solid
    // objects (e.g. ground or platform)
    property int contacts: 0

    // these properties set the player's jump force for normal- and
    // kill-jumps
    property int normalJumpForce: 210
    property int killJumpForce: 420

    // This property holds how many more iterations the player's
    // jump height can increase. We use this to control the jump height.
    // See the ascentControl Timer for more details.
    property int jumpForceLeft: 20

    // the player's accelerationForce
    property int accelerationForce: 1000

    // the factor by how much the player's speed decreases when
    // the user stops pressing left or right
    property real decelerationFactor: 0.6

    // the player's maximum movement speed
    property int maxSpeed: 230

    // maximum falling speed
    property int maxFallingSpeed: 800

    signal walking
    signal stopwalking
    onWalking: pictureImage.running = true
    onStopwalking: pictureImage.running = false

    property int count: 0
    //________________________________________________________
    Timer {
        id: pictureImage
        interval: 150
        running: false
        repeat: true
        onTriggered: {

            count++
            if (count == 1) {

                image.source = !isBig ? "../../assets/player/player/walk-0.png" : "../../assets/player/player/walk-0.png"

                //                console.debug("player is run 1!")
            } else if (count == 2) {

                image.source = !isBig ? "../../assets/player/player/walk-1.png" : "../../assets/player/player/walk-1.png"

                //                console.debug("player is run 2!")
            } else if (count == 3) {
                image.source = !isBig ? "../../assets/player/player/walk-2.png" : "../../assets/player/player/walk-2.png"

                //                console.debug("player is run 3!")
            } else if (count == 4) {
                image.source = !isBig ? "../../assets/player/player/walk-3.png" : "../../assets/player/player/walk-3.png"

                //                console.debug("player is run 4!")
            } else if (count == 5) {
                image.source = !isBig ? "../../assets/player/player/walk-4.png" : "../../assets/player/player/walk-4.png"

                //                console.debug("player is run 4!")
            } else if (count == 6) {
                image.source = !isBig ? "../../assets/player/player/walk-5.png" : "../../assets/player/player/walk-5.png"

                //                console.debug("player is run 4!")
            } else {

                //                console.debug("player Sprite error!")
                if (count >= 7) {
                    count %= 6
                }
            }
        }
    }
    /**
   * Signals ----------------------------------------------------
   */

    // signal for finishing the level
    signal finish

    /**
   * Object properties ----------------------------------------------------
   */

    // set the player's size to his image size
    width: image.width
    height: image.height

    // define colliderComponent for collision detection while dragging
    colliderComponent: collider

    // set image
    image.source: "../../assets/player/player1/player.png"

    // make player smaller, if isBig is false
    scale: isBig ? 1 : 0.64
    // animate scale changes
    Behavior on scale {
        NumberAnimation {
            duration: 500
        }
    }

    // transform from the center of the bottom
    transformOrigin: Item.Bottom

    // If the player touches another solid object, we set his state
    // to "walking". Otherwise we set it to "jumping".
    // The player can only jump when "walking", or by using the doubleJump.
    state: contacts > 0 ? "walking" : "jumping"

    // make player unremovable
    preventFromRemovalFromEntityManager: true

    // limit falling speed
    onVerticalVelocityChanged: {
        if (verticalVelocity > maxFallingSpeed)
            verticalVelocity = maxFallingSpeed
    }

    onFinish: audioManager.playSound("finish")

    /**
   * Colliders ---------------------------------------
   */

    // the player's main collider
    PolygonCollider {
        id: collider

        // We set the collider vertices to fit the body of the player.
        // Note, that we set the very left and right bottom vertices
        // to 62.8/62.85. This avoids collision with edges of solid objects,
        // when the player moves.
        // Also we have two different shapes, depending on the size
        // of the player.
        vertices: isBig ? // big collider
                          [Qt.point(15, 24), Qt.point(25, 14), Qt.point(
                               40, 14), Qt.point(47, 24), Qt.point(
                               49, 62.8), Qt.point(44, 63), Qt.point(
                               19, 63), Qt.point(14, 62.8)] : // small collider
                          [Qt.point(21, 39), Qt.point(28, 34), Qt.point(
                               39, 34), Qt.point(43, 39), Qt.point(
                               43, 62.85), Qt.point(40, 63), Qt.point(
                               23, 63), Qt.point(20, 62.85)]

        // the bodyType is dynamic in-game
        bodyType: Body.Dynamic

        // the collider should not be active in edit mode
        active: !inLevelEditingMode

        // Category1: player body
        categories: Box.Category1
        // Category5: opponent body, Category5: solids,
        // Category6: powerups, Category7: reset sensor
        collidesWith: Box.Category3 | Box.Category5 | Box.Category6 | Box.Category7

        // we set friction to zero to make the player slide down the sides of other entities
        friction: 0

        // don't allow sleeping
        sleepingAllowed: false

        // Apply the horizontal value of the TwoAxisController as force
        // to move the player left or right.
        force: Qt.point(controller.xAxis * accelerationForce, 0)

        // limit the horizontal velocity
        onLinearVelocityChanged: {
            if (linearVelocity.x > maxSpeed)
                linearVelocity.x = maxSpeed
            if (linearVelocity.x < -maxSpeed)
                linearVelocity.x = -maxSpeed
        }

        // this is called whenever the contact with another entity begins
        fixture.onBeginContact: {
            var otherEntity = other.getBody().target

            // on contact with a coin, collect it and increase score
            if (otherEntity.entityType === "coin") {
                otherEntity.collect()

                score += 1
            }
            if (otherEntity.entityType === "bean") {
                otherEntity.collect()

                score += 2
            } // on contact with a mushroom, collect it and make player big
            else if (otherEntity.entityType === "mushroom") {
                otherEntity.collect()

                // make big
                isBig = true
            } // on contact with a star, collect it and make player invincible
            else if (otherEntity.entityType === "star") {
                otherEntity.collect()

                // make invincible
                startInvincibility(starInvincibilityTime)
            } else if (otherEntity.entityType === "iceFlower") {

                //砖和花碰撞了才能收藏
                console.debug(
                            "active is " + otherEntity.isActive + " image.visible is "
                            + otherEntity.image.visible + " collected is " + otherEntity.collected
                            + " isBlockContactFlower " + otherEntity.blockContactFlower
                            + " isResetPosition " + otherEntity.isResetPosition)

                if (otherEntity.blockContactFlower) {
                    otherEntity.collect()
                }

                if (otherEntity.collected) {
                    startInvincibility(starInvincibilityTime)
                }
            } else if (otherEntity.entityType === "blockJumpOnly") {
                console.debug(
                            "collider with player and blockJump---------------")

                //玩家在砖块下面跳的时候砖块才能撞出来
                var playerHighestY = player.y + 35 //碰撞的时候人是-65
                var blockJumpLowestY = otherEntity.y + otherEntity.height //碰撞的时候砖是-160
                console.debug("playerHighestY is " + playerHighestY)
                console.debug("blockJumpLowestY is" + blockJumpLowestY)
                if (playerHighestY > blockJumpLowestY
                        && otherEntity.isResetPosition) {
                    console.debug(
                                "checkout the collider with player blockJump---------------")
                    var bx = otherEntity.x
                    var by = otherEntity.y
                    var phy = collider.linearVelocity.y
                    console.debug("collider linearVelocity y is " + phy)
                    console.debug("blockJumpOnly.x is " + bx)
                    console.debug("blockJumpOnly.y is " + by)
                    otherEntity.blockJumpOnlyJump(phy, bx, by)
                }
            }
        }

        // this is called whenever the contact with another entity changes
        fixture.onContactChanged: {
            var otherEntity = other.getBody().target

            // on contact with an opponent or spikes, call the die() function
            if (otherEntity.entityType === "opponent"
                    || otherEntity.entityType === "spikes") {
                die(false)
            }
        }
    }

    // this collider handles contacts and the killing of opponents
    BoxCollider {
        id: feetSensor

        // set and adjust size, depending on player size (big or small)
        width: 32 * parent.scale
        height: 10 * parent.scale

        // set position
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom

        // the bodyType is dynamic
        bodyType: Body.Dynamic

        // the collider should not be active in edit mode
        active: gameScene.state === "edit" ? false : true

        // Category2: player feet sensor
        categories: Box.Category2
        // Category3: opponent body, Category5: solids
        collidesWith: Box.Category3 | Box.Category5

        // this is only a sensor, so it should not physically collide
        // with any other object
        collisionTestingOnlyMode: true

        // this is called whenever the contact with another entity begins
        fixture.onBeginContact: {
            var otherEntity = other.getBody().target

            // if colliding with opponent...
            if (otherEntity.entityType === "opponent") {
                // ...calculate the lowest point of the player and
                // the opponent...
                var playerLowestY = player.y + player.height
                var oppLowestY = otherEntity.y + otherEntity.height

                // ...and if the player's y position is at least
                // 5px above the opponent's...
                if (playerLowestY < oppLowestY - 5) {
                    // ...kill opponent...
                    console.debug("kill opponent")
                    otherEntity.die()

                    // ...and jump in the air
                    startJump(false)
                }
            } // else if colliding with another solid object...
            else if (otherEntity.entityType === "platform"
                     || otherEntity.entityType === "ground"
                     || otherEntity.entityType === "blockJumpOnly") {
                // ...increase the player's contacts
                contacts++

                // if the player stands on this object...
                if (verticalVelocity >= 0)
                    // ...set doubleJumpEnabled to true again
                    doubleJumpEnabled = true
            }
        }

        // when contact ends
        fixture.onEndContact: {
            var otherEntity = other.getBody().target

            // when collision with another object ends, decrease the player's contacts
            if (otherEntity.entityType === "platform"
                    || otherEntity.entityType === "ground"
                    || otherEntity.entityType === "blockJumpOnly")
                contacts--
        }
    }

    // this sensor makes sure, that the user can't draw/create any
    // entities close to the player
    BoxCollider {
        id: editorCollider

        anchors.fill: parent

        collisionTestingOnlyMode: true

        // Category16: misc
        categories: Box.Category16
    }

    /**
   * Update timer --------------------------------------------------------
   */

    // This timer is used to slow down the players horizontal movement,
    // when the controllers xAxis is in neutral position (0).
    // The collider's linearDamping property works similar, but also
    // slows down the vertical velocity - which we don't want.
    Timer {
        id: updateTimer

        // Set this interval as high as possible to improve performance,
        // but as low as needed so it still looks good.
        interval: 60

        running: true
        repeat: true

        onTriggered: {
            var xAxis = controller.xAxis

            // if xAxis is 0 (no movement command) we slow the player down
            // until he stops
            if (xAxis == 0) {
                if (Math.abs(player.horizontalVelocity) > 10)
                    player.horizontalVelocity *= decelerationFactor
                else
                    player.horizontalVelocity = 0
            }
        }
    }

    /**
   * Invincibility ------------------------------------------------------
   */

    // this is the overlay image, that signals, that the player is invincible
    MultiResolutionImage {
        id: invincibilityOverlayImage

        source: "../../assets/player/player1/player_rainbow.png"

        opacity: 0

        // this animation fades out the incibility overlay, to signal, that
        // the invincibility will end soon
        NumberAnimation on opacity {
            id: invincibilityOverlayImageFadeOut

            // slowly reduce opacity from 1 to 0
            from: 1
            to: 0

            // duration of the animation, in ms
            duration: 500
        }
    }

    // this timer is triggered shortly before invincibility ends, to signal,
    // that it will end soon
    Timer {
        id: invincibilityWarningTimer

        onTriggered: warnInvincibility()
    }

    // as long as this timer is running, the player is invincible
    // when it is triggered, invincibility ends
    Timer {
        id: invincibilityTimer

        onTriggered: {

            endInvincibility()
            
        }
    }

    /**
   * ascentControl ------------------------------------------------------
   */

    // The ascentControl allows the player to jump higher, when pressing the
    // jump button longer, and lower, when pressing the jump button shorter.
    // It is running while the player presses the jump button.
    Timer {
        id: ascentControl

        // every 15 ms this is triggered
        interval: 15
        repeat: true

        onTriggered: {
            // If jumpForceLeft is > 0, we set the players verticalVelocity to make
            // him jump.
            if (jumpForceLeft > 0) {

                var verticalImpulse = 0

                // At the beginning of the jump we set the verticalVelocity to 0 and
                // apply a high vertical impulse, to get a high initial vertical
                // velocity.
                if (jumpForceLeft == 20) {
                    verticalVelocity = 0

                    verticalImpulse = -normalJumpForce
                } // After the first strong impulse, we only want to increase the
                // verticalVelocity slower.
                else if (jumpForceLeft >= 14) {
                    verticalImpulse = -normalJumpForce / 5
                } // Then, after about a third of our maximum jump time, we further
                // reduce the verticalImpulse.
                else {
                    verticalImpulse = -normalJumpForce / 15
                }
                // Reducing the verticalImpulse over time allows for a more precise
                // controlling of the jump height.
                // Also it gives the jump a more natural feeling, than using a constant
                // value.

                // apply the impulse
                collider.applyLinearImpulse(Qt.point(0, verticalImpulse))

                // decrease jumpForceLeft
                jumpForceLeft--
            }
        }
    }

    /**
   * Item editor -----------------------------------------
   */
    // make properties editable via itemEditor
    EditableComponent {
        editableType: "Balance"
        properties: {
      "Player" : {
        "normalJumpForce": {"min": 0, "max": 400, "stepSize": 5, "label": "Jump Force"},
        "killJumpForce": {"min": 0, "max": 1000, "stepSize": 10, "label": "Kill Jump Force"},
        "accelerationForce": {"min": 0, "max": 5000, "stepSize": 10, "label": "Acceleration"},
        "maxSpeed": {"min": 0, "max": 400, "stepSize": 5, "label": "Speed"},
        "maxFallingSpeed": {"min": 5, "max": 1000, "stepSize": 5, "label": "Max Falling Speed"}
      },
      "Power-Ups" : {
        "starInvincibilityTime": {"min": 500, "max": 10000, "stepSize": 100, "label": "Star Duration (ms)"}
      }
    }
    }

    /**
   * Game related JS functions --------------------------------------------------
   */

    // This function is called, when the user presses the jump button or, when
    // the player jumps on an opponent.
    // isNormalJump is true, when the user pressed the jump button.
    // When jumping after a kill jump, isNormalJump is false.
    function startJump(isNormalJump) {
        if (isNormalJump) {
            // when the player stands on the ground and the jump
            // button is pressed, we start the ascentControl
            if (player.state == "walking") {
                ascentControl.start()
                audioManager.playSound("playerJump")
            } // if doubleJumpEnabled, the player can also jump without
            // standing on the ground
            else if (doubleJumpEnabled) {
                ascentControl.start()
                doubleJumpEnabled = false
                audioManager.playSound("playerJump")
            }
        } else {
            // When killing an opponent, we want the player to jump
            // a little. We do that by just setting the verticalVelocity
            // to a negative value.
            verticalVelocity = -killJumpForce
        }
    }

    // this function is called, when the user releases the jump button
    function endJump() {
        // stop ascentControl
        ascentControl.stop()

        // reset jumpForceLeft
        jumpForceLeft = 20
    }

    function die(dieImmediately) {
        // if dieImmediately is true OR
        // the player is (NOT big AND NOT invincible)...
        if (dieImmediately || (!isBig && !invincible)) {
            // ...die
            audioManager.playSound("playerDie")
            gameScene.resetLevel()
        } // else if invincible...
        else if (invincible) {

            // ... don't do anything
        } // else => (!dieImmediately && !invincible && isBig)...
        else {
            // ...make player small and invincible for a short time
            isBig = false
            startInvincibility(0)

            audioManager.playSound("playerHit")
        }
    }

    function startInvincibility(interval) {
        // this is the time the player is warned, that the invincibility will
        // end soon
        var warningTime = 500

        // the interval (invincibility time) must be at least as long as the
        // warning time
        if (interval < warningTime)
            interval = warningTime

        // show invincibility overlay
        invincibilityOverlayImage.opacity = 1
        player.image.opacity = 0

        // Calculate and set time until the invincibility warning.
        // This value is at least 0.
        invincibilityWarningTimer.interval = interval - warningTime
        // start timer
        invincibilityWarningTimer.start()

        // Calculate and set time until the invincibility ends.
        // This value is at least warningTime.
        invincibilityTimer.interval = interval
        // start timer
        invincibilityTimer.start()

        // enable invincibility
        invincible = true

        audioManager.playSound("playerInvincible")

        console.debug("start invincibility; interval: " + interval)
    }

    function warnInvincibility() {
        // fade out the invincibilityOverlayImage
        invincibilityOverlayImageFadeOut.start()

        console.debug("warn invincibility")
    }

    function endInvincibility() {
        // disable invincibility again
        invincible = false
        player.image.opacity = 1

        audioManager.stopSound("playerInvincible")

        console.debug("stop invincibility")
    }

    // changes the direction in which the player looks, depending on the direction
    // he moves in
    function changeSpriteOrientation() {
        if (controller.xAxis == -1) {
            image.mirrorX = true
            invincibilityOverlayImage.mirrorX = true
        } else if (controller.xAxis == 1) {
            image.mirrorX = false
            invincibilityOverlayImage.mirrorX = false
        }
    }

    /**
   * Start position JS functions -----------------------------------------------
   */

    // every time the player is released in edit mode, we update his start position
    onEntityReleased: updateStartPosition()

    function updateStartPosition() {
        startX = x
        startY = y
    }

    // this function tries to load the start position from a saved level, or sets
    // it to a default value
    function loadStartPosition() {
        // load startX if it is saved in the current level
        if (gameWindow.levelEditor && gameWindow.levelEditor.currentLevelData
                && gameWindow.levelEditor.currentLevelData["customData"]
                && gameWindow.levelEditor.currentLevelData["customData"]["playerX"]) {
            startX = parseInt(
                        gameWindow.levelEditor.currentLevelData["customData"]["playerX"])
        } else {
            // if there is no startX saved, we set it to a default value
            startX = 32
        }

        // load startY if it is saved in the current level
        if (gameWindow.levelEditor && gameWindow.levelEditor.currentLevelData
                && gameWindow.levelEditor.currentLevelData["customData"]
                && gameWindow.levelEditor.currentLevelData["customData"]["playerY"]) {
            startY = parseInt(
                        gameWindow.levelEditor.currentLevelData["customData"]["playerY"])
        } else {
            // if there is no startY saved, we set it to a default value
            startY = -96
        }
    }


    /**
   * Init and reset JS functions -------------------------------------
   */
    function initialize() {
        // load the player's start position from the level
        loadStartPosition()

        // reset the player
        reset()

        // set PlatformerEntityBaseDraggable's lastPosition property
        lastPosition = Qt.point(x, y)
    }

    function reset() {
        // reset position
        x = startX
        y = startY

        // reset velocity
        collider.linearVelocity.x = 0
        collider.linearVelocity.y = 0

        // reset score
        score = 0

        // reset doubleJumpEnabled
        doubleJumpEnabled = true

        // reset isBig
        isBig = false

        // reset invincibility
        invincible = false
        invincibilityTimer.stop()
        invincibilityWarningTimer.stop()
        invincibilityOverlayImage.opacity = 0
        player.image.opacity = 1
        audioManager.stopSound("playerInvincible")
    }

    function resetContacts() {
        // Reset the contacts to ensure the player starts each level
        // with zero contacts.
        contacts = 0
    }
}
