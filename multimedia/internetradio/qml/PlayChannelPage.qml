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
import com.nokia.harmattanapishowcase 1.0
import com.nokia.extras 1.0

Page {
    id: page

    tools: playTools
    orientationLock: PageOrientation.LockPortrait
    property int pageWidth : (screen.displayWidth<screen.displayHeight ? screen.displayWidth
                                                                       : screen.displayHeight)
    property alias currentStream : gstPlayer.stream
    property alias favouriteIconSource: favouriteIcon.iconSource

    // Information banner
    InfoBanner {
        id: infobanner
        z:100
    }

    ToolBarLayout {
        id: playTools
        ToolIcon {
           iconId: (screen.currentOrientation === Screen.Landscape)
                   ? "toolbar-back-landscape"  + (theme.inverted ? "" : "-white") : "toolbar-back"
           onClicked: {
               pageStack.pop();
           }
        }

        ToolIcon {
            id: favouriteIcon
           iconSource: "../../../multimedia/internetradio/qml/icons/icon-m-content-favourites-inverse_off.png"

           onClicked: {
               if( favouriteIcon.iconSource == "file:///opt/harmattanapishowcase/multimedia/internetradio/qml/icons/icon-m-content-favourites-inverse_off.png" ) {
                   favouriteIcon.iconSource = "../../../multimedia/internetradio/qml/icons/icon-m-content-favourites-inverse_on.png"
                   channelModelProxy.remove(currentIndex);
                   channelModelProxy.append(gstPlayer.organization,gstPlayer.stream,true);
               } else {
                   favouriteIcon.iconSource = "../../../multimedia/internetradio/qml/icons/icon-m-content-favourites-inverse_off.png"
                   channelModelProxy.remove(currentIndex);
                   channelModelProxy.append(gstPlayer.organization,gstPlayer.stream,false);
               }
           }
        }

        ToolIcon {
           id: recordIcon
           iconId:  "icon-m-camera-ongoing-recording"
           scale: 1.5
           onClicked: {
               gstPlayer.record("/home/user/MyDocs/Music/HarmattanApiShowcase.mp3")
               elapsedTimer.running = true
               statusLabel.text = "Recording 00:00"
               enabled = false;
           }
        }

        ToolIcon {
           anchors.right: parent.right
           iconSource:"../../../main/qml/icons/help_icon.png"
           onClicked:rootWindow.openFile("../../main/qml/AboutDialog.qml")
        }
    }

    GstPlayer {
        id: gstPlayer;
        onErrorChanged: {
            infobanner.text = gstPlayer.error;
            infobanner.show();
        }
    }

    PageHeader {
        id: pageHeader
        anchors.top: parent.top
        height: uiConstants.HeaderDefaultHeightPortrait
        width: parent.width
        text: "Internet Radio"
    }

    Flickable {
        anchors { bottom: controlsContainer.top; top: pageHeader.bottom }
        contentWidth: colContent.width
        contentHeight: colContent.height
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: colContent
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: uiConstants.DefaultMargin
            spacing: uiConstants.IndentDefault
            width: pageWidth - uiConstants.DefaultMargin*2
            Column {
                width: parent.width
                Label {
                    id: organizationLabel
                    text: gstPlayer.organization
                    font: uiConstants.HeaderFont
                    color: "darkgray"
                    width: parent.width
                    elide: Text.ElideRight
                }
            }

            Column {
                width: parent.width
                visible: gstPlayer.song!==""
                Label {
                    text: "Now Playing"
                    font: uiConstants.TitleFont
                }
                Label {
                    text: gstPlayer.song
                    font: uiConstants.SubtitleFont
                    width: parent.width
                    elide: Text.ElideRight
                }
            }
            Column {
                width: parent.width
                visible: gstPlayer.album!==""
                Label {
                    text: "Album"
                    font: uiConstants.TitleFont
                }
                Label {
                    text: gstPlayer.album
                    font: uiConstants.SubtitleFont
                    width: parent.width
                    elide: Text.ElideRight
                }
            }
            Column {
                width: parent.width
                visible: gstPlayer.artist!==""
                Label {
                    text: "Artist"
                    font: uiConstants.TitleFont
                }
                Label {
                    text: gstPlayer.artist
                    font: uiConstants.SubtitleFont
                    width: parent.width
                    elide: Text.ElideRight
                }
            }
            Column {
                width: parent.width
                visible: gstPlayer.bitrate!==""
                Label {
                    text: "Bitrate"
                    font: uiConstants.TitleFont
                }
                Label {
                    text: gstPlayer.bitrate
                    font: uiConstants.SubtitleFont
                    width: parent.width
                    elide: Text.ElideRight
                }
            }
            Column {
                width: parent.width
                visible: gstPlayer.stream!==""
                Label {
                    text: "Url"
                    font: uiConstants.TitleFont
                }
                Label {
                    text: gstPlayer.stream
                    font: uiConstants.SubtitleFont
                    width: parent.width
                    elide: Text.ElideRight
                }
            }
            Column {
                width: parent.width
                visible: gstPlayer.recording
                Label {
                    text: "Filename"
                    font: uiConstants.TitleFont
                }
                Label {
                    text: gstPlayer.filename
                    font: uiConstants.SubtitleFont
                    width: parent.width
                    elide: Text.ElideLeft
                }
            }

        }
    }

    Rectangle {
        id: controlsContainer
        z: 10000
        color: "black"
        anchors.bottom: parent.bottom
        height: 205
        width: pageWidth

        Column {
            id: controlsSeparator
            anchors.bottom: controlsColumn.top
            width: pageWidth
            height: 30

            Rectangle {
                width: parent.width
                height: 1
                color: Qt.rgba(100,100,100,0.5)
            }
        }

        Column {
            id: controlsColumn
            height: 160
            width: pageWidth - 32
            spacing: 30
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                margins: 16
            }

            Image {
                visible: (gstPlayer.stream !== "")
                anchors.horizontalCenter: parent.horizontalCenter
                source: (gstPlayer.playing) ? "image://theme/icon-m-toolbar-mediacontrol-pause-white"
                                            :((gstPlayer.recording) ? "image://theme/icon-m-toolbar-mediacontrol-stop-white"
                                                                      : "image://theme/icon-m-toolbar-mediacontrol-play-white")

                MouseArea {
                    anchors.fill: parent

                    // Change playing and status depending on current state
                    onClicked: {
                        if (gstPlayer.playing) {
                            // Pause stream
                            gstPlayer.pause();
                            statusLabel.text = "Paused"
                        } else if (gstPlayer.recording) {
                            // Stop recording and show status
                            gstPlayer.stop();
                            statusLabel.text = "Stopped"

                            // Reset recording duration timer
                            elapsedTimer.running = false;
                            elapsedTimer.seconds = 0;
                            elapsedTimer.minutes = 0;
                            recordIcon.enabled = true;

                            // Show recording location
                            infobanner.text = "Your recording is saved to MyDocs/Music.\nYou can play it from here."
                            infobanner.show();
                        }
                        else {
                            // Play station
                            gstPlayer.play();
                            statusLabel.text = "Streaming"
                        }
                    }
                }
            }

            Row {
                width: parent.width
                spacing: 16
                anchors.horizontalCenter: parent.horizontalCenter

                ProgressBar {
                    id: progressBar
                    visible: (gstPlayer.stream !== "")
                    width: parent.width
                    maximumValue: 100
                    minimumValue: 0
                    indeterminate: (value === maximumValue)
                    value: gstPlayer.buffer
                }
            }

            // Timer for elapsed recording duration
            Timer {
                id: elapsedTimer
                interval: 1000
                running: (gstPlayer.recording) ? true: false
                repeat: (gstPlayer.recording) ? true: false

                // Properties to hold elapsed time.
                property int seconds: 0
                property int minutes: 0
                property int hours: 0

                onTriggered: {
                  // Increment recording duration
                  if (++seconds > 59) {
                    seconds = 0;

                    if (++minutes > 59) {
                        minutes = 0;

                        if (++hours > 59) {
                            hours = 0

                            // Show message
                            infobanner.text = "Allowed maximum time for recording finished."
                            infobanner.show();

                            // Stop recording and show status
                            gstPlayer.stop();
                            statusLabel.text = "Stopped"

                            // Reset recording duration timer
                            elapsedTimer.running = false;
                            elapsedTimer.seconds = 0;
                            elapsedTimer.minutes = 0;
                            elapsedTimer.hours = 0;
                            recordIcon.enabled = true;
                          }
                        }
                    }

                  // Update recording time
                  statusLabel.text = "Recording " + ((hours < 1)  ? "" : ((hours < 10) ? ("0" + hours) : hours) + ":")  +
                                                    ((minutes < 10)  ? ("0" + minutes) : minutes) + ":" +
                                                    ((seconds < 10)  ? ("0" + seconds) : seconds)
                }
          }

            Label {
                id: statusLabel
                text: (gstPlayer.stream === "") ? "Select a internet radio station to play." : "Streaming"
                font.family: "Nokia Pure Text Light"
                font.pixelSize: 26
                color: (gstPlayer.recording) ? "Red" : "darkgray"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
