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

/*!
 * @brief Control button holders are implemented.
 * This item is reused to implement various controls for various multimedia components.
 */

Item {
    id: button
    width : 75
    height: 75

    signal clicked

    property string text
    property string source
    property color color: "white"
    property double rotation

    //! Holder for control buttons
    //! Used for multiple control buttons in multimedia.
    Rectangle {
        id: buttonImage
        width: button.width; height: button.height
        opacity: 0.0
    }

    MouseArea {
        id: mouseRegion
        anchors.fill: buttonImage

        onClicked: button.clicked()
    }

    //! Display text on controls buttons
    Text {
        id: btnText
        color: button.color

        anchors {
            top: buttonImage.bottom
            topMargin: 2
            horizontalCenter: parent.horizontalCenter
        }

        text: button.text; style: Text.Raised; styleColor: "black"
        font.pixelSize: 18
        opacity: 0.5
    }

    //! Display images on controls buttons.
    Image {        
        anchors.centerIn: buttonImage
        source: button.source
        rotation: button.rotation
    }
}

//! End of File
