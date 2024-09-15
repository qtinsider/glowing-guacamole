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
import QtMobility.sensors 1.1

/*!
 * @brief View selected image from image viewer.
 * Shows a full screen view of selected image.
 * Image can be zoomed in or out and is flickable when zoomed out.
 */
Page {
    id: viewimage
    tools: commonTools

    //! property holding the status of the orientation of the page
    property bool isPortrait: viewimage.width > viewimage.height ? false : true

    //! Store itemid of the current item in the delegate
    property variant currentID

    //! property holding the image file name
    property string imagename;

    //! Set initial state
    state: "ShowToolbar"

    function storeCurrentId(itemid) {
        currentID = itemid;
    }

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
            PropertyAnimation { target: viewmetadata; property: "opacity"; to: 0.6; duration: 500 }
        }
    ]

    ListView {
        id: listView
        anchors.fill: parent
        orientation: ListView.Horizontal;
        snapMode: ListView.SnapOneItem
        cacheBuffer: 2 * width;

        model: DocumentGalleryModel {
            rootType: DocumentGallery.Image
            properties: ["fileName", "filePath"]
            sortProperties: ["fileName"]
        }

        delegate: Image {
            id: currentImage
            source: filePath
            width: viewimage.width
            height: viewimage.height
            fillMode: Image.PreserveAspectFit

            onStatusChanged: {
                if (currentImage.status === Image.Ready) {
                    currentID = itemId;
                    imagename = model.fileName;
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (viewimage.state == "HideToolbar")
                        viewimage.state = "ShowToolbar"
                    else
                        viewimage.state  = "HideToolbar"
                }
            }
        } //! Image element end

        onCurrentIndexChanged: {
            listView.positionViewAtIndex(imageselectortab.indexToNextPage, listView.Contain)
        }
    }

    //! Item to display the fullscreenimage Metadata.
    Rectangle {
        id: viewmetadata
        color: "#A9A9A9"
        anchors { bottom: parent.bottom; right: parent.right }
        width: isPortrait ? parent.width : 300
        height: isPortrait ? 300 : parent.height
        clip: true
        opacity: 0.6

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
            width: (parent.width - 32)

            contentWidth: metadatacolumn.width
            contentHeight: metadatacolumn.height

            Column {
                id: metadatacolumn
                spacing: 8

                Label {
                    text: "<b>Name:</b> " +
                          (imagename === ""?
                               "unknown" : imagename)
                    color: "black"
                    width: metadataflickable.width
                    font: uiConstants.BodyTextFont
                    wrapMode: Text.WordWrap
                }

                Label {
                    text: "<b>Camera Manufacturer:</b> " +
                          (imagedetails.metaData.cameraManufacturer === ""?
                               "unknown" : imagedetails.metaData.cameraManufacturer)
                    color: "black"
                    width: metadataflickable.width
                    font: uiConstants.BodyTextFont
                    wrapMode: Text.WordWrap
                }

                Label {
                    color: "black"
                    width: metadataflickable.width
                    font: uiConstants.BodyTextFont
                    wrapMode: Text.WordWrap
                    text: "<b>Camera Model:</b> " +
                          (imagedetails.metaData.cameraModel === ""?
                               "unknown" : imagedetails.metaData.cameraModel)
                }

                Label {
                    color: "black"
                    width: metadataflickable.width
                    font: uiConstants.BodyTextFont
                    wrapMode: Text.WordWrap
                    text: "<b>Date Taken:</b> " +
                          (imagedetails.metaData.dateTaken === ""?
                               "unknown" : imagedetails.metaData.dateTaken)
                }

                Label {
                    color: "black"
                    width: metadataflickable.width
                    font: uiConstants.BodyTextFont
                    wrapMode: Text.WordWrap
                    text: "<b>ExposureProgram:</b> " +
                          (imagedetails.metaData.exposureProgram === ""?
                               "unknown" : imagedetails.metaData.exposureProgram)
                }

                Label {
                    color: "black"
                    width: metadataflickable.width
                    //font: {}
                    font: uiConstants.BodyTextFont
                    wrapMode: Text.WordWrap
                    text: "<b>ExposureTime:</b> " +
                          (imagedetails.metaData.exposureTime === ""?
                               "unknown" : imagedetails.metaData.exposureTime)
                }

                Label {
                    color: "black"
                    width: metadataflickable.width
                    font: uiConstants.BodyTextFont
                    wrapMode: Text.WordWrap
                    text: "<b>FocalLength:</b> " +
                          (imagedetails.metaData.focalLength ===""?
                               "unknown" : imagedetails.metaData.focalLength)
                }

                Label {
                    color: "black"
                    width: metadataflickable.width
                    font: uiConstants.BodyTextFont
                    wrapMode: Text.WordWrap
                    text: "<b>Orientation:</b> " +
                          (imagedetails.metaData.orientation ===""?
                               "unknown" : imagedetails.metaData.orientation)
                }

                Text {
                    color: "black"
                    width: metadataflickable.width
                    font: uiConstants.BodyTextFont
                    wrapMode: Text.WordWrap
                    text: "<b>WhiteBalance:</b> " +
                          (imagedetails.metaData.whiteBalance ===""?
                               "unknown" : imagedetails.metaData.whiteBalance)
                }
            }
        }
    }

    //! Metadata properties to be shown are requested using DocumentGalleryItem element
    DocumentGalleryItem {
        id: imagedetails
        item: currentID
        properties: ["cameraManufacturer", "cameraModel", "dateTaken", "exposureProgram",
            "exposureTime", "focalLength", "orientation", "whiteBalance"]
    }

    //! On this page status bar need to be hidden
    Component.onCompleted: {
        rootWindow.showStatusBar = false;
    }
}

//! End of File
