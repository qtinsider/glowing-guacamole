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
import QtMultimediaKit 1.1

/*!
 * @brief Video Player to play video files.
 * Play Video files and display and control the duration
 * of the video playback
 */
Page {
    id: videoplaytab
    tools: videotools

    //! Locking the page orientation as Landscape
    orientationLock: PageOrientation.LockLandscape

    //! Deleting page margins
    anchors.margins: 0

    //! Set initial state
    state: "ShowToolbar"

    //! property holding the duration of the Video to be played
    property int duration: video.source !== "" ? video.duration : 0

    //! property holding the duration of the Video to be played in hr:min:sec format
    property string durationTime: video.source !== "" ? getTimeFromMSec(video.duration) : ""

    //! property holding the playback position of the Video playing in hr:min:sec format
    property string positionTime: getTimeFromMSec(video.position)

    //! Two states defined to show the hide the toolbar while playing a video.
    //! Control full screen video playing.
    states: [
        State {
            name: "ShowToolbar"
            StateChangeScript {
                script: {
                    showToolBar = true
                    viewmetadata.forceActiveFocus()
                }
            }
        },
        State {
            name: "HideToolbar"
            StateChangeScript {
                script: {
                    showToolBar = false
                }
            }
        }
    ]

    //! Transition between the defined states.
    transitions: [
        Transition {
            from: "ShowToolbar"; to: "HideToolbar"
            PropertyAnimation { target: viewmetadata; property: "opacity"; to: 0; duration: 500 }
        },
        Transition {
            from: "HideToolbar"; to: "ShowToolbar"
            PropertyAnimation { target: viewmetadata; property: "opacity"; to: 0.8; duration: 500 }
        }
    ]

    /*!
     * Using QML Video Element for playing video files.
     * Aegis permissions GRP::pulse-access and GRP::video required to be set
     */
    Video {
        id: video
        x: 0; y: 0

        //! Fill the complete screen with video
        anchors.fill: parent

        //! assining the filepath as video source file.
        source: videofileselector.filepath

        //! Preserve the aspect of the video when filling to the screen
        fillMode: "PreserveAspectFit"
        focus: true

        //! Mouse area covering the video screen
        //! When clicked switch between the states to show and hide toolbar.
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (videoplaytab.state === "HideToolbar")
                    videoplaytab.state = "ShowToolbar"
                else
                    videoplaytab.state  = "HideToolbar"
            }
        }

        //! Text field to display error message in case of error in video playback
        Text {
            id: errortext
            color: "darkgray"
            visible: false
            font: uiConstants.FieldLabelFont
            anchors { left: parent.left; leftMargin: 20; top: parent.top; topMargin: 50 }
            text:video.errorString
        }

        //! On started playing video file
        onStarted: playbutton.iconSource = "image://theme/icon-m-toolbar-mediacontrol-pause-white"


        //! On stopped playing video file
        onStopped: {
            playbutton.iconSource = "image://theme/icon-m-toolbar-mediacontrol-play-white"
            videoplaytab.state = "ShowToolbar"
            video.playing = false
            video.position = 0
        }

        //! On pausing video file
        onPaused: playbutton.iconSource = "image://theme/icon-m-toolbar-mediacontrol-play-white"

        //! On resuming playback of video file from pause
        onResumed: playbutton.iconSource = "image://theme/icon-m-toolbar-mediacontrol-pause-white"

        //! In case of an error
        onError: {
            videoplaytab.state = "ShowToolbar"
            errortext.text = video.errorString
            errortext.visible = true
        }
    }

    //! Item to display the Video Metadata.
    Rectangle {
        id: viewmetadata
        color: "#A9A9A9"
        opacity: 0.8
        anchors.right: parent.right
        width: 400
        height: parent.height

        //! Flickable area to display metadata of video file
        Flickable {
            id: metadataflickable
            flickableDirection: Flickable.VerticalFlick

            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
                right: parent.right
                margins: 16
            }

            width: metadatacolumn.width
            contentWidth: metadatacolumn.width
            contentHeight: metadatacolumn.height

            //! Column to display metadata of video file
            Column {
                id: metadatacolumn
                spacing: 8

                Label {
                    text: "<b>Artist:</b> " + video.metaData.albumArtist
                    color: "black"
                    font: uiConstants.BodyTextFont
                    wrapMode: Text.WordWrap
                }                
                Label {
                    color: "black"
                    font: uiConstants.BodyTextFont
                    wrapMode: Text.WordWrap
                    text: "<b>Title:</b> " + video.metaData.title
                }
                Label {
                    color: "black"
                    font: uiConstants.BodyTextFont
                    wrapMode: Text.WordWrap
                    text: "<b>Video codec:</b> " + video.metaData.videoCodec
                }
                Label {
                    color: "black"
                    font: uiConstants.BodyTextFont
                    wrapMode: Text.WordWrap
                    text: "<b>Video bit rate:</b> " + video.metaData.videoBitRate
                }
                Text {
                    color: "black"
                    font: uiConstants.BodyTextFont
                    wrapMode: Text.WordWrap
                    text: "<b>Video frame rate:</b> " + video.metaData.videoFrameRate
                }
                Label {
                    color: "black"
                    font: uiConstants.BodyTextFont
                    wrapMode: Text.WordWrap
                    text: "<b>Audio codec:</b> " + video.metaData.audioCodec
                }
                Label {
                    color: "black"
                    font: uiConstants.BodyTextFont
                    wrapMode: Text.WordWrap
                    text: "<b>Audio bit rate:</b> " + video.metaData.audioBitRate
                }
                Label {
                    color: "black"
                    font: uiConstants.BodyTextFont
                    wrapMode: Text.WordWrap
                    text: "<b>Date:</b> " + video.metaData.date
                }
                Label {
                    color: "black"
                    font: uiConstants.BodyTextFont
                    wrapMode: Text.WordWrap
                    text: "<b>Description:</b> " + video.metaData.description
                }
                Label {
                    color: "black"
                    font: uiConstants.BodyTextFont
                    wrapMode: Text.WordWrap
                    text: "<b>Copyright:</b> " + video.metaData.copyright
                }
                Label {
                    color: "black"
                    font: uiConstants.BodyTextFont
                    wrapMode: Text.WordWrap
                    text: "<b>Seekable:</b> " + video.seekable
                }
            }
        }
    }

    /*!
      * Custom toolbar for video playback view contains the video playback controls
      *  and playback progress display
      */
    ToolBarLayout {
        id: videotools

        ToolIcon {
            id: backbutton
            iconSource: "image://theme/icon-m-toolbar-back-landscape-white"

            onClicked: {
                video.stop()
                pageStack.pop()
            }
        }

        ToolIcon {
            id: playbutton
            anchors { left: backbutton.right; leftMargin: 20 }
            iconSource: "image://theme/icon-m-toolbar-mediacontrol-play-white"
            onClicked: {
                if ((video.paused === true) && (video.error === 0)) {
                    video.play();
                } else if ((!video.playing) && ( videofileselector.filepath !== "")
                         && (video.error === 0 )) {
                    video.play();
                } else if (video.playing)
                    video.pause();
            }
        }

        //! Progress bar displaying the video playback position.
        //! Display time stamps for video position and duration of the video.
        Item {
            id: seekSlider
            anchors { left: playbutton.right; leftMargin: 20; top: parent.top }
            width: 640
            height: 60

            Text {
                id: positionTime
                anchors { left: seekSlider.left; bottom: seekSlider.bottom; bottomMargin: 5 }
                color: "white"
                font: uiConstants.BodyTextFont
                text: videoplaytab.positionTime
                opacity: 0.6
            }

            Text {
                id: durationTime
                anchors { right: seekSlider.right; bottom: seekSlider.bottom; bottomMargin: 5 }
                color: "white"
                font: uiConstants.BodyTextFont
                text: videoplaytab.durationTime
                opacity: 0.6
            }

            Item {
                id: slider
                property real currentvideopos: video.position
                property real maximumvideopos: video.duration

                anchors { top: seekSlider.top; right: seekSlider.right; topMargin: 5; left: seekSlider.left }
                height: seekSlider.height
                width: parent.width

                MouseArea {
                    id : mouseArea
                    anchors.fill: parent

                    property real initialvideoPos : 0
                    property real initialPos : 0

                    onPressed: {
                        initialPos = mouseX
                        initialvideoPos = slider.currentvideopos
                    }

                    //! Changing the video playback progress when the progressbar
                    //! is scrolled horizontally.
                    onMousePositionChanged: {
                        if (pressed) {
                            var target = initialvideoPos
                                    * Math.pow(16, (mouseX - initialPos)/slider.width);
                            target = Math.max(1, Math.min(target, slider.maximumvideopos))
                            video.position = target
                        }
                    }
                }

                //! Implementation of bar to display the progress level.
                Item {
                    id: bar
                    anchors { top: slider.top; topMargin: 5 }
                    width: slider.width
                    height: 8
                    opacity: 1

                    //! Border for progress bar.
                    Rectangle {
                        anchors.fill: parent
                        smooth: true
                        radius: 8
                        border { color: "black"; width: 2 }
                        color: "white"
                        opacity: 0.3
                    }

                    //! Filling for progress bar according to video playback progress level.
                    Rectangle {
                        id: filler
                        x: 0
                        y: 0
                        width: parent.width - (parent.width * (1.0 - (slider.currentvideopos-1.0)
                                                               / (slider.maximumvideopos-1.0)))
                        height: parent.height
                        smooth: true
                        radius: 8
                        color: "#1B6796"
                        opacity: 0.5
                    }

                    Rectangle {
                        id: positionindicator
                        anchors { left: filler.right; verticalCenter: filler.verticalCenter }
                        visible: (filler.visible === true) ? true : false
                        height: (filler.height)/2
                        width: height
                        radius: 8
                        color:"white"
                    }
                }
            }
        }
    }

    //!  On this page status bar need to be hidden
    Component.onCompleted: rootWindow.showStatusBar = false
}

//! End of File
