// handles the clicking of an entity
function clickEntity(entity) {
  // remove entity if activeTool is erase
  if(sidebar.activeTool == "erase") {
    var undoObject = removeEntity(entity);

    // if entity was removed, push undoObject to undoHanlder
    if(undoObject)
      undoHandler.push([undoObject]);
  }
}

// if entity is removable: remove entity and return the undoObject of this action
function removeEntity(entity) {
  // if entity is removable
  if(!entity.preventFromRemovalFromEntityManager) {
    // create and add a new undoObject to the undoHandler
    var undoObjectProperties = {"target": entity, "action": "remove",
      "currentPosition": Qt.point(entity.x, entity.y)};
    var undoObject = undoHandler.createUndoObject(undoObjectProperties);

    // then remove it
    entityManager.removeEntityById(entity.entityId);

    audioManager.playSound("removeEntity");

    // return the created undoObject
    return undoObject;
  }
}

// returns the top-left coordinate of the grid the mouse is in
function getMouseGridPos(mouseX, mouseY) {
  // convert screen to level coordinates
  var mouseInLevel = mouseToLevelCoordinates(mouseX, mouseY);
  // snap mouse coordinates to grid
  var snappedMousePos = snapToGrid(mouseInLevel.x, mouseInLevel.y);

  return snappedMousePos;
}

// This function checks, if there is a body in the 32x32 area
// below/right the position parameter. We use this to make sure
// there isn't already an entity at the position where we want
// to create a new one.
// The position parameter is the top-left point of the checked
// area.
// Returns true, if there is a body in this area;
// false else.
function isBodyIn32Grid(position) {
  // Check at 4 different positions
  var pos1 = Qt.point(position.x + 8, position.y + 8);
  var pos2 = Qt.point(position.x + 8, position.y + 24);
  var pos3 = Qt.point(position.x + 24, position.y + 8);
  var pos4 = Qt.point(position.x + 24, position.y + 24);

  if(physicsWorld.bodyAt(pos1) !== null) return true;
  if(physicsWorld.bodyAt(pos2) !== null) return true;
  if(physicsWorld.bodyAt(pos3) !== null) return true;
  if(physicsWorld.bodyAt(pos4) !== null) return true;

  // if there's no body at any of the 4 positions, return false
  return false;
}

// place a new object and return it
function placeEntityAtPosition(mouseX, mouseY) {
  // don't place object, if mouse is left of or below the level
  if(mouseX < 100 || mouseY > editorOverlay.scene.gameWindowAnchorItem.height)
    return;

  // if there is no button selected, return
  if(selectedButton === null)
    return;

  // get the mouse's grid position
  var mouseGridPos = getMouseGridPos(mouseX, mouseY);

  // if there's body at the current mouse position, return
  if(isBodyIn32Grid(mouseGridPos))
    return;

  // set object properties
  var properties = {};

  console.debug("selectedButton.createdEntity", selectedButton.createdEntity);
  // variation type
  properties.variationType = selectedButton.createdEntity.variationType;
  // position properties
  // get level coordinates from mouse position
  var levelCoords = mouseToLevelCoordinates(mouseX, mouseY);
  // snap level coordinates to grid
  var pos = snapToGrid(levelCoords.x, levelCoords.y);
  properties.x = pos.x;
  properties.y = pos.y;
  properties.visible = true;

  // create entity
  var entityId = entityManager.createEntityFromUrlWithProperties(selectedButton.toCreateEntityTypeUrl, properties);

  // get created entity
  var entity = entityManager.getEntityById(entityId);

  // debug output with placed entity and position
  console.debug("Placed entity "+entity+" at "+entity.x+", "+entity.y);

  audioManager.playSound("createOrDropEntity");

  // return created entitiy
  return entity;
}

// converts mouse coordinates to level coordinates
// return point with level coordinates
function mouseToLevelCoordinates(mouseX, mouseY) {
  var realX = (mouseX - containerComponent.x) / camera.zoom;
  var realY = (mouseY - containerComponent.y) / camera.zoom;

  return Qt.point(realX, realY);
}

// calculates the grid coordinates of the grid the position (levelX, levelY) is in
function snapToGrid(levelX, levelY) {
  // get the grid position of the grid cell the point is in
  var gridPositionX = Math.floor(levelX / gridSize);
  var gridPositionY = Math.floor(levelY / gridSize);

  // convert the grid position to coordinates
  var newX = gridPositionX * gridSize;
  var newY = gridPositionY * gridSize;

  return Qt.point(newX, newY);
}

// saves the current level
function saveLevel() {
  // initialize save properties
  var saveProperties = {levelMetaData: {}, customData: {}};

  // save level name
  saveProperties.levelMetaData.levelName = levelEditor.currentLevelName;

  // save current background
  saveProperties.customData.background = bgImage.bg;

  // save player's position
  saveProperties.customData.playerX = player.x;
  saveProperties.customData.playerY = player.y;

  // execute save
  gameWindow.levelEditor.saveCurrentLevel(saveProperties);
}

function initEditor() {
  // reset grid
  editorOverlay.scene.gridSize = 32;
  sidebar.gridSizeButton.screenText = "32";

  // reset undoHandler
  undoHandler.reset();

  // reset sidebar
  sidebar.reset();
}

function resetEditor() {
  // reset activeTool to hand
  editorOverlay.sidebar.setActiveTool("hand");
}
