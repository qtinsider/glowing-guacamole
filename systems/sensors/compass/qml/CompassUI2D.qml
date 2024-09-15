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

Rectangle {
    id: compass
    property alias size: compass.width
    property real azimuth: 0

    color: "transparent"
    smooth: true
    height: width

    CompassUI2DFace {
        id: face
        effectColor: "white"
        rotation: -parent.azimuth - 90  // -90 because we are in landscape
        anchors.fill: parent
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        showBackground: true
        border.width: 4
    }

    transformOrigin: Item.Center
    transform: Rotation {}
}

//!  End of File
