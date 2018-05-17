import QtQuick 2.0
import VPlay 2.0

Item {
  id: undoObject

  // the affected object
  property var target

  // for re-creation of entity
  property var targetEntityType
  property var targetVariationType

  // the executed action
  // "create", "remove" or "move"
  property string action

  // the object's current position
  property point currentPosition

  // the object's other position (only used for "move")
  property point otherPosition

  // when the target is set, we save it's entity- and variationType
  onTargetChanged: {
    if(target !== null) {
      targetEntityType = target.entityType
      targetVariationType = target.variationType
    }
  }

  /**
   * Undo, Redo ----------------------------------------
   */

  // undo this action
  function undo() {
    if(action == "create") {
      console.debug("undo create "+target+", at "+currentPosition)

      // remove entity
      removeTargetObject()
    }
    else if(action == "remove") {
      console.debug("undo remove "+target+", at "+currentPosition)

      // re-create the removed object
      createTargetObject()
    }
    else if(action == "move") {
      console.debug("undo move "+target+", from "+otherPosition
                    +" to "+currentPosition)

      // undo move
      moveTargetObject()
    }
    else {
      console.debug("unknown action: "+action)
    }
  }

  // redo this action
  function redo() {
    if(action == "create") {
      console.debug("redo create "+target+", at "+currentPosition)

      // re-create the previously removed object
      createTargetObject()
    }
    else if(action == "remove") {
      console.debug("redo remove "+target+", at "+currentPosition)

      // re-remove entity
      removeTargetObject()
    }
    else if(action == "move") {
      console.debug("redo move "+target+", from "+otherPosition
                    +" to "+currentPosition)

      // redo move
      moveTargetObject()
    }
    else {
      console.debug("unknown action: "+action)
    }
  }

  // create a new object with targetEntityType and
  // targetVariationType
  function createTargetObject() {
    // set properties
    var properties = {
      entityType: targetEntityType,
      variationType: targetVariationType,
      x: currentPosition.x,
      y: currentPosition.y
    }
    // create object from properties and store entityId
    var newEntityId = entityManager.createEntityFromEntityTypeAndVariationType(properties)

    // set freshly created entity as new target
    target = entityManager.getEntityById(newEntityId)
  }

  // remove a previously created object
  function removeTargetObject() {
      // get the object in the grid of currentPosition, and make it the new target
      var bodyAtPos = Qt.point(currentPosition.x + 16, currentPosition.y + 16)
      target = gameScene.physicsWorld.bodyAt(bodyAtPos).target

      // if the target now exists, remove it
      if(target) {
        entityManager.removeEntityById(target.entityId)
      }
  }

  // move the target from currentPosition to otherPosition
  function moveTargetObject() {
    // look for object at currentPosition
    var bodyAtPos = Qt.point(currentPosition.x + 16, currentPosition.y + 16)
    target = gameScene.physicsWorld.bodyAt(bodyAtPos).target

    // if the target now exists, remove it
    if(target) {
      // set position to otherPosition
      target.x = otherPosition.x
      target.y = otherPosition.y

      // set the entities lastPosition property
      target.lastPosition = Qt.point(target.x, target.y)

      // switch currentPosition and otherPosition
      var helper = Qt.point(currentPosition.x, currentPosition.y)
      currentPosition = otherPosition
      otherPosition = helper
    }
  }

}
