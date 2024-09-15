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

/*!
 * @brief Display the Section Header in the main page
 */
Item {
    id:textblock
    property string text : ""

    width: parent.width
    height: 20

    //! Section separator image
    Image {
        anchors {
            right: sectionName.left
            left: parent.left
            verticalCenter: sectionName.verticalCenter
            rightMargin: 24
        }

        source: "image://theme/meegotouch-groupheader" + (theme.inverted ? "-inverted" : "")
                + "-background"
    }

    //! Section name
    Label {
        id: sectionName

        anchors {
            verticalCenter: parent.verticalCenter
            top: parent.top
            right: textblock.right
        }

        font: UiConstants.GroupHeaderFont
        text: textblock.text
        color: "#8c8c8c"
    }
}

//! End of file
