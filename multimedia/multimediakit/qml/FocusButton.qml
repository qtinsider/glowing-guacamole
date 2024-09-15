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

/*!
 * @brief Creating a custom camera controls button using Button Item from
 * ButtonHolder.qml used for focusing the camera.
 */
ButtonHolder {
    property Camera camera

    //! Image to be displayed for "Focus" Icon.
    source: {
        if (camera.lockStatus === Camera.Unlocked)
            source = "image://theme/meegotouch-camera-reticle-normal"
    }

    rotation: rotation
}

//! End of File
