import QtQuick 2.0
import VPlay 2.0

BuildEntityButton {

    // width and height of the button
    property int buttonSize: 32

    // this property is true, when the button is selected
    property bool isSelected: false

    // set size
    width: buttonSize
    height: buttonSize

    anchors.horizontalCenter: parent.horizontalCenter

    // set initialEntityPosition to a point outside the level
    initialEntityPosition: Qt.point(-100, 0)

    // set variationType to the variationType of the createdEntity
    variationType: createdEntity ? createdEntity.variationType : ""

    // these signals are emitted when the button gets selected/unselected
    signal selected
    signal unselected

    // if this button is selected, this rectangle emphasizes this
    Rectangle {
        id: selectedRectangle

        // only visible if the button is selected
        visible: isSelected

        // make it a little larger than the actual button
        width: parent.width + 8
        height: parent.height + 8

        // center this in the button
        anchors.centerIn: parent

        radius: 3

        // set color to white
        color: "white"
    }

    // this rectangle adds a grey background to the entity image,
    // this improves the visibility of part transparent(tou ming de) entities
    Rectangle {
        //实体框的在空白部分
        id: background

        anchors.fill: buttonImage

        radius: 3

        color: "#a0b0b0b0"
    }

    // the image of the entity
    MultiResolutionImage {
        id: buttonImage

        source: createdEntity ? createdEntity.image.source : ""

        // increase buttonImage size, when button is selected
        width: isSelected ? 36 : 32
        height: isSelected ? 36 : 32

        anchors.centerIn: parent
    }

    onClicked: {
        // toggle isSelected
        isSelected = !isSelected

        // if the button is now selected, emit the selected signal
        if (isSelected)
            selected()
        else
            unselected()
    }

    onEntityWasBuilt: {
        // get built entity by it's id
        var builtEntity = entityManager.getEntityById(builtEntityId)

        // if buildEntity exists...
        if (builtEntity) {
            // ...add undoObject to undoHandler
            var undoObjectProperties = {
                target: builtEntity,
                action: "create",
                currentPosition: Qt.point(builtEntity.x, builtEntity.y)
            }
            var undoObject = editorOverlay.undoHandler.createUndoObject(
                        undoObjectProperties)
            editorOverlay.undoHandler.push([undoObject])
        }
    }
}
