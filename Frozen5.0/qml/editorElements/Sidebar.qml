import QtQuick 2.0
import VPlay 2.0
import "../common"

MultiResolutionImage {
    id: sidebar
    // 实体显示框

    // holds the currently active tool
    // can be draw", "erase", "hand"
    // by default this is "hand"
    property string activeTool: "hand"

    // properties to access gameScene elements
    property var bgImage
    property var grid
    property var undoHandler

    // this property holds all BuildEntityButtons
    // we use this in the unselectAllButtonsButOne() function
    property var buttons: [groundButton, ground2Button, platformButton, spikeballButton, spikesButton, opponentJumperButton, opponentWalkerButton, coinButton, mushroomButton, starButton, finishButton]

    // aliases to allow access from outside
    property alias gridSizeButton: gridSizeButton

    z: 100 // make sure the sidebar is above all other elements on the screen

    // set size
    width: 100
    height: editorOverlay.height

    anchors.top: editorOverlay.top
    anchors.left: editorOverlay.left

    // set image source
    source: "../../assets/ui/sidebar.png"

    // sidebar column for layout
    Item {
        anchors.fill: parent
        anchors.margins: 4

        Row {
            id: undoRedo

            width: parent.width
            height: 30

            anchors.top: parent.top
            anchors.left: parent.left

            spacing: 2

            property int buttonWidth: width / 2 - spacing / 2

            // undo button
            PlatformerImageButton {
                width: parent.buttonWidth

                image.source: undoHandler.pointer
                              >= 0 ? "../../assets/ui/undo.png" : "../../assets/ui/undo_grey.png"

                // hide hoverRectangle, when undo isn't possible
                hoverRectangle.visible: undoHandler.pointer >= 0 ? true : false

                onClicked: undoHandler.undo()
            }

            // redo button
            PlatformerImageButton {
                width: parent.buttonWidth

                // set image to colored if redo is possible, otherwise
                // to grey
                image.source: undoHandler.pointer < undoHandler.undoArray.length
                              - 1 ? "../../assets/ui/redo.png" : "../../assets/ui/redo_grey.png"

                // hide hoverRectangle, when redo isn't possible
                hoverRectangle.visible: undoHandler.pointer
                                        < undoHandler.undoArray.length - 1 ? true : false

                onClicked: undoHandler.redo()
            }
        }

        Row {
            id: tools

            width: parent.width
            height: 30

            anchors.top: undoRedo.bottom
            anchors.left: parent.left
            anchors.topMargin: 4

            spacing: 2

            property int buttonWidth: width / 2 - spacing / 2

            PlatformerSelectableImageButton {
                id: drawEraseButton

                // this property holds if draw is active
                // if draw is not active this means, that erase is active
                property bool drawActive: true

                width: parent.buttonWidth
                height: parent.height

                // display image, depending on if draw is active or not
                image.source: drawActive ? "../../assets/ui/drawActive.png" : "../../assets/ui/eraseActive.png"

                onClicked: {
                    // if this button is selected, switch between draw and erase mode
                    if (isSelected) {
                        drawActive = !drawActive
                    } // otherwise unselect the handButton and select this button else {
                    handButton.isSelected = false
                    isSelected = true

                    // update the activeTool
                    updateActiveTool()

                    // if the draw mode is activated and there is no BuildEntityButton
                    // selected yet...
                    if (drawActive && editorOverlay.selectedButton == null) {
                        // ...switch to the first entity group...
                        changeActiveEntityGroup(1)

                        // ...and select the groundButton
                        selectBuildEntityButton(groundButton)
                    }
                }
            }

            PlatformerSelectableImageButton {
                id: handButton

                width: parent.buttonWidth
                height: parent.height

                image.source: "../../assets/ui/hand.png"

                isSelected: true

                onClicked: {
                    // if this button is not selected unselect the drawEraseButton and select this button
                    if (!isSelected) {
                        drawEraseButton.isSelected = false
                        isSelected = true
                    }

                    // update the activeTool
                    updateActiveTool()
                }
            }
        }

        // entity groups
        // with these buttons the user can change the currently shown group
        // of entities
        Row {
            id: entityGroups

            width: parent.width
            height: 30

            anchors.top: tools.bottom
            anchors.left: parent.left
            anchors.topMargin: 4

            spacing: 2

            // the active entity group
            property int activeGroup: 1

            // set button width
            // Divide sidebar width by three. Then subtract a third of the total spacing.
            // Since there are 3 buttons, the total spacing is 2 * spacing.
            property int buttonWidth: width / 3 - spacing * 2 / 3

            ItemGroupButton {
                image.source: "../../assets/ui/entityGroups/empty.png"

                selected: entityGroups.activeGroup == 1

                onClicked: changeActiveEntityGroup(1)
            }

            ItemGroupButton {
                image.source: "../../assets/ui/entityGroups/group2.png"

                selected: entityGroups.activeGroup == 2

                onClicked: changeActiveEntityGroup(2)
            }

            ItemGroupButton {
                image.source: "../../assets/ui/entityGroups/group3.png"

                selected: entityGroups.activeGroup == 3

                onClicked: changeActiveEntityGroup(3)
            }
        }

        // this is the flickable component, where all buildEntityButtons are
        Flickable {
            // 设置的选项里的按钮
            id: buildFlickable

            width: parent.width

            anchors.top: entityGroups.bottom
            anchors.bottom: optionsButton.top
            anchors.left: parent.left
            anchors.topMargin: 4
            anchors.bottomMargin: 4

            // size of the flickable content
            contentWidth: width
            contentHeight: buildColumn.height

            // set margins
            topMargin: 5
            bottomMargin: 5

            // clip the content on the boundaries
            clip: true

            // we only want to allow vertical flicking
            flickableDirection: Flickable.VerticalFlick //滑动的方向

            // pressDelay delays the delivery of the press event to the buildEntityButtons.
            // This allows the user to flick this Flickable, even when pressing on a buildEntityButton.
            pressDelay: 100

            // build entity buttons
            Column {
                id: buildColumn

                // set size
                width: parent.width

                spacing: 5

                /**
         * Editor options --------------------------------
         */

                // this item holds the level name as text and a button to change it
                Item {
                    id: levelNameItem

                    width: parent.width
                    height: 30

                    visible: entityGroups.activeGroup == 0

                    // this text displays the current level name
                    Text {
                        // set text to level name, if it exists
                        text: levelEditor.currentLevelName ? levelEditor.currentLevelName : ""

                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.right: nameLevelButton.left
                        anchors.rightMargin: 4

                        // align text in the vertical center
                        verticalAlignment: Text.AlignVCenter

                        // make font size dynamic
                        fontSizeMode: Text.Fit
                        font.pixelSize: 13
                        minimumPixelSize: 7
                    }

                    // change level name button
                    PlatformerImageButton {
                        id: nameLevelButton

                        image.source: "../../assets/ui/edit_black.png"

                        width: 30
                        height: parent.height

                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom

                        onClicked: {
                            // when we click this button, we show a native text input dialog
                            nativeUtils.displayTextInput(
                                        "Enter levelName",
                                        "Enter a level name. (max 15 characters)",
                                        "", levelEditor.currentLevelName)
                        }

                        // this listens for the end of the native text input dialog
                        Connections {
                            target: nativeUtils

                            onTextInputFinished: {
                                // if the text input dialog is closed
                                // and the user clicked "ok"
                                if (accepted) {
                                    //如果输入关卡名无效，弹出错误对话框

                                    // the text can't be longer than 9 characters
                                    if (enteredText.length > 15) {
                                        nativeUtils.displayMessageBox(
                                                    "Invalid level name",
                                                    "A maximum of 15 characters is allowed!")
                                        return
                                    }

                                    // change level name
                                    levelEditor.currentLevelName = enteredText
                                }
                            }
                        }
                    }
                }

                // change-background-image buttons
                Row {
                    id: backgroundButtons

                    width: parent.width
                    height: 30

                    visible: entityGroups.activeGroup == 0

                    spacing: 2

                    // set button width; subtract half of spacing, to make buttons fit
                    property int buttonWidth: width / 3 - spacing * 2 / 3

                    // with these three buttons the user can change the background image
                    PlatformerImageButton {
                        width: parent.buttonWidth

                        image.source: bgImage.bg0
                        image.fillMode: Image.PreserveAspectCrop

                        onClicked: bgImage.bg = 0
                    }

                    PlatformerImageButton {
                        width: parent.buttonWidth

                        image.source: bgImage.bg1
                        image.fillMode: Image.PreserveAspectCrop

                        onClicked: bgImage.bg = 1
                    }

                    PlatformerImageButton {
                        width: parent.buttonWidth

                        image.source: bgImage.bg2
                        image.fillMode: Image.PreserveAspectCrop

                        onClicked: bgImage.bg = 2
                    }
                }

                // grid options
                Item {
                    id: gridOptions

                    width: parent.width
                    height: 30

                    visible: entityGroups.activeGroup == 0

                    // label
                    Text {
                        height: parent.height

                        anchors.top: parent.top
                        anchors.left: parent.left

                        text: "GridSize:"
                        font.pixelSize: 12

                        // align text in the vertical center
                        verticalAlignment: Text.AlignVCenter
                    }

                    // button to switch between gridSizes 16 and 32
                    PlatformerTextButton {
                        id: gridSizeButton

                        screenText: "32"

                        width: 30
                        height: parent.height

                        anchors.top: parent.top
                        anchors.right: parent.right

                        // alternate gridSizes 16 and 32 when clicking this button
                        onClicked: {
                            if (screenText == "32") {
                                screenText = "16"
                                editorOverlay.scene.gridSize = 16
                            } else {
                                screenText = "32"
                                editorOverlay.scene.gridSize = 32
                            }
                        }
                    }
                }

                // publish button
                PlatformerTextButton {
                    id: publishButton

                    screenText: "Publish"

                    width: parent.width
                    height: 30

                    visible: entityGroups.activeGroup == 0

                    onClicked: {
                        // open publish dialog
                        publishDialog.opacity = 1
                    }
                }

                /**
         * BuiltEntityButtons -------------------------------- // 跟实体关联
         */
                PlatformerBuildEntityButton {
                    id: groundButton

                    // each button is only visible, if the corresponding
                    // entity group is active
                    visible: entityGroups.activeGroup == 1

                    // path to the entity type of the entity, which should be created
                    toCreateEntityTypeUrl: "../entities/GroundGrass.qml"

                    // handle selection and unselection of this button
                    onSelected: selectBuildEntityButton(this)
                    onUnselected: unselectBuildEntityButton()
                }

                PlatformerBuildEntityButton {
                    id: ground2Button

                    visible: entityGroups.activeGroup == 1

                    toCreateEntityTypeUrl: "../entities/GroundDirt.qml"

                    onSelected: selectBuildEntityButton(this)
                    onUnselected: unselectBuildEntityButton()
                }

                PlatformerBuildEntityButton {
                    id: platformButton

                    visible: entityGroups.activeGroup == 1

                    toCreateEntityTypeUrl: "../entities/Platform.qml"

                    onSelected: selectBuildEntityButton(this)
                    onUnselected: unselectBuildEntityButton()
                }

                PlatformerBuildEntityButton {
                    id: blockJumpOnlyButton

                    visible: entityGroups.activeGroup == 1

                    toCreateEntityTypeUrl: "../entities/BlockJumpOnly.qml"

                    onSelected: selectBuildEntityButton(this)
                    onUnselected: unselectBuildEntityButton()
                }

                PlatformerBuildEntityButton {
                    id: spikeballButton

                    visible: entityGroups.activeGroup == 1

                    toCreateEntityTypeUrl: "../entities/Spikeball.qml"

                    onSelected: selectBuildEntityButton(this)
                    onUnselected: unselectBuildEntityButton()
                }

                PlatformerBuildEntityButton {
                    id: spikesButton

                    visible: entityGroups.activeGroup == 1

                    toCreateEntityTypeUrl: "../entities/Spikes.qml"

                    onSelected: selectBuildEntityButton(this)
                    onUnselected: unselectBuildEntityButton()
                }

                PlatformerBuildEntityButton {
                    id: opponentJumperButton

                    visible: entityGroups.activeGroup == 2

                    toCreateEntityTypeUrl: "../entities/OpponentJumper.qml"

                    onSelected: selectBuildEntityButton(this)
                    onUnselected: unselectBuildEntityButton()
                }

                PlatformerBuildEntityButton {
                    id: opponentWalkerButton

                    visible: entityGroups.activeGroup == 2

                    toCreateEntityTypeUrl: "../entities/OpponentWalker.qml"

                    onSelected: selectBuildEntityButton(this)
                    onUnselected: unselectBuildEntityButton()
                }

                PlatformerBuildEntityButton {
                    id: coinButton

                    visible: entityGroups.activeGroup == 3

                    toCreateEntityTypeUrl: "../entities/Coin.qml"

                    onSelected: selectBuildEntityButton(this)
                    onUnselected: unselectBuildEntityButton()
                }
                PlatformerBuildEntityButton {
                    id: beanButton

                    visible: entityGroups.activeGroup == 3

                    toCreateEntityTypeUrl: "../entities/Bean.qml"

                    onSelected: selectBuildEntityButton(this)
                    onUnselected: unselectBuildEntityButton()
                }

                PlatformerBuildEntityButton {
                    id: mushroomButton

                    visible: entityGroups.activeGroup == 3

                    toCreateEntityTypeUrl: "../entities/Mushroom.qml"

                    onSelected: selectBuildEntityButton(this)
                    onUnselected: unselectBuildEntityButton()
                }

                PlatformerBuildEntityButton {
                    id: starButton

                    visible: entityGroups.activeGroup == 3

                    toCreateEntityTypeUrl: "../entities/Star.qml"

                    onSelected: selectBuildEntityButton(this)
                    onUnselected: unselectBuildEntityButton()
                }
                PlatformerBuildEntityButton {
                    id: iceFlowerButton

                    visible: entityGroups.activeGroup == 3

                    toCreateEntityTypeUrl: "../entities/IceFlower.qml"

                    onSelected: selectBuildEntityButton(this)
                    onUnselected: unselectBuildEntityButton()
                }

                PlatformerBuildEntityButton {
                    id: finishButton

                    visible: entityGroups.activeGroup == 3

                    toCreateEntityTypeUrl: "../entities/Finish.qml"

                    onSelected: selectBuildEntityButton(this)
                    onUnselected: unselectBuildEntityButton()
                }
            }
        }

        // options button
        ItemGroupButton {
            id: optionsButton

            width: 30
            height: 25

            anchors.bottom: parent.bottom
            anchors.right: parent.right

            image.source: "../../assets/ui/options.png"

            selected: entityGroups.activeGroup == 0

            onClicked: changeActiveEntityGroup(0)
        }
    }

    /**
   * JS FUNCTIONS
   */
    // handle the selection of a BuildEntityButton
    function selectBuildEntityButton(button) {
        // if active tool is erase, change to draw
        if (activeTool == "erase") {
            setActiveTool("draw")
        }

        // unselect all other buttons, select this button
        unselectAllButtonsButOne(button)
    }

    // handle the unselection of a BuildEntityButton
    function unselectBuildEntityButton() {
        // if active tool is draw or erase, change to hand
        if (activeTool == "draw" || activeTool == "erase") {
            setActiveTool("hand")
        }

        // reset selectedButton to null
        editorOverlay.selectedButton = null
    }

    // unselects all PlatformerBuildEntityButtons
    function unselectAllButtons() {
        for (var i = 0; i < buttons.length; i++) {
            buttons[i].isSelected = false
        }

        // reset selectedButton to null
        editorOverlay.selectedButton = null
    }

    // unselects all buttons but one
    function unselectAllButtonsButOne(button) {
        // unselect all buttons
        unselectAllButtons()

        if (button) {
            // select given button
            button.isSelected = true

            // set selectedButton to this button
            editorOverlay.selectedButton = button
        }
    }

    function changeActiveEntityGroup(newGroup) {
        // if group isn't already selected...
        if (entityGroups.activeGroup !== newGroup) {
            // ...change active entity group
            entityGroups.activeGroup = newGroup
        }
    }

    // this function updates the activeTool property depending on which button is active
    function updateActiveTool() {
        if (drawEraseButton.isSelected) {
            if (drawEraseButton.drawActive) {
                activeTool = "draw"
            } else {
                activeTool = "erase"
            }
        } else if (handButton.isSelected) {
            activeTool = "hand"
        } else {
            activeTool = ""
        }
    }

    // this function sets the activeTool to the given tool parameter
    // also it selects the respective button/button mode
    function setActiveTool(tool) {
        if (tool === "draw") {
            handButton.isSelected = false
            drawEraseButton.isSelected = true
            drawEraseButton.drawActive = true
        } else if (tool === "erase") {
            handButton.isSelected = false
            drawEraseButton.isSelected = true
            drawEraseButton.drawActive = false
        } else if (tool === "hand") {
            drawEraseButton.isSelected = false
            handButton.isSelected = true
        }

        updateActiveTool()
    }

    // reset the sidebar
    function reset() {
        // unselect all buttons
        unselectAllButtons()

        // set active entity group to 1
        changeActiveEntityGroup(1)

        // reset drawEraseButton's drawActive property to true
        drawEraseButton.drawActive = true
    }
}
