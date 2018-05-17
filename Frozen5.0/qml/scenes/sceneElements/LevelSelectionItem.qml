import QtQuick 2.0
import VPlay 2.0
import "../../common"

Item {
    id: levelSelectionItem

    // 社区界面的关卡显示样子（每个关卡显示有星星，下载，名字，编号等）,
    //用户创建的，社区的，下载的，本地JSON文件,发布的,不同类型的关卡显示的不同的样子
    property bool isDownloaded: levelEditor.isLevelDownloaded(modelData.levelId)
    property bool isAuthorCreated: modelData.storageLocation == "authorGenerated"
    property bool isPublished: modelData.publishedLevelId !== undefined
    property bool isRated: modelData.rating !== undefined
    property bool isUserLevel: modelData.storageLocation === levelEditor.userGeneratedLevelsLocation
    property bool isLoggedInPlayer: (modelData && modelData.user
                                     && modelData.user.id
                                     === gameNetwork.user.userId) ? true : false

    // information visibility
    property bool ratingAndDownloadedVisible: levelScene.state == "communityLevels"

    // button visibility
    property bool playButtonVisible: levelScene.state != "demoLevels"
                                     && levelScene.state != "communityLevels"
    property bool demoPlayButtonVisible: levelScene.state == "demoLevels"
    property bool editButtonVisible: levelScene.state == "myLevels"
                                     && levelScene.subState == "createdLevels"
                                     && !isPublished
    property bool removeButtonVisible: levelScene.state == "myLevels"
                                       && levelScene.subState == "createdLevels"
                                       && !isPublished
    property bool unpublishButtonVisible: isAuthorCreated && isPublished
    property bool leaderboardButtonVisible: levelScene.state == "myLevels"
                                            && levelScene.subState == "downloadedLevels"
                                            || isAuthorCreated && isPublished
    property bool downloadButtonVisible: levelScene.state == "communityLevels"
                                         && !levelEditor.isLevelDownloaded(
                                             modelData.levelId)
                                         && !(isUserLevel && isLoggedInPlayer)
    property bool rateButtonVisible: levelScene.state == "communityLevels"
                                     && isDownloaded

    // define the size
    width: 110
    // set height, depending on if there's a user, whose name should be displayed
    height: modelData.user ? 70 : 65

    // this is the base rectangle in the background
    Rectangle {
        width: parent.width
        height: parent.height

        border.width: 1
        border.color: "black"
        radius: 3

        // background gradient
        gradient: {
            // all downloaded levels, and all self-published levels in the
            // communityLevels view, have this downloadedGradient as background
            if (isDownloaded && !isAuthorCreated || isUserLevel
                    && isLoggedInPlayer)
                return downloadedGradient
            // all self created and published levels in the myLevels view, have this
            // publishedGradient as background
            else if (isAuthorCreated && isPublished)
                return publishedGradient
            // by default, defaultGradient is the background
            else
                return defaultGradient
        }

        Gradient {
            id: defaultGradient
            GradientStop {
                position: 0.0
//                color: "#cccccc"
               color: "#cce6ff"
            }
            GradientStop {
                position: 0.5
//                color: "#e0e0e0"
                color: "#cce6ff"
            }
            GradientStop {
                position: 1.0
//                color: "#cccccc"
                color: "#cce6ff"

            }
        }

        Gradient {
            id: downloadedGradient
            GradientStop {
                position: 0.0
                color: "#67e667"
            }
            GradientStop {
                position: 0.5
                color: "#8cff8c"
            }
            GradientStop {
                position: 1.0
                color: "#67e667"
            }
        }

        Gradient {
            id: publishedGradient
            GradientStop {
                position: 0.0
                color: "#e6e667"
            }
            GradientStop {
                position: 0.5
                color: "#ffff8c"
            }
            GradientStop {
                position: 1.0
                color: "#e6e667"
            }
        }
    }

    /**
   * INFORMATION
   */

    // level name
    Text {
        id: levelName
        text: modelData.levelName

        height: 16

        // position and size
        anchors.top: parent.top
        anchors.right: removeButton.left
        anchors.left: parent.left
        // margins
        anchors.margins: 5
        anchors.bottomMargin: 0

        // make font size dynamic
        fontSizeMode: Text.Fit
        font.pixelSize: 13
        font.family: superMarioFont.name
        minimumPixelSize: 8
    }

    // user name
    Text {
        id: userName

        // if user name exists, display it
        text: modelData.user ? modelData.user.name : ""

        height: 5

        // anchoring
        anchors.top: levelName.bottom
        anchors.right: removeButton.left
        anchors.left: parent.left
        // margins
        anchors.margins: 5
        anchors.topMargin: 0

        font.pixelSize: 8
    }

    MultiResolutionImage {
        id: ratingIcon

        visible: ratingAndDownloadedVisible

        width: 15
        height: 15

        anchors.left: parent.left
        anchors.bottom: downloadedIcon.top
        anchors.leftMargin: 5

        source: "../../../assets/ui/star.png"
    }

    Text {
        id: ratingText

        visible: ratingAndDownloadedVisible

        height: ratingIcon.height

        anchors.left: ratingIcon.right
        anchors.verticalCenter: ratingIcon.verticalCenter
        anchors.leftMargin: 2

        verticalAlignment: Text.AlignVCenter

        font.pixelSize: 10

        text: {
            // if rating exists, round it and set it as text
            if (modelData["average_quality"]) {
                var rating = modelData["average_quality"]
                var roundedRating = Math.round(rating * 10) / 10
                return "" + roundedRating
            } // otherwise set 0 as text else
            return "0"
        }
    }

    MultiResolutionImage {
        id: downloadedIcon

        visible: ratingAndDownloadedVisible

        width: 15
        height: 15

        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 5

        source: "../../../assets/ui/download.png"
    }

    Text {
        id: downloadedText

        visible: ratingAndDownloadedVisible

        height: downloadedIcon.height

        anchors.left: downloadedIcon.right
        anchors.verticalCenter: downloadedIcon.verticalCenter
        anchors.leftMargin: 2

        verticalAlignment: Text.AlignVCenter

        font.pixelSize: 10

        text: modelData["times_downloaded"] ? modelData["times_downloaded"] : "0"
    }

    /**
   * BUTTONS
   */

    // button to start the level
    PlatformerImageButton {
        id: playButton

        visible: playButtonVisible

        width: 50
        height: 30

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 2

        image.source: "../../../assets/ui/play2.png"

        // start level
        onClicked: {
            levelScene.playLevelPressed(modelData)

            audioManager.playSound("start")
        }
    }

    // a wider button to start a demo level
    PlatformerImageButton {
        id: demoPlayButton

        visible: demoPlayButtonVisible

        height: 30

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 2

        image.source: "../../../assets/ui/play2.png"

        // start level
        onClicked: {
            levelScene.playLevelPressed(modelData)

            audioManager.playSound("start")
        }
    }

    // button to edit the level
    PlatformerImageButton {
        id: editButton

        visible: editButtonVisible

        width: 50
        height: 30

        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 2

        image.source: "../../../assets/ui/edit.png"

        // edit level
        onClicked: levelScene.editLevelPressed(modelData)
    }

    // button to remove the level
    PlatformerImageButton {
        id: removeButton

        visible: removeButtonVisible

        width: 30
        height: 20

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 2

        image.source: "../../../assets/ui/remove2.png"

//        color: "#ff9999"

        onClicked: {
            // show removeLevelDialog
            removeLevelDialog.levelData = modelData
            removeLevelDialog.opacity = 1
        }
    }

    // button to unpublish the level
    PlatformerImageButton {
        id: unpublishButton

        visible: unpublishButtonVisible

        width: 30
        height: 20

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 2

        image.source: "../../../assets/ui/remove2.png"

//        color: "#ff9999"

        onClicked: {
            // show unpublishDialog
            unpublishDialog.levelData = modelData
            unpublishDialog.opacity = 1
        }
    }

    // button to show the leaderboard for this level
    PlatformerImageButton {
        id: leaderboardButton

        visible: leaderboardButtonVisible

        width: 50
        height: 30

        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 2

        image.source: "../../../assets/ui/leaderboard.png"

        onClicked: {
            // id only exists in published levels
            var leaderboard = modelData.id

            // if modelData doesn't have an id, check if it has publishedLevelId
            if (!leaderboard)
                leaderboard = modelData.publishedLevelId

            // if level is published...
            if (leaderboard) {
                // ...show leaderboard
                gameNetwork.showLeaderboard(leaderboard)
            }
        }
    }

    // button to download the level
    PlatformerImageButton {
        id: downloadButton

        visible: downloadButtonVisible

        width: 40
        height: 35

        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 2

        image.source: "../../../assets/ui/download.png"

        onClicked: levelEditor.downloadLevel(modelData)
    }

    // button to rate this level
    PlatformerImageButton {
        id: rateButton

        visible: rateButtonVisible

        // disable this button, if this level has been rated
        enabled: !isRated

        width: 40
        height: 35

        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 2

        image.source: {
            // if the level hasn't been rated yet, show rate image
            if (!isRated) {
                "../../../assets/ui/rate.png"
            } // otherwise show the user's rating else {
            switch (modelData.rating.quality) {
            case 5:
                return "../../../assets/ui/rate_5stars.png"
            case 4:
                return "../../../assets/ui/rate_4stars.png"
            case 3:
                return "../../../assets/ui/rate_3stars.png"
            case 2:
                return "../../../assets/ui/rate_2stars.png"
            default:
                return "../../../assets/ui/rate_1star.png"
            }
        }
        onClicked: {
            // set level data and show rating dialog
            ratingDialog.levelData = modelData
            ratingDialog.opacity = 1
        }
    }
}
