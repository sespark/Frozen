import QtQuick 2.0
import VPlay 2.0

Item {
  id: undoHandler

  // the array, which holds all undoObjects
  property var undoArray: []

  // the pointer, which points at the current position in the
  // undoArray
  property int pointer: -1

  onPointerChanged: console.debug("undo pointer: "+pointer)

  // create a new undoObject with a set of properties
  function createUndoObject(properties) {
    // create UndoObject component
    var component = Qt.createComponent("../undo/UndoObject.qml")

    // create object in gameScene with properties
    var undoObject = component.createObject(gameScene, properties)

    return undoObject
  }

  // add new undoObject to array
  function push(undoObjectList) {
    // before adding a new undoObject, all actions higher than the
    // pointer are removed
    if(undoArray.length > pointer + 1)
      undoArray.splice(pointer+1, undoArray.length)

    // add undoObjectList as element to undoArray
    undoArray.push(undoObjectList)

    // update pointer
    pointer++
  }

  // undo action where pointer points at
  function undo() {
    // if the pointed at undoObject exists...
    if(undoArray[pointer]) {

      // ...undo all actions in this entry
      for(var i=0; i<undoArray[pointer].length; i++) {
        undoArray[pointer][i].undo()
      }

      // update pointer
      pointer--
    }
    else {
      console.debug("nothing to undo")
    }
  }

  // redo action next to where pointer points at
  function redo() {
    // if the undoObject next to the pointed at undoObject exists...
    if(undoArray[pointer+1]) {

      // ...redo all actions in this entry
      for(var i=0; i<undoArray[pointer+1].length; i++) {
        undoArray[pointer+1][i].redo()
      }

      // update pointer
      pointer++
    }
    else {
      console.debug("nothing to redo")
    }
  }

  // print all array elements
  function printArray() {
    console.debug("print undoArray")
    for(var i=0; i< undoArray.length; i++) {
      for(var j=0; j<undoArray[i].length; j++) {
        console.debug(i+"-"+j+": "+undoArray[i][j].target+", "+undoArray[i][j].action+", "+undoArray[i][j].otherPosition+", "+undoArray[i][j].currentPosition)
      }
    }
  }

  // reset undoHandler
  function reset() {
    undoArray = []
    pointer = -1
  }

}
