import QtQuick 2.0
import VPlay 2.0
import "../editorElements"

PlatformerEntityBaseDraggable {
    id: blockJumpOnly
    entityType: "blockJumpOnly"

    width: image.width
    height: image.height

    colliderComponent: blockCollider

    image.source: "../../assets/ground/full-0.png"

    property var oldBlockX
    property var oldBlockY

    //如果砖块没有回到原来的位置，就不允许在碰撞
    property bool isResetPosition: true

    BoxCollider {
        id: blockCollider

        //        width: parent.width
        //        height: parent.height / 2

        //        anchors.horizontalCenter: parent.horizontalCenter
        anchors.fill: parent

        //        anchors.centerIn: parent
        bodyType: Body.Static

        // Category8: Block that can move
        categories: Box.Category5

        // Category1: player body, Category2: player feet sensor,
        // Category3: opponent body, Category4: opponent sensor
        collidesWith: Box.Category1 | Box.Category2 | Box.Category3 | Box.Category4 | Box.Category6

        //这里 人和砖块碰撞之后，砖块会因为惯性和花碰撞，和花碰撞的时候，速度就变成了0,然后砖块就会往下掉，不会再上升了，这里再给它赋一个速度
        fixture.onBeginContact: {
            var otherEntity = other.getBody().target

            if (otherEntity.entityType === "iceFlower") {
                blockCollider.linearVelocity.y = -240
            }
        }
    }

    function blockJumpOnlyJump(pyh, bx, by) {
        //如果player是在blackJumpONly的下方并且碰撞block,那么block就跳起来.
        //跳起来的逻辑分解为 1 让砖块升高 2 让砖块边为动态，受重力匀速下降 3 让砖块落到原来的位置 4让砖块变为静态不受重力影响
        console.debug("jump function start---------------")
        blockCollider.bodyType = Body.Dynamic
        //            blockCollider.collisionTestingOnlyMode = false
        blockCollider.linearVelocity.y = -250
        console.debug(
                    "-----------------  " + blockCollider.linearVelocity.y + " ----------")
        oldBlockX = bx
        oldBlockY = by
        isResetPosition = false
        //刚刚碰撞了要等砖块归位了才能再次碰撞
        blockTimer.start()
    }
    Timer {
        id: blockTimer
        interval: 400
        onTriggered: {
            blockJumpOnly.blockReset()
            console.debug("reset position start right now")
        }
    }
    function blockReset() {

        //                    blockJumpOnly.x = blockJumpOnly.row * gameScene.gridSize
        //                    blockJumpOnly.y = level.height - (blockJumpOnly.column + 1) * gameScene.gridSize
        console.debug("reset positon start")
        blockJumpOnly.x = oldBlockX
        blockJumpOnly.y = oldBlockY
        blockCollider.bodyType = Body.Static
        isResetPosition = true
        console.debug("reset finish")
    }
}
