import QtQuick 2.0
import VPlay 2.0

Canvas {
  id: grid

  // grid properties
  property real gridSize: editorOverlay.scene.gridSize * container.scale
  property string gridColor: "white"

  // the container, that is holding the grid
  property var container

  // Binding x and y makes the grid follow the position of the container.
  // Since the level size is unlimited, we can't draw the grid over the
  // whole level. So we just let it cover the gameWindow/editorOverlay.
  x: {
    if(container) {
      // The x position of the grid is: container x modulo the gridSize
      return (container.x % gridSize)
    }
    else {
      return 0
    }
  }
  y: {
    if(container) {
      // see above
      return (container.y % gridSize) - gridSize
    }
    else {
      return 0
    }
  }

  // The grid should cover the whole level. These values are calculated by:
  // + the editorOverlay width/height
  // + gridSize; we need a gridSize px buffer to cover the whole screen, while moving the camera around
  width: editorOverlay.width + gridSize
  height: editorOverlay.height + gridSize

  // we request paint in the beginning and everytime the gridSize is changed
  onPaint: drawGrid()

  function drawGrid()
  {
    var context = getContext("2d");

    // clear canvas
    context.clearRect(0, 0, grid.width, grid.height)

    // init drawing context and set properties
    context.beginPath()
    context.lineWidth = 0.4 * container.scale;
    context.strokeStyle = gridColor

    // put level size in variables, for better readability
    var xSize = grid.width
    var ySize = grid.height

    // vertical grid lines
    for(var x = 0; x*gridSize < xSize; x++)
    {
      context.moveTo(x*gridSize, 0)
      context.lineTo(x*gridSize, ySize)
    }

    // horizontal grid lines
    for(var y = 0; y*gridSize < ySize; y++)
    {
      context.moveTo(0, y*gridSize)
      context.lineTo(xSize, y*gridSize)
    }

    // draw and close
    context.stroke()
    context.closePath()
  }
}
