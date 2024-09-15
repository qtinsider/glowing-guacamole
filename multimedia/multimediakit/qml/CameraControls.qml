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
 * @brief Camera controls
 * Controls for flash and scene settings
 */
Item {
    id: cameracontrols

    property Camera camera
    property variant scenevalue: Camera.ExposureAuto
    property variant flashvalue: Camera.FlashOff
    property string sceneicon: "image://theme/icon-m-camera-scene-auto-screen"
    property string flashicon: "image://theme/icon-m-camera-flash-auto-screen"

    signal valueschanged;

    Rectangle {
        color: "black"
        anchors.fill: parent

        //! Text to display when no video files exist on the device
        Label {
            id: header
            text: "Image capture settings"

            anchors {
                top: parent.top
                left: parent.left
                topMargin: uiConstants.HeaderDefaultTopSpacingLandscape
                leftMargin: 10
            }

            color: "gray"
            opacity: 0.7
            font: uiConstants.HeaderFont
        }

        //! Header and separator for Scene controls
        Item {
            id: scene
            anchors { top: header.bottom; left: parent.left; topMargin: 40; leftMargin: 10 }
            width: parent.width

            Text {
                id: scenetext
                anchors.verticalCenter: parent.verticalCenter
                opacity: 0.5
                color: "gray"
                font: uiConstants.GroupHeaderFont
                text: qsTr("Scene")
            }

            Image {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left:scenetext.right
                    leftMargin: 10
                    right: scene.right
                    rightMargin: 16
                }

                width: scene.width
                source: "image://theme/meegotouch-groupheader"
                        + (theme.inverted ? "-inverted" : "") + "-background"
            }
        }

        //! Header and separator for Flash controls
        Item {
            id: flash
            anchors { top: scene.bottom; left: parent.left; topMargin: 175; leftMargin: 10 }
            width: parent.width

            Text {
                id: flashtext
                anchors.verticalCenter: parent.verticalCenter
                opacity: 0.5
                color: "gray"
                font: uiConstants.GroupHeaderFont
                text: qsTr("Flash")
            }

            Image {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: flashtext.right
                    leftMargin: 10
                    right: flash.right
                    rightMargin: 16
                }

                width: flash.width
                source: "image://theme/meegotouch-groupheader"
                        + (theme.inverted ? "-inverted" : "") + "-background"
            }
        }

        //! Row of control icons for selecting flash modes
        Item {
            id: flashicons
            anchors { top: flash.bottom; left: parent.left; topMargin: 20; leftMargin: 60 }
            property bool buttonselelcted: false            

            Row {
                spacing: 60

                ButtonHolder {
                    id: autoflash
                    source: (camera.flashMode === Camera.FlashAuto)
                            ? "image://theme/icon-m-camera-flash-auto-selected"
                            : "image://theme/icon-m-camera-flash-auto"
                    text: "Automatic"

                    onClicked: {
                        if (source === "image://theme/icon-m-camera-flash-auto-selected") {
                            cameracontrols.flashvalue = Camera.FlashOff;
                            cameracontrols.flashicon = "image://theme/icon-m-camera-flash-off-screen"
                            valueschanged()
                        } else {
                            cameracontrols.flashvalue = Camera.FlashAuto
                            cameracontrols.flashicon = "image://theme/icon-m-camera-flash-auto-screen"
                            valueschanged()
                        }
                    }
                }

                ButtonHolder {
                    id: alwaysflash
                    source: (camera.flashMode === Camera.FlashOn)
                            ? "image://theme/icon-m-camera-flash-always-selected"
                            : "image://theme/icon-m-camera-flash-always"
                    text: "On"

                    onClicked: {
                        if (source === "image://theme/icon-m-camera-flash-always-selected") {
                            cameracontrols.flashvalue = Camera.FlashOff;
                            cameracontrols.flashicon = "image://theme/icon-m-camera-flash-off-screen"
                            valueschanged()
                        } else {
                            cameracontrols.flashvalue = Camera.FlashOn;
                            cameracontrols.flashicon = "image://theme/icon-m-camera-flash-always-screen"
                            valueschanged()
                        }
                    }
                }

                ButtonHolder {
                    id: flashoff
                    source: (camera.flashMode === Camera.FlashOff)
                            ? "image://theme/icon-m-camera-flash-off-selected"
                            : "image://theme/icon-m-camera-flash-off"
                    text: "Off"

                    onClicked: {
                        cameracontrols.flashvalue = Camera.FlashOff;
                        cameracontrols.flashicon = "image://theme/icon-m-camera-flash-off-screen"
                        valueschanged()
                    }
                }

                ButtonHolder {
                    id: flashredeye
                    source: (camera.flashMode === Camera.FlashRedEyeReduction )
                            ? "image://theme/icon-m-camera-flash-red-eye-selected"
                            : "image://theme/icon-m-camera-flash-red-eye"
                    text: "Red eye"

                    onClicked: {
                        if (source === "image://theme/icon-m-camera-flash-red-eye-selected") {
                            cameracontrols.flashvalue = Camera.FlashOff;
                            cameracontrols.flashicon = "image://theme/icon-m-camera-flash-off-screen"
                            valueschanged()
                        } else {
                            cameracontrols.flashvalue = Camera.FlashRedEyeReduction;
                            cameracontrols.flashicon = "image://theme/icon-m-camera-flash-red-eye-screen"
                            valueschanged()
                        }
                    }
                }
            }
        }

        //! Row of control icons for selecting scene modes
        Item {
            id: sceneicons
            anchors { top: scene.bottom; left: parent.left; topMargin: 20; leftMargin: 60 }

            Row {
                spacing: 60

                ButtonHolder {
                    id: sceneauto
                    source: (camera.exposureMode === Camera.ExposureAuto ) ? "image://theme/icon-m-camera-scene-auto-selected": "image://theme/icon-m-camera-scene-auto"
                    text: "Automatic"

                    onClicked: {
                        cameracontrols.scenevalue = Camera.ExposureAuto
                        cameracontrols.sceneicon = "image://theme/icon-m-camera-scene-auto-screen"
                        valueschanged()
                    }
                }

                ButtonHolder {
                    id: sceneportrait
                    source: (camera.exposureMode === Camera.ExposurePortrait ) ? "image://theme/icon-m-camera-scene-portrait-selected" :  "image://theme/icon-m-camera-scene-portrait"
                    text: "Portrait"

                    onClicked: {
                        if (source ===  "image://theme/icon-m-camera-scene-portrait-selected") {
                            cameracontrols.scenevalue = Camera.ExposureAuto
                            cameracontrols.sceneicon = "image://theme/icon-m-camera-scene-auto-screen"
                            valueschanged()
                        } else {
                            cameracontrols.scenevalue = Camera.ExposurePortrait
                            cameracontrols.sceneicon = "image://theme/icon-m-camera-scene-portrait-screen"
                            valueschanged()
                        }
                    }
                }

                ButtonHolder {
                    id: scenenight
                    source: (camera.exposureMode === Camera.ExposureNight ) ? "image://theme/icon-m-camera-night-selected": "image://theme/icon-m-camera-night"
                    text: "Night"

                    onClicked: {
                        if (source === "image://theme/icon-m-camera-night-selected") {
                            cameracontrols.scenevalue = Camera.ExposureAuto
                            cameracontrols.sceneicon = "image://theme/icon-m-camera-scene-auto-screen"
                            valueschanged()
                        } else {
                            cameracontrols.scenevalue = Camera.ExposureNight
                            cameracontrols.sceneicon = "image://theme/icon-m-camera-night-screen"
                            valueschanged()
                        }
                    }
                }

                ButtonHolder {
                    id: scenesports
                    source: (camera.exposureMode === Camera.ExposureSports )
                            ? "image://theme/icon-m-camera-scene-sports-selected"
                            : "image://theme/icon-m-camera-scene-sports"
                    text: "Sports"

                    onClicked: {
                        if (source === "image://theme/icon-m-camera-scene-sports-selected") {
                            cameracontrols.scenevalue = Camera.ExposureAuto
                            cameracontrols.sceneicon = "image://theme/icon-m-camera-scene-auto-screen"
                            valueschanged()
                        } else {
                            cameracontrols.scenevalue = Camera.ExposureSports
                            cameracontrols.sceneicon = "image://theme/icon-m-camera-scene-sports-screen"
                            valueschanged()
                        }
                    }
                }
            }
        }
    }
}

//! End of File
