/****************************************************************************
* This file is part of the Harmattan API Showcase Application.
*
* Copyright © 2012 Nokia Corporation and/or its subsidiary(-ies).  
* All rights reserved.
*
* This software, including documentation, is protected by copyright
* controlled by Nokia Corporation.  All rights reserved.  You are 
* entitled to use this file in accordance with the Harmattan API
* Showcase Application Agreement.
*
****************************************************************************/

import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.gallery 1.1
import QtMultimediaKit 1.1
import com.nokia.harmattanapishowcase 1.0

/*!
 * @brief File Selector for Video Player
 * Display list of Video files along with corresponding video
 * duration and pause thumbnails
 */
Page {
    id: videofileselector
    //! Using common tools from main.qml
    tools: commonTools

    //! property holding the file path to Video file to be played
    property string filepath;

    //! Signal emitted when video file picker page is closed.
    signal fileselectorclosed;

    //! property holding the status of the orientation of the page
    property bool isPortrait: videofileselector.width > videofileselector.height ? false : true

    //!  Making new component and pushing created page to the stack.
    function openFile(file) {
        var component = Qt.createComponent(file)

        if (component.status === Component.Ready)
            pageStack.push(component);
        else
            console.log("Error loading component:", component.errorString());
    }

    //! Signal handler to open the Video play view, when file video picker is closed
    onFileselectorclosed: openFile("VideoPlay.qml")

    //! Text to display when no video files exist on the device
    Text {
        id: blankscreentext
        text: "No videos"
        font.pixelSize: 40

        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }

        visible: (gridview.count === 0)
        color: "white"
    }


    //!Grid view to display the Video files present on the device
    GridView {
        id: gridview

        anchors {
            fill: parent
            top: parent.top
            left: parent.left
            leftMargin: isPortrait ? 0 : 70
        }

        cellWidth: 150
        cellHeight: 150

        //! Work around to avoid page overlap if the pages are of different themes or colors.
        visible: ( rootWindow.pageStack.depth !== 1) ? true : false

        //! Using the Document gallery model to get a list of Video files present
        //! on the device
        model: DocumentGalleryModel {
            id: foldermodel
            rootType: DocumentGallery.Video
            properties: ["artist", "title", "filePath", "duration","favourite","url"]
            sortProperties: ["artist", "title"]
        }

        //! Delegate for the video file picker grid view
        delegate: Item {
            width: 150
            height: 150

            //! Using galleryitem request to get metadata details of specific media file
            DocumentGalleryItem {
                id: song
                item: itemId

                properties: [
                    "title",
                    "artist",
                    "albumTitle",
                    "albumArtist",
                    "genre",
                    "duration",
                    "trackNumber",
                    "coverArtUrlLarge"
                ]
            }

            //! Thumbnails display of video files present on the device.
            Image {
                id: videothumbnail
                property string albumUrl: song.available
                                          ? thumbnailutility.getVideothumbnailPath(model.url) : ""

                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                source: albumUrl !== "" ? albumUrl : "image://theme/icon-m-music-video-all-songs"

                //! Mouse area covering the video thumbnails in the gridview
                //! When clicked assigns the current item as current index of gridview and
                //! stores the file path of the current item.
                MouseArea {
                    id: mouseArea
                    anchors.fill: videothumbnail

                    onClicked: {
                        gridview.currentIndex = index;
                        videofileselector.filepath = model.filePath;
                        videofileselector.fileselectorclosed();
                    }
                }
            }

            //! Title of the media file displayed in thumbnail
            Text {
                id: name
                width: parent.width
                text: (model.title === "") ? "Unknown Title" : model.title
                anchors { top:parent.top; left: parent.left;  topMargin: 5 ; leftMargin: 5 }
                font: uiConstants.FieldLabelFont
                color: uiConstants.FieldLabelColor
                wrapMode: Text.WrapAnywhere
                elide: Text.ElideRight
                maximumLineCount: 1
            }

            //! Thumbnail image to be displayed in the grid view of the video file picker
            Image {
                id: durationbackground
                source: "image://theme/meegotouch-video-duration-background"
                width: (duration.width > 66) ? 90 : 66

                anchors {
                    right: videothumbnail.right
                    bottom: videothumbnail.bottom
                    bottomMargin: 5
                    rightMargin: 5
                }

                //! Text label to be displayed on the image
                //! Display the duration of the media file
                Label {
                    id: duration

                    anchors {
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }

                    text: (getTimeFromMSec(model.duration*1000)) === ""
                          ? "0:00" : (getTimeFromMSec(model.duration*1000))
                    color: "#FFFFFF"
                }
            }
        }
    }

    /*!
     * Converts milliseconds to minutes and seconds format.
     *
     * Used to display duration and time remaining while playing audio
     * files.
     */
    function getTimeFromMSec(msec) {
        if (msec <= 0 || msec === undefined) {
            return ""
        } else {
            var sec = "" + Math.floor(msec / 1000) % 60
            if (sec.length === 1)
                sec = "0" + sec

            var hour = Math.floor(msec / 3600000)

            if (hour < 1) {
                return Math.floor(msec / 60000) + ":" + sec
            } else {
                var min = "" + Math.floor(msec / 60000) % 60

                if (min.length === 1)
                    min = "0" + min

                return hour + ":" + min + ":" + sec
            }
        }
    }

    //! Instantiating ThumbnailUtility class
    ThumbnailUtility { id: thumbnailutility }

    //!  On this page status bar need to be hidden
    Component.onCompleted: rootWindow.showStatusBar = false;
    Component.onDestruction: rootWindow.showStatusBar = true
}

//! End of File
