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

/*!
 * @brief View images present on the device.
 * Shows a grid view of images on the device, individual
 * image can be selected for viewing.
 */

Page {
    id: imageselectortab

    //! Using common tools from main.qml
    tools: commonTools

    //! Image index using in ViewImage.qml file
    property alias indexToNextPage : gridview.currentIndex

    //! Signal emitted when image selector page is closed.
    signal imageselectorclosed;

    //! property holding the status of the orientation of the page
    property bool isPortrait: imageselectortab.width > imageselectortab.height ? false : true

    function openFile(file) {
        var component = Qt.createComponent(file)

        if (component.status === Component.Ready)
            pageStack.push(component);
        else
            console.log("Error loading component:", component.errorString());
    }

    //! Signal handling when image picker page is closed
    onImageselectorclosed: openFile("ViewImage.qml")

    //! Text to display when no Image files exist on the device
    Text {
        id: blankscreentext
        text: "No images"
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
        visible: ((gridview.count === 0) && (foldermodel.status !== 1))
        color: "white"
        font.pixelSize: 40
    }

    //! List view to display the file system of the device
    GridView {
        id: gridview
        anchors.fill: parent
        anchors { top: parent.top; left: parent.left; leftMargin: isPortrait ? 0 : 30 }
        cellWidth: 160
        cellHeight: 160

        //! Setting the model for the grid view of the thumbnails
        model:  DocumentGalleryModel {
            id: foldermodel
            rootType: DocumentGallery.Image
            properties: ["fileName", "filePath"]
            sortProperties: ["fileName"]
        }

        //! Delegate to display the thumbnails.
        delegate: Item {
            id: name

            //! Thumbnail display of images found in the Document Gallery
            Item {
                width: 158
                height: 158

                //! Loading smaller images not to use more memory than needed.
                //! Image is scaled to fill cell and cropped if necessary.
                Image {
                    id: imagethumbnail
                    anchors.fill: parent
                    source: model.filePath
                    sourceSize.width: 158
                    fillMode: Image.PreserveAspectCrop
                    clip: true
                    asynchronous: true

                    onStatusChanged: {
                        if (status === Image.Error)
                            errormsg.text = "Unable to load image";
                    }

                    //! Mouse area covering the thumbnails images
                    //! When clicked the selected image is displayed in a new page
                    MouseArea {
                        id: mouseArea
                        anchors.fill: imagethumbnail

                        onClicked: {
                            gridview.currentIndex = index;
                            imageselectortab.imageselectorclosed();
                        }
                    }

                    Label {
                        id: errormsg
                        wrapMode: Text.WordWrap
                        font.pixelSize: 16
                        color: "white"
                    }
                }
            }
        }
    }

    //!  On this page status bar need to be hidden
    Component.onCompleted: rootWindow.showStatusBar = false
    Component.onDestruction: rootWindow.showStatusBar = true
}

//! End of File
