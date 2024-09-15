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
import QtMultimediaKit 1.1
import com.nokia.meego 1.0

/*!
 * @brief Camera
 * Capture still images and control flash and scene settings
 */
Page {
    id: camerapage

    //! Locking the page orientation in Landscape
    orientationLock: PageOrientation.LockLandscape

    //! Share the contents to PhotoPreview.qml
    property string previewImage: ""

    //!  Making new component and pushing created page to the stack.
    function openFile(file) {
        var component = Qt.createComponent(file)
        if (component.status === Component.Ready)
            pageStack.push(component);
        else
            console.log("Error loading component:", component.errorString());
    }

    //! Creating a layout with black background on top of which viewfinder is displayed.
    Rectangle {
        id: cameraUI
        anchors.fill: parent
        color: "black"

        //! Using the QML Camera Element to capture still images.
        Camera {
            id: camera
            anchors.fill: parent
            x: 0
            y: 0
            focus: visible

            //Use complete screen area
            captureResolution: "1280x640"
            exposureMode: (cameraControls.scenevalue === undefined) ? Camera.ExposureAuto
                                                                    : cameraControls.scenevalue
            flashMode: (cameraControls.flashvalue === undefined) ? Camera.FlashOff
                                                                 : cameraControls.flashvalue

            //Tasks to perform after an image is captured.
            onImageCaptured : {
                previewImage = preview;
                openFile("PhotoPreview.qml")
            }

            //! Focus area control to focus and re-focus
            MouseArea {
                anchors.fill: parent

                onClicked: {
                    if (camera.lockStatus === Camera.Unlocked)
                        camera.searchAndLock();
                    else
                        camera.unlock();
                }
            }
        }

        //! Settings Icon when clicked captures image
        Image {
            id: captureImage
            source: "image://theme/meegotouch-camera-shutter-key-background"
            anchors { right: parent.right; rightMargin: 30; verticalCenter: parent.verticalCenter }

            Image {
                anchors.centerIn: parent
                source: "image://theme/icon-m-camera-shutter"
            }

            MouseArea{
                anchors.fill: parent
                onClicked: camera.captureImage()
            }
        }

        //! Settings Icon when clicked opens controls page.
        Image {
            id: controlsImage
            source: "image://theme/meegotouch-camera-settings-indicators-background"
            anchors { left: parent.left; leftMargin: 30; verticalCenter: parent.verticalCenter }

            Column {
                spacing: 15
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    id: flashsettingicon
                    source: cameraControls.flashicon
                }

                Image {
                    id: scenesettingicon
                    source: cameraControls.sceneicon
                }
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    zoombar.visible = false
                    camera.visible = false
                    captureImage.visible = false
                    controlsImage.visible = false
                    backbutton.visible = false
                    backcontrols.visible = true
                    backcontrols.enabled = true
                    cameraControls.opacity = 1
                }

                onPressed: controlsImage.source = "image://theme/meegotouch-camera-settings-indicators-background-pressed"
                onReleased: controlsImage.source = "image://theme/meegotouch-camera-settings-indicators-background"
            }
        }

        //! Enabling and displaying the still camera controls
        CameraControls {
            id: cameraControls
            opacity: 0
            anchors.fill: parent
            camera: camera

            onValueschanged:  {
                camera.flashMode = cameraControls.flashvalue
                camera.exposureMode = cameraControls.scenevalue
            }

            Image {
                id: backcontrols
                enabled: false
                source: "icons/Back_button_black_bg.png"

                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    leftMargin: 30
                    bottomMargin: 10
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        zoombar.visible = true
                        camera.visible = true
                        camera.focus = true
                        captureImage.visible = true
                        controlsImage.visible = true
                        backbutton.visible = true
                        backcontrols.visible = false
                        cameraControls.opacity = 0
                    }
                }
            }
        }

        //! Enabling and display Zoom control Item implemented in ZoomControl.qml
        ZoomControl {
            id: zoombar
            anchors { top: parent.top; leftMargin: 20; topMargin: 20 }
            width: parent.width
            height: 100
            currentZoom: camera.digitalZoom
            maximumZoom: Math.min(4.0, camera.maximumDigitalZoom)
            onZoomTo: camera.setDigitalZoom(value)
        }

        Image {
            id: backbutton
            source: "icons/Back_button_black_bg.png"
            anchors { bottom: parent.bottom; left: parent.left; bottomMargin: 10; leftMargin: 30 }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    camera.stop()
                    pageStack.pop()

                    //! changing theme back to white if returning to first page
                    if (pageStack.depth === 1) theme.inverted = false;
                }
            }
        }
    }

    //! On this page status bar need to be hidden
    Component.onCompleted: {
        rootWindow.showStatusBar = false;
        screen.allowSwipe = false;
    }

    Component.onDestruction: {
        rootWindow.showStatusBar = true;
        screen.allowSwipe = true;
    }
}

//! End of File
