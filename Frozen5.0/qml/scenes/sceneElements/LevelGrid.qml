import QtQuick 2.0
import VPlay 2.0

Item {
    id: levelGrid //关卡的显示和加载

    // anchoring
    // if state is demoLevels, the subBar is hidden, so we anchor it to the mainBar
    anchors.top: levelScene.state == "demoLevels" ? mainBar.bottom : subBar.bottom
    anchors.bottom: levelScene.gameWindowAnchorItem.bottom
    anchors.left: levelScene.left
    anchors.right: levelScene.right

    anchors.margins: 5
    anchors.topMargin: 0
    anchors.bottomMargin: 0

    // this property stores all level's meta data
    property var levelMetaDataArray

    // is true, if the levels are loading right now
    property bool isLoading: false

    onLevelMetaDataArrayChanged: {
        // if the levels are not currently loading...
        console.debug("onLevelMetaDataArrayChanged")
        if (!isLoading) {
            // ...set the levelListRepeater model to the levelMetaDataArray
            levelListRepeater.model = levelMetaDataArray
        }
    }

    Flickable {
        id: levelGridFlickable

        anchors.fill: parent

        // clip contents at item borders
        clip: true

        // set the content size to the grid's size
        contentWidth: grid.width
        // add twice the offset's height to the contentHeight, to add a little margin
        // at the top and bottom of the grid
        contentHeight: grid.height + 2 * offset.height

        // only allow vertical flicking
        flickableDirection: Flickable.VerticalFlick

        // this adds a little offset on top of the level grid
        Item {
            id: offset
            width: parent.width
            height: 5

            anchors.top: parent.top
        }

        Grid {
            id: grid

            anchors.top: offset.bottom

            columns: 4
            spacing: 10

            // the repeater adds a levelItemDelegate item for each level
            Repeater {
                id: levelListRepeater

                // delegate is the default property of Repeater
                delegate: LevelSelectionItem {
                }
            }
        }
    }

    /**
   * LOADING
   */
    Text {
        id: loadingText

        text: "Loading"

        // this text is visible while the levels are loading
        visible: isLoading

        // position
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -40

        // font family and size
        font.family: marioFont.name
        font.pixelSize: 40

        // text color
        color: "#fff833"

        // add outline
        style: Text.Outline
        styleColor: "black"
    }

    Timer {
        id: loadingTimer

        interval: 1000

        onTriggered: finishLoading()
    }

    function startLoading() {
        // remove all elements immediately to see an instant level loading screen
        levelListRepeater.model = null

        // set isLoading to true
        isLoading = true

        // delay rest to render the loading sign
        loadingTimer.start()
    }

    function finishLoading() {
        // set isLoading to false again
        isLoading = false

        // add all level elements again
        levelListRepeater.model = levelMetaDataArray
    }
}
