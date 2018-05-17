import VPlay 2.0
import QtQuick 2.7
import "scenes"
import "common"
import ReadID 1.0


//import Login 1.0
GameWindow {
    id: gameWindow

    activeScene: menuScene

    screenWidth: 960
    screenHeight: 640

    //aliases to make levelEditor and itemEditor accessible from the outside
    property alias levelEditor: levelEditor
    property alias itemEditor: gameScene.itemEditor

    // update background music when scene changes
    onActiveSceneChanged: {
        audioManager.handleMusic()
    }

    FontLoader{
        id:superMarioFont
        source: "../assets/fonts/SuperMario256.ttf"
    }

    // level editor
    LevelEditor {
        id: levelEditor

        Component.onCompleted: levelEditor.loadAllLevelsFromStorageLocation(
                                   authorGeneratedLevelsLocation)

        toRemoveEntityTypes: ["ground", "platform", "spikes", "opponent", "coin", "mushroom", "star", "finish","iceFlower","blockJumpOnly","bean"]
        toStoreEntityTypes: ["ground", "platform", "spikes", "opponent", "coin", "mushroom", "star", "finish","iceFlower","blockJumpOnly","bean"]

        // set the gameNetwork
        gameNetworkItem: gameNetwork

        // directory where the predefined json levels are
        applicationJSONLevelsDirectory: "levels/"

        onLevelPublished: {
            // save level
            gameScene.editorOverlay.saveLevel()

            //report a dummy score, to initialize the leaderboard
            var leaderboard = levelId

            if (leaderboard) {
                gameNetwork.reportScore(100000, leaderboard, null,
                                        "lowest_is_best")
            }

            gameWindow.state = "level"
        }
    }

    AudioManager {
        id: audioManager
    }

    // the entity manager handles all our entities
    EntityManager {
        id: entityManager

        entityContainer: gameScene.container

        poolingEnabled: true
    }

    VPlayGameNetwork {
        id: gameNetwork

        // set id and secret
        gameId: 518
        secret: "se2015spark"

        // set gameNetworkView
        gameNetworkView: myGameNetworkView
    }

    // custom mario style font
    FontLoader {
        id: marioFont
        source: "../assets/fonts/SuperMario256.ttf"
    }

    // Scenes -----------------------------------------
    MenuScene {
        id: menuScene

        onLevelScenePressed: {
            gameWindow.state = "level"
            levelScene.isLevelScene = true
        }
        onPlayScenePressed: {
            gameWindow.state = "play"
            playScene.isPlayScene = true
        }
    }

    LevelScene {
        id: levelScene

        VPlayGameNetworkView {

            //这个视图包含了VPlayGameNetwork服务的所有独立视图，如排行榜、成就和用户配置
            //文件。这些是VPlayGameNetworkView中的默认视图:
            id: myGameNetworkView

            z: 1000

            anchors.fill: parent.gameWindowAnchorItem

            // invisible by default
            visible: false

            onShowCalled: {
                myGameNetworkView.visible = true
            }

            onBackClicked: {
                myGameNetworkView.visible = false
            }
        }

        onNewLevelPressed: {
            // create a new level
            var creationProperties = {
                levelMetaData: {
                    levelName: "newLevel"
                }
            }
            levelEditor.createNewLevel(creationProperties)

            // switch to gameScene, edit mode
            gameWindow.state = "game"
            gameScene.state = "edit"

            // initialize level
            gameScene.initLevel()
        }

        onPlayLevelPressed: {
            // load level
            levelEditor.loadSingleLevel(levelData)
            //            gameScene.currentLevelData = levelData

            // switch to gameScene, play mode
            gameWindow.state = "game"
            gameScene.state = "play"

            // initialize level
            gameScene.initLevel()
        }

        onEditLevelPressed: {
            // load level
            levelEditor.loadSingleLevel(levelData)

            // switch to gameScene, play mode
            gameWindow.state = "game"
            gameScene.state = "edit"

            // initialize level
            gameScene.initLevel()
        }

        onRemoveLevelPressed: {
            // load level
            levelEditor.loadSingleLevel(levelData)

            // remove loaded level
            levelEditor.removeCurrentLevel()
        }

        onBackPressed: {
            gameWindow.state = "menu"
            isLevelScene = false
        }
    }

    GameScene {
        id: gameScene

        onBackPressed: {
            // reset level
            gameScene.resetLevel()

            // switch to levelScene
            if (levelScene.isLevelScene == true)
                gameWindow.state = "level"
            else if (playScene.isPlayScene == true) {
                gameWindow.state = "play"
            }
        }
        onIsLevelFinishChanged: {
            //            if (finishLevelID < levelEditor.currentLevelName) {
            //                finishLevelID = levelEditor.currentLevelName
            //                console.debug(
            //                            "========gameScene finishLevelId changed: " + finishLevelID)
            //            }
            //            if (readid.levelID < gameScene.finishLevelID) {
            //                console.debug(
            //                            "========playScene finishLevelId changed: " + finishLevelID)
            //                readid.levelID = gameScene.finishLevelID
            //            }
            if (readid.levelID < levelEditor.currentLevelName) {
                readid.levelID = levelEditor.currentLevelName
                console.debug(
                            "========gameScene finishLevelId changed: " + readid.levelID)
            }

            playScene.finish()
            gameScene.isLevelFinish = false
            //            loginScene.login.addPassLevelNumber()
        }
    }

    ReadID {
        id: readid
        onLevelIDChanged: console.debug("====================================")
    }

    PlayScene {
        id: playScene

        finishLevelID: readid.levelID

        onBackPressed: {
            gameWindow.state = "menu"
            //            if (readid.levelID < gameScene.finishLevelID) {
            //                console.debug(
            //                            "========playScene finishLevelId changed: " + finishLevelID)
            //                readid.levelID = gameScene.finishLevelID
            //            }
        }
        onPlayLevelPressed: {
            levelEditor.loadSingleLevel(levelData)

            //            currentLevelData = levelData
            // switch to gameScene, play mode
            gameWindow.state = "game"
            gameScene.state = "play"

            // initialize level
            gameScene.initLevel()

            isPlayScene = false
        }
    }

    //    LoginScene {
    //        id: loginScene
    //    }
    state: "menu"

    // this state machine handles the transition between scenes
    states: [
        State {
            name: "menu"
            PropertyChanges {
                target: menuScene
                opacity: 1
            }
            PropertyChanges {
                target: gameWindow
                activeScene: menuScene
            }
        },
        State {
            name: "level"
            PropertyChanges {
                target: levelScene
                opacity: 1
            }
            PropertyChanges {
                target: gameWindow
                activeScene: levelScene
            }
        },
        State {
            name: "game"
            PropertyChanges {
                target: gameScene
                opacity: 1
            }
            PropertyChanges {
                target: gameWindow
                activeScene: gameScene
            }
        },
        //        State {
        //            name: "login"
        //            PropertyChanges {
        //                target: loginScene
        //                opacity: 1
        //            }
        //            PropertyChanges {
        //                target: gameWindow
        //                activeScene: loginScene
        //            }
        //        },
        State {
            name: "play"
            PropertyChanges {
                target: playScene
                opacity: 1
            }
            PropertyChanges {
                target: gameWindow
                activeScene: playScene
            }
        }
    ]
}
