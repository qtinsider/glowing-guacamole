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
 * @brief Control zoom level of still camera.
 * Zoom bar is shown at the top of the camera viewFinder.
 * Zoom level is adjusted by sliding the bar horizontally
 */
Item {
    id: zoomControl
    property real currentZoom: 1
    property real maximumZoom: 1
    signal zoomTo(real value)

    MouseArea {
        id : mouseArea
        anchors.fill: parent

        property real initialZoom: 0
        property real initialPos: 0

        onPressed: {
            initialPos = mouseX
            initialZoom = zoomControl.currentZoom
        }

        //! Changing the camera viewFinder's Zoom when the zoombar is scrolled vertically.
        onMousePositionChanged: {
            if (pressed) {
                var target = initialZoom * Math.pow(6, (mouseX - initialPos)/zoomControl.width);
                target = Math.max(1, Math.min(target, zoomControl.maximumZoom))
                zoomControl.zoomTo(target)
            }
        }
    }

    //! Implementation of bar to display the zoom level.
    Item {
        id: bar
        visible: true
        x: parent.width/4
        y: 16
        width: parent.width/2
        height: 8

        //! Border for zoom bar.
        Rectangle {
            anchors.fill: parent
            smooth: true
            radius: 8
            border.color: "black"
            border.width: 2
            color: "black"
            opacity: 0.3
        }

        //! Filling for zoom bar according to zoom level.
        Rectangle {
            id: filler
            x : 0
            y : 0
            width: parent.width - (parent.width * (1.0 - (zoomControl.currentZoom-1.0)
                                                   / (zoomControl.maximumZoom-1.0)))
            height: parent.height
            smooth: true
            radius: 8
            color: "blue"
            opacity: 0.5
        }

        Rectangle {
            id: positionindicator
            anchors.left: filler.right
            anchors.verticalCenter: filler.verticalCenter
            height: (filler.height)/2
            width: height
            radius: 8
            color:"white"
        }
    }
}

//! End of File
