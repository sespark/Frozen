import QtQuick 2.0
import VPlay 2.0
import "../editorElements"

PlatformerEntityBaseDraggable {
    id: iceFlower
    entityType: "iceFlower"

    property bool collected: false
    //判断砖块是否和花碰撞，这个影响花是否可见、是否可收藏
    property bool blockContactFlower: false
    //判断花和跳跳砖是否刚撞，必须要花回到原位才能再次撞击，花是否要跳
    property bool isResetPosition: true

    property bool isActive: collider.active

    property var oldBlockX
    property var oldBlockY

    //    property alias iceFlowerVisible: image.visible

    //撞了砖块之后才出现花，出现花的时候没有收藏，收藏了也看不见
    //被收藏了就看不见了
    image.visible: scene.state
                   === "edit" ? true : blockContactFlower ? collected ? false : true : false
    image.source: "../../assets/powerups/ice_flower.png"

    colliderComponent: collider

    CircleCollider {
        id: collider
        radius: parent.width / 2 - 1
        x: 1
        y: 1

        //一般和visble联系，看不见了碰撞器就为不活跃，不活跃就是碰撞也没用吗？
        active: !collected
        bodyType: Body.Static

        //这行代码很重要吗,即使是动态，也不受重力影响，保持和静态一样，玩家也不可站在上面
        collisionTestingOnlyMode: true
        categories: Box.Category6
        collidesWith: Box.Category1 | Box.Category5

        fixture.onBeginContact: {
            var otherEntity = other.getBody().target

            if (otherEntity.entityType === "blockJumpOnly") {
                console.debug(
                            "collider with iceFlower and blockJump---------------")

                if (!collected) {
                    iceFlower.image.visible = true
                    collisionTestingOnlyMode = false
                    iceFlower.blockContactFlower = true
                }

                if (isResetPosition) {
                    oldBlockX = iceFlower.x
                    oldBlockY = iceFlower.y
                    iceFlowerJump()
                    //如果花被吃了就不会发生碰撞了吧，active都为假了，谁还撞啊
                }
                console.debug(
                            "active is " + isActive + " image.visible is "
                            + iceFlower.image.visible + " collected is " + collected
                            + " isBlockContactFlower " + blockContactFlower
                            + " isResetPosition " + isResetPosition)
            }
        }
    }

    function collect() {
        console.debug("collect iceFlower")
        if (iceFlower.image.visible) {
            collider.collisionTestingOnlyMode = true
            iceFlower.collected = true
            iceFlower.image.visible = false
            //感觉这一行也多余
        }
    }

    //function reset() {}
    function iceFlowerJump() {
        //如果player是在blackJumpONly的下方并且碰撞block,那么block就跳起来.
        //跳起来的逻辑分解为 1 让砖块升高 2 让砖块边为动态，受重力匀速下降 3 让砖块落到原来的位置 4让砖块变为静态不受重力影响
        console.debug("flower began higher --------")
        collider.bodyType = Body.Dynamic

        collider.linearVelocity.y = -252
        console.debug(
                    "ice flower phy is " + collider.linearVelocity.y + " -------")
        isResetPosition = false
        //刚刚碰撞了要等砖块归位了才能再次碰撞
        blockTimer.start()
    }
    Timer {
        id: blockTimer
        interval: 400
        onTriggered: {
            iceFlower.blockReset()
            console.debug("flower return back right now -------------")
        }
    }
    function blockReset() {
        iceFlower.x = oldBlockX
        iceFlower.y = oldBlockY
        collider.bodyType = Body.Static
        isResetPosition = true
        console.debug("flower reset finish")
    }

    function reset() {
        //玩家死了之后，以前的碰撞作废
        iceFlower.blockContactFlower = false
        iceFlower.collected = false
        iceFlower.isResetPosition = true
        collider.collisionTestingOnlyMode = true

        //必须要写这个条件来表示花的可见性，靠24行初始化是要出问题的。大概24行太复杂？
        if (scene.state == "edit") {
            iceFlower.image.visible = true
            console.debug("1-----------")
        } else {
            if (iceFlower.blockContactFlower) {
                if (iceFlower.collected) {
                    iceFlower.image.visible = false
                    console.debug("2-----------")
                } else {
                    iceFlower.image.visible = true
                    console.debug("3-----------")
                }
            } else {
                iceFlower.image.visible = false
                console.debug("4-----------")
            }
        }
    }
}
