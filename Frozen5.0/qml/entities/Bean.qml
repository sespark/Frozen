import QtQuick 2.0
import VPlay 2.0
import "../editorElements"

PlatformerEntityBaseDraggable {
    id: bean
    entityType: "bean"

    // this property is true when the player collected the coin
    property bool collected: false //玩家吃到了

    // when the coin is collected, it shouldn't be visible anymore
    image.visible: !collected //true

    // define colliderComponent for collision detection while dragging
    colliderComponent: collider //当拖动时碰撞检测的组件

    // set image
    image.source: "../../assets/powerups/bean.png"

    CircleCollider {
        id: collider

        // make the collider a little smaller than the sprite
        radius: parent.width / 2 - 3

        // center collider
        x: 3
        y: 3

        // disable collider when coin is collected
        active: !collected //true

        // the collider is static (shouldn't move) and should only test
        // for collisions
        bodyType: Body.Static

        //这个变量决定这个实体玩家可不可以站在上面
        collisionTestingOnlyMode: true

        // Category6: powerup
        categories: Box.Category6
        // Category1: player body
        collidesWith: Box.Category1
    }

    // set collected to true
    function collect() {
        console.debug("collect bean")
        bean.collected = true

        // for every collected coin, the time gets set back a little bit
        gameScene.time -= 10

        audioManager.playSound("collectCoin")
    }

    // reset coin
    function reset() {
        bean.collected = false
    }
}
