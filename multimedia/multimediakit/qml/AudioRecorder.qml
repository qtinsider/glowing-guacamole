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
import com.nokia.extras 1.0
import QtMultimediaKit 1.1
import com.nokia.harmattanapishowcase 1.0

/*!
 * @brief Audio Recorder Class to record audio through input devices
 * Record audio through input devices and playback the recorder audio
 * Controls provided to pause, stop and play recorded audio files.
 */
Page {
    id: audiorecpage

    //! Locking the page orientation as Portrait
    orientationLock: PageOrientation.LockPortrait

    //! Using common tools from main.qml
    tools: commonTools

    //! Property to hold the playback duration of the music file.
    property int duration: playMusic.source !== "" ? playMusic.duration : 0

    //! Property to hold the playback duration of the music file in hr:min:sec format
    property string durationTime: getTimeFromMSec(playMusic.duration)

    //! Property to hold the playback postion of the music file in hr:min:sec format
    property string positionTime: getTimeFromMSec(playMusic.position)

    property int recStatus: 0

    state: "Initialstate"

    //! Two states defined to show the hide the toolbar while playing a video.
    //! Control full screen video playing.
    states:[
        State {
            name: "Initialstate"
            StateChangeScript {
                script: {
                    seekSlider.visible = false;
                    recduration.opacity = 0.5;
                    recpausebutton.visible = false;
                    recduration.text = "0:00"
                    recordimg.source = "icons/record_icon.png"
                }
            }
        },
        State {
            name: "RecordingStopped"
            StateChangeScript {
                script: {
                    seekSlider.visible = false;
                    recduration.opacity = 0.5;
                    recpausebutton.visible = false;
                    recduration.text = "0:00"
                    playbutton.visible = true;
                    recordimg.source = "icons/record_icon.png"
                }
            }
        },
        State {
            name: "Recording"
            StateChangeScript {
                script: {
                    recduration.visible = true;
                    seekSlider.visible = false;
                    recduration.opacity = 1.0;
                    recpausebutton.visible = true;
                    playbutton.visible = false;
                    recordimg.source = "image://theme/icon-m-toolbar-mediacontrol-stop-white"
                }
            }
        },
        State {
            name: "Playing"
            StateChangeScript {
                script: {
                    recduration.visible = false;
                    seekSlider.visible = true;
                    playMusic.source = rec.getFileName();
                }
            }
        },
        State {
            name: "RecordingPaused"
            StateChangeScript {
                script: {
                    recpausebutton.visible = false;
                    recordimg.source = "icons/record_icon.png"
                    playbutton.visible = false;
                }
            }
        }
    ]

    //! Display audio recording and playing controls in a column
    Item {
        //! Work around to avoid page overlap if the pages are of different themes or colors.
        visible: (rootWindow.pageStack.depth !== 1) ? true : false
        anchors.bottom: parent.bottom
        width: parent.width
        height: 200

        //! Seperator between audio recorder controls and equalizer.
        Rectangle {
            id: seperator
            width: parent.width
            anchors.top: parent.top
            color: "#FFFFFF"
            height: 1
            opacity: 0.3
        }

        Text {
            id: recduration
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom:parent.bottom
                bottomMargin: 50
            }

            width: 100
            height: 50
            text: qsTr("0:00")
            color: "darkgray"
            font.pixelSize: 64
        }

        //! Row formation of controls for audio recorder clip.
        Row {
            id: controls
            focus: true
            spacing: 160
            anchors { top: parent.top; topMargin: 20; horizontalCenter: parent.horizontalCenter }

            ButtonHolder {
                id: recordimg
                source: "icons/record_icon.png"

                onClicked: {
                    if (recStatus === 1) {
                        rec.stopRecording();
                    } else {
                        if ((playMusic.playing) || (playMusic.paused))
                            playMusic.stop();

                        rec.record();
                    }
                }
            }

            //! control icon for media pause
            ButtonHolder {
                id: recpausebutton
                source: "image://theme/icon-m-toolbar-mediacontrol-pause-white"

                onClicked: {
                    if (recStatus === 1)
                        rec.pauseRecording();
                }
            }

            //! control icon for media play
            ButtonHolder {
                id: playbutton
                visible: false
                source: "image://theme/icon-m-toolbar-mediacontrol-play-white"

                onClicked: {
                    audiorecpage.state = "Playing";

                    if (playMusic.paused === true)
                        playMusic.play();
                    else if (!playMusic.playing)
                        playMusic.play();
                    else if (playMusic.playing)
                        playMusic.pause();
                }
            }
        }

        //! Progressbar used to display and seek through audio playback duration
        Item {
            id: seekSlider
            visible: false          

            anchors {
                bottom: parent.bottom
                bottomMargin: 20
                left: parent.left
                right: parent.right
                leftMargin: 16
                rightMargin: 16
            }

            height: slider.height

            Item {
                id: slider
                anchors { left: parent.left; right: parent.right }
                height: 80
                width: parent.width

                property real currentaudiopos: playMusic.position
                property real maximumaudiopos: playMusic.duration

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent

                    property real initialaudioPos: 0
                    property real initialPos: 0

                    onPressed: {
                        initialPos = mouseX
                        initialaudioPos = slider.currentaudiopos
                    }

                    //! Changing the audio playback progress when the progressbar is
                    //! scrolled horizontally.
                    onMousePositionChanged: {
                        var target = initialaudioPos
                                * Math.pow(16, (mouseX - initialPos)/slider.width);
                        target = Math.max(1, Math.min(target, slider.maximumaudiopos))
                        playMusic.position = target
                    }
                }

                //!  Implementation of bar to display the progress level.
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
                        border.color: "black"
                        border.width: 2
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
                        anchors.left: filler.right
                        anchors.verticalCenter: filler.verticalCenter
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
                anchors { left: slider.left; bottom: slider.bottom; }
                font: uiConstants.FieldLabelFont
                color: "#FFFFFF"
                text: audiorecpage.positionTime
                opacity: 0.5
            }

            //! Text field to display the media duration in hr:min:sec format
            Text {
                id: durationTime
                anchors { right: slider.right; bottom: slider.bottom;  }
                font: uiConstants.FieldLabelFont
                text: audiorecpage.durationTime
                color: "#FFFFFF"
                opacity: 0.5
            }
        }
    }

    //! Using QML Audio Element to play the audio content
    Audio {
        id: playMusic
        volume: 0.5

        onStarted: playbutton.source = "image://theme/icon-m-toolbar-mediacontrol-pause-white"

        //! Tasks to do when media is paused
        onPaused: playbutton.source = "image://theme/icon-m-toolbar-mediacontrol-play-white"

        //! Tasks to do when media is resumed playing from a pause
        onResumed: playbutton.source = "image://theme/icon-m-toolbar-mediacontrol-pause-white"

        //! Tasks to do when media is stopped
        onStopped:{
            playbutton.source = "image://theme/icon-m-toolbar-mediacontrol-play-white"
            playMusic.playing = false;
            playMusic.position = 0;            
        }
    }

    //! Converts milliseconds to minutes and seconds format.
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

    //! Instantiating custom Audio recorder plugin
    Audiorecorder
    {
        id: rec

        onRecStatuschanged: {
            if (recstate === 0) {
                audiorecpage.state = "RecordingStopped";
                recStatus = 0;
            } else if (recstate === 1) {
                audiorecpage.state = "Recording";
                recStatus = 1;
            } else if (recstate === 2) {
                audiorecpage.state =  "RecordingPaused"
                recStatus = 2;
            }
        }
        onRecDurationChanged: recduration.text = getTimeFromMSec(recDuration);

        onErrorOpeningFile: {
            infobanner.text = "Error starting recording";
            infobanner.timerShowTime = 5000;
            infobanner.show();
        }
    }

    //!  Information Banners to convey alerts and information to user
    InfoBanner {
        id: infobanner
        anchors.top: parent.top
        anchors.topMargin: 10
        timerEnabled: true;
    }
}

//! End of File
