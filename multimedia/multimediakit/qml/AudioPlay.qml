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
import QtMobility.gallery 1.1

/*!
 * @brief Audio Player to play audio files.
 * Play Audio files and display and control the duration
 * of the audio playback
 */
Page {
    id: audioPlayTab
    tools: commonTools

    //! locking the orientation of the page in Portrait
    orientationLock: PageOrientation.LockPortrait

    //! Property to hold the playback duration of the music file.
    property int duration: playMusic.source != "" ? audiofileselector.playduration*1000 : 0;

    //! Property to hold the playback duration of the music file in hr:min:sec format
    property string durationTime: audiofileselector.getTimeFromMSec(audiofileselector.playduration*1000)

    //! Property to hold the playback postion of the music file in hr:min:sec format
    property string positionTime: audiofileselector.getTimeFromMSec(playMusic.position)

    //! Row formation of controls for audio playing.
    Item {
        id: controls
        focus: true

        anchors {
            bottom: seekSlider.top
            bottomMargin: 100
            left: audioPlayTab.left
            leftMargin: 16
            right: audioPlayTab.right
            rightMargin: 16
        }

        //! Control icon for selecting previous media file
        ButtonHolder {
            id: backbutton
            anchors.left: parent.left
            source: "image://theme/icon-m-toolbar-mediacontrol-previous-white"

            onClicked: {
                //! Playing the media file from beginning when playback position
                //! is less than 3 seconds
                if (playMusic.position > 3000)
                    playMusic.position = 0;
                else {
                    audiofileselector.loadprevioussong();
                    playMusic.play();
                }
            }
        }

        //! control icon for media play
        ButtonHolder {
            id: playbutton
            anchors { horizontalCenter: parent.horizontalCenter }
            source: "image://theme/icon-m-toolbar-mediacontrol-play-white"

            onClicked: {
                if (playMusic.paused === true)
                    playMusic.play();
                else if ((!playMusic.playing) && ( audiofileselector.filepath !== ""))
                    playMusic.play();
                else if (playMusic.playing)
                    playMusic.pause();
            }
        }

        //! Control icon to play next media file
        ButtonHolder {
            id: nextbutton
            anchors.right: parent.right
            source: "image://theme/icon-m-toolbar-mediacontrol-next-white"

            onClicked: {
                audiofileselector.loadnextsong();
                playMusic.play();
            }
        }
    }

    //! Using QML Audio Element to play the audio content
    Audio {
        id: playMusic
        source: audiofileselector.filepath
        volume: 0.5
        playing: (audiofileselector.filepath !== "") ? true : false

        onStarted: playbutton.source = "image://theme/icon-m-toolbar-mediacontrol-pause-white"

        //! Tasks to do when media is paused
        onPaused: playbutton.source = "image://theme/icon-m-toolbar-mediacontrol-play-white"

        //! Tasks to do when media is resumed playing from a pause
        onResumed: playbutton.source = "image://theme/icon-m-toolbar-mediacontrol-pause-white"

        //! Tasks to do when media is stopped
        onStopped: {
            playbutton.source = "image://theme/icon-m-toolbar-mediacontrol-play-white"
            playMusic.playing = false;
            playMusic.position = 0;
        }
    }

    //! Audio playback progress display using a progress bar.
    Item {
        id: seekSlider

        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            leftMargin: 16
            rightMargin: 16
        }

        height: slider.height + positionTime.height

        Item {
            id: slider

            property real currentaudiopos: playMusic.position
            property real maximumaudiopos: audioPlayTab.duration

            anchors { left: parent.left; right: parent.right }
            height: 100
            width: parent.width

            MouseArea {
                id: mouseArea
                anchors.fill: parent

                property real initialaudioPos: 0
                property real initialPos: 0

                onPressed: {
                    initialPos = mouseX
                    initialaudioPos = slider.currentaudiopos
                }

                onPressedChanged: {
                    if (!pressed)
                        durationbubble.visible = false
                    else
                        durationbubble.visible = true
                }

                //! Changing the audio playback progress when the progressbar is
                //! scrolled horizontally.
                onMousePositionChanged: {
                    var target = initialaudioPos * Math.pow(16, (mouseX - initialPos)/slider.width)
                    target = Math.max(1, Math.min(target, slider.maximumaudiopos))
                    playMusic.position = target
                }
            }

            Item {
                id: durationbubble
                anchors.bottom: slider.top
                x: positionindicator.x
                visible: false

                Rectangle {
                    id: name
                    height: 30
                    width: 60
                    radius: 10

                    Text {
                        anchors.centerIn: parent
                        font { bold: true; pixelSize: 20 }
                        color: "gray"
                        text: audioPlayTab.positionTime
                    }
                }
            }

            //! Implementation of bar to display the progress level.
            Item {
                id: bar
                anchors.verticalCenter: slider.verticalCenter
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

                //! Filling for progress bar according to progress level.
                Rectangle {
                    id: filler
                    x: 0
                    y: 0
                    width: parent.width - (parent.width * (1.0 - (slider.currentaudiopos-1.0)
                                                           / (slider.maximumaudiopos-1.0)))
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
                    color: "white"
                }
            }
        }

        //! Text field to display the media playback position in hr:min:sec format
        Text {
            id: positionTime
            anchors { left: parent.left; bottom: slider.bottom; }
            font: uiConstants.FieldLabelFont
            color: "#FFFFFF"
            text: audioPlayTab.positionTime
            opacity: 0.5
        }

        //! Text field to display the media duration in hr:min:sec format
        Text {
            id: durationTime
            anchors { right: parent.right; bottom: slider.bottom;  }
            font: uiConstants.FieldLabelFont
            text: audioPlayTab.durationTime
            color: "#FFFFFF"
            opacity: 0.5
        }
    }

    //! Seperator between audio controls and audio metadata.
    Rectangle {
        id: seperator
        width: parent.width
        anchors { bottom: controls.top; bottomMargin: 40 }
        color: "#FFFFFF"
        height: 1
        opacity: 0.3
    }

    //! Item to display the Audio Metadata.
    Item {
        id: metadata

        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
            bottom: seperator.top
            margins: uiConstants.DefaultMargin
        }

        clip: true

        //! Flickable area to display the Audio metadata
        Flickable {
            id: flickable
            anchors.fill: parent
            contentHeight: audiometadata.height

            //! Column formation of text fields used to display metadata information for an audio file.
            Column {
                id: audiometadata
                spacing: 16

                Column {
                    spacing: 5

                    Label {
                        text: "Artist"
                        font: uiConstants.TitleFont
                    }

                    Label {
                        text: (playMusic.metaData.albumArtist !== undefined)
                              ? playMusic.metaData.albumArtist : "undefined"
                        font: uiConstants.SubtitleFont
                        color: rootWindow.secondaryForeground
                        width: metadata.width
                        wrapMode: Text.Wrap
                    }
                }

                Column {
                    spacing: 5

                    Label {
                        text: "Title"
                        font: uiConstants.TitleFont
                    }

                    Label {
                        font: uiConstants.SubtitleFont
                        color: rootWindow.secondaryForeground
                        width: metadata.width
                        wrapMode: Text.Wrap
                        text: (playMusic.metaData.albumTitle !== undefined)
                              ? playMusic.metaData.albumTitle : "undefined"
                    }
                }

                Column {
                    spacing: 5

                    Label {
                        text: "Audio Codec"
                        font: uiConstants.TitleFont
                    }

                    Label {
                        font: uiConstants.SubtitleFont
                        color: rootWindow.secondaryForeground
                        width: metadata.width
                        wrapMode: Text.Wrap
                        text: (playMusic.metaData.audioCodec !== undefined)
                              ? playMusic.metaData.audioCodec : "undefined"
                    }

                }

                Column {
                    spacing: 5

                    Label {
                        text: "Audio BitRate"
                        font: uiConstants.TitleFont
                    }

                    Label {
                        font: uiConstants.SubtitleFont
                        color: rootWindow.secondaryForeground
                        width: metadata.width
                        wrapMode: Text.Wrap
                        text: (playMusic.metaData.audioBitRate !== undefined)
                              ? playMusic.metaData.audioBitRate : "undefined"
                    }
                }

                Column {
                    spacing: 5

                    Label {
                        text: "Date"
                        font: uiConstants.TitleFont
                    }

                    Label {
                        font: uiConstants.SubtitleFont
                        color: rootWindow.secondaryForeground
                        width: metadata.width
                        wrapMode: Text.Wrap
                        text: (playMusic.metaData.date !== undefined) ? playMusic.metaData.date
                                                                      : "undefined"
                    }
                }

                Column {
                    spacing: 5

                    Label {
                        text: "Description"
                        font: uiConstants.TitleFont
                    }

                    Label {
                        font: uiConstants.SubtitleFont
                        color: rootWindow.secondaryForeground
                        width: metadata.width
                        wrapMode: Text.Wrap
                        text: (playMusic.metaData.description !== undefined)
                              ? playMusic.metaData.description : "undefined"
                    }
                }

                Column {
                    spacing: 5

                    Label {
                        text: "Copyright"
                        font: uiConstants.TitleFont
                    }

                    Label {
                        font: uiConstants.SubtitleFont
                        color: rootWindow.secondaryForeground
                        width: metadata.width
                        wrapMode: Text.Wrap
                        text: (playMusic.metaData.copyright !== undefined)
                              ? playMusic.metaData.copyright : "undefined"
                    }
                }

                Column {
                    spacing: 5

                    Label {
                        text: "Seekable"
                        font: uiConstants.TitleFont
                    }

                    Label {
                        font: uiConstants.SubtitleFont
                        color: rootWindow.secondaryForeground
                        width: metadata.width
                        wrapMode: Text.Wrap
                        text: (playMusic.metaData.seekable !== undefined)
                              ? playMusic.metaData.seekable : "undefined"
                    }
                }

                Column {
                    spacing: 5

                    Label {
                        text: "SampleRate"
                        font: uiConstants.TitleFont
                    }

                    Label {
                        font: uiConstants.SubtitleFont
                        color: rootWindow.secondaryForeground
                        width: metadata.width
                        wrapMode: Text.Wrap
                        text: (playMusic.metaData.sampleRate !== undefined)
                              ? playMusic.metaData.sampleRate : "undefined"
                    }
                }

                Column {
                    spacing: 5

                    Label {
                        text: "Size"
                        font: uiConstants.TitleFont
                    }

                    Label {
                        font: uiConstants.SubtitleFont
                        color: rootWindow.secondaryForeground
                        width: metadata.width
                        wrapMode: Text.Wrap
                        text: (playMusic.metaData.size !== undefined) ? playMusic.metaData.size
                                                                      : "undefined"
                    }
                }
            }
        }

        //! Scroll decorator for the flickable area
        ScrollDecorator {
            flickableItem: flickable
        }
    }

    //!  On this page status bar need to be hidden
    Component.onCompleted: rootWindow.showStatusBar = false
}

//!   End of File
