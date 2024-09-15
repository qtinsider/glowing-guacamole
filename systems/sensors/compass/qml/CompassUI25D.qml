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
    property int rotationX: 0
    property int rotationY: 0
    property bool faceDown: (rotationY<-90 || rotationY>90)

    color: "transparent"
    smooth: true
    height: width

    CompassUI2DFace {
        id: face
        effectColor: faceDown ? Qt.rgba(255,255,255,1) : Qt.rgba(255,255,255,1)
        rotation: -parent.azimuth + ( faceDown ? 90 : -90 )
        anchors.fill: parent
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        useInvertedBackground: faceDown ? true : false
    }

    transformOrigin: Item.Center
    transform: [
        Rotation {
            origin.x: width/2
            origin.y: height/2
            axis { x: 0; y: 1; z: 0 }
            angle: -rotationX
        },
        Rotation {
            origin.x: width/2
            origin.y: height/2
            axis { x: 1; y: 0; z: 0 }
            angle: -rotationY
        }
    ]
}

//!  End of File
