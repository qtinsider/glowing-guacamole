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
 * @brief Preview the image captured by camera.
 * Shows preview of image captured by the still camera.
 */
Page {
    id: photoPreview
    tools: commonTools

    //! Set initial state
    state: "ShowToolbar"

    Component.onCompleted: {
        //! After loading the page, disable settings tool icon
        rootWindow.settingsIconVisible = false
    }

    Component.onDestruction: {
        //! After destroying the page, enable settings tool icon
        rootWindow.settingsIconVisible = true        
    }

    //! Two states defined to show and hide the toolbar while viewing the image.
    states: [
        State {
            name: "ShowToolbar"

            StateChangeScript {
                script: {
                    showToolBar = true
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

    //! Display last captured image
    Image {
        id: preview
        anchors.fill: parent
        source: camerapage.previewImage
        fillMode: Image.PreserveAspectFit
        smooth: true

        MouseArea {
            anchors.fill: parent

            onClicked: {
                if (photoPreview.state === "HideToolbar")
                    photoPreview.state = "ShowToolbar"
                else
                    photoPreview.state  = "HideToolbar"
            }
        }
    }
}

//! End of File
