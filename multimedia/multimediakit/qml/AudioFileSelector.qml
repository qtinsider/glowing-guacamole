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
import Qt.labs.folderlistmodel 1.0
import QtMobility.gallery 1.1
import com.nokia.harmattanapishowcase 1.0

/*!
 * @brief File Selector for Audio Player
 * Display list of Audio files along with corresponding audio
 * duration and album thumbnails
 */
Page {
    id: audiofileselector

    //! Locking the page orientation as Portrait
    orientationLock: PageOrientation.LockPortrait

    //! Using common tools from main.qml
    tools: commonTools

    //! Signal emitted when file picker page is closed.
    signal fileselectorclosed;

    //! property holding the audio file duration
    property int playduration;

    //! property holding the audio file path to Music file to be played
    property string filepath;

    //! Making new component and pushing created page to the stack.
    function openFile(file) {
        var component = Qt.createComponent(file)
 
        if (component.status === Component.Ready)
            pageStack.push(component);
        else
            console.log("Error loading component:", component.errorString());
    }

    //! Signal handler to open the Audio play view.
    onFileselectorclosed: openFile("AudioPlay.qml")

    //! Text to display when no Music file exist on the device
    Text {
        id: blankscreentext
        text: "No music"
        font.pixelSize: 40

        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }

        visible: (folderlistview.count === 0)
        color: "white"
    }

    //*! List view to display the Audio files present on the device
    ListView {
        id: folderlistview
        height: audiofileselector.height
        width: audiofileselector.width
        clip: true

        //! Work around to avoid page overlap if the pages are of different themes or colors.
        visible: (rootWindow.pageStack.depth !== 1) ? true : false

        //! Using the Document gallery model to get a list of Audio files present
        //! on the device
        model: foldermodel

        //! Delegate for the audio file picker grid view
        delegate:  Item {
            id: listItem
            height: 100
            width: audiofileselector.width

            //! Get details of requested item from document gallery.
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
                    "coverArtUrlLarge",
                    "itemUrl"
                ]
            }

            //! Image displayed when an listview item is selected.
            BorderImage {
                id: background

                anchors { fill: parent; leftMargin: -audiofileselector.anchors.leftMargin;
                          rightMargin: -audiofileselector.anchors.rightMargin }
                visible: mouseArea.pressed
                source: "image://theme/meegotouch-list-inverted-background-pressed-center"
            }

            //!  Row formation of listview item consisting of album cover image, title, album name
            //!  and duration of the song
            Row {
                id: audiofileinfo
                anchors.centerIn: parent
                spacing: 6

                Image {
                    id: albumimage
                    property url albumUrl: song.available
                                           ? thumbnailutility.getAlbumArtThumbnailUrl(
                                                 model.artist, model.albumTitle)
                                           : ""

                    width: 64
                    height: 64
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    source: albumUrl !== "" ? albumUrl
                                           : "image://theme/icon-m-content-audio-inverse"
                }

                //!  Column to display the song title and album name and duration of the song
                Column {

                    //! Text field to display the song title
                    Label {
                        id: mainText
                        text: (model.title === "") ? "Unknown Title" : model.title
                        width: listItem.width - 150
                        font: uiConstants.TitleFont
                        wrapMode: Text.Wrap
                        elide: Text.ElideRight
                        maximumLineCount: 2
                    }

                    Item {
                        id: subduration
                        width: 400
                        height: 20

                        //! Text field to display the album title
                        Text {
                            id: subtext1
                            property string albumtitle: ( model.albumTitle === "" )
                                                        ? "" : " | " + model.albumTitle

                            anchors {
                                left: parent.left
                                right: durationtext.left
                                rightMargin: 10
                            }

                            text: (model.artist === "") ? "Unknown Artist"
                                                        : model.artist + albumtitle
                            font: uiConstants.SubtitleFont
                            color: uiConstants.FieldLabelColor
                            wrapMode:Text.Wrap
                            elide: Text.ElideRight
                            maximumLineCount: 1
                        }

                        //! Text field to display the duration of the song.
                        Text {
                            id: durationtext
                            anchors.right: parent.right
                            text: (getTimeFromMSec(model.duration*1000)) === ""
                                  ? "0:00" : (getTimeFromMSec(model.duration*1000))
                            font: uiConstants.SubtitleFont
                            color: uiConstants.FieldLabelColor
                            maximumLineCount: 1
                        }
                    }

                }
            }

            //! Mouse area covering every single selected listview item
            //! When clicked assign the item as current item and store file path
            MouseArea {
                id: mouseArea
                anchors.fill: background

                onClicked: {
                    folderlistview.currentIndex = index;
                    filepath = model.filePath;
                    audiofileselector.fileselectorclosed();
                    audiofileselector.playduration = model.duration;
                }

                onReleased: background.visible = false;
            }
        }

        //! Set title property as song title
        section.property: "title"

        //! Display only the first character of the section name
        section.criteria: ViewSection.FirstCharacter

        //! Delegate for the section
        section.delegate: Item {
            id: textblock
            width: folderlistview.width
            height: sectionlabel.height

            //!  Section separator image
            Image {
                anchors {
                    right: sectionlabel.left
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                    rightMargin: 20
                }

                source: "image://theme/meegotouch-groupheader"
                        + (theme.inverted ? "-inverted" : "") + "-background"
            }

            //! Text field to display the Section name
            Text {
                id: sectionlabel
                property string name: section
                opacity: 0.5

                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: 20
                }

                color: uiConstants.FieldLabelColor
                font: uiConstants.GroupHeaderFont
                text: name.toUpperCase()
            }
        }
    }

    //! Using QML DocumentGalleryModel Element to lists the Music files
    //! present in the device.
    DocumentGalleryModel {
        id: foldermodel
        autoUpdate: true
        rootType: DocumentGallery.Audio
        properties: ["artist", "title", "filePath", "duration", "albumArtist", "albumTitle"]
        sortProperties: ["title"]
    }

    //! Converts milliseconds to minutes and seconds format.
    //! Used to display duration and time remaining while playing audio files.
    function getTimeFromMSec(msec) {
        if (msec <= 0 || msec === undefined)
            return ""
        else {
            var sec = "" + Math.floor(msec / 1000) % 60
            if (sec.length === 1)
                sec = "0" + sec

            var hour = Math.floor(msec / 3600000)

            if (hour < 1)
                return Math.floor(msec / 60000) + ":" + sec
            else {
                var min = "" + Math.floor(msec / 60000) % 60

                if (min.length === 1)
                    min = "0" + min

                return hour + ":" + min + ":" + sec
            }
        }
    }

    //! Function to load the previous song in the playlist.
    function loadprevioussong() {
        if (folderlistview.currentIndex > 0) {
            audiofileselector.filepath =
                    folderlistview.model.get(folderlistview.currentIndex - 1).filePath
            audiofileselector.playduration =
                    folderlistview.model.get(folderlistview.currentIndex - 1).duration;
            folderlistview.currentIndex = folderlistview.currentIndex - 1
        } else {
            audiofileselector.filepath =
                    folderlistview.model.get(folderlistview.count - 1).filePath;
            audiofileselector.playduration =
                    folderlistview.model.get(folderlistview.count - 1).duration;
            folderlistview.currentIndex = folderlistview.count - 1
        }
    }

    //! Function to load the successive song in the playlist.
    function loadnextsong() {
        if (folderlistview.currentIndex < (folderlistview.count -1)) {
            audiofileselector.filepath =
                    folderlistview.model.get(folderlistview.currentIndex + 1).filePath
            audiofileselector.playduration =
                    folderlistview.model.get(folderlistview.currentIndex + 1).duration;
            folderlistview.currentIndex = folderlistview.currentIndex + 1
        } else {
            audiofileselector.filepath = folderlistview.model.get(0).filePath;
            audiofileselector.playduration = folderlistview.model.get(0).duration;
            folderlistview.currentIndex = 0;
        }
    }

    //! Section scroller
    SectionScroller {
        id: scroller
        listView: folderlistview
    }

    //! Instantiate
    ThumbnailUtility{
        id: thumbnailutility
    }

    //! On this page status bar need to be hidden
    Component.onCompleted: rootWindow.showStatusBar = false
    Component.onDestruction: rootWindow.showStatusBar = true
}

//! End of File
