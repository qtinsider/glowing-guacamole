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
    id:textblock
    property string text : ""

    width: parent.width
    height: 40
    color: "#1c1a1a"

    // Section name
    Label {
        id: sectionName
        anchors {
            verticalCenter: parent.verticalCenter
            right: textblock.right
            rightMargin: uiConstants.DefaultMargin
        }
        font: uiConstants.GroupHeaderFont
        text: textblock.text
        color: "white"

    }
}
