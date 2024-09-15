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

Image {
    id: headerholder

    property string text : ""

    height: parent.width < parent.height ? uiConstants.HeaderDefaultHeightPortrait
                                         : uiConstants.HeaderDefaultHeightLandscape
    width: parent.width
    source: "image://theme/meegotouch-view-header-fixed" + (theme.inverted ? "-inverted" : "")
    x: 0; y: 0; z: 1

    // Header container
    Item {
        anchors {
            fill: parent
            topMargin: parent.width < parent.height ? uiConstants.HeaderDefaultTopSpacingPortrait
                                                    : uiConstants.HeaderDefaultTopSpacingLandscape
            bottomMargin: parent.width < parent.height
                          ? uiConstants.HeaderDefaultBottomSpacingPortrait
                          : uiConstants.HeaderDefaultBottomSpacingLandscape
            rightMargin: uiConstants.DefaultMargin
            leftMargin: uiConstants.DefaultMargin
        }
        // Page header text
        Label {
            id: header
            anchors { verticalCenter: parent.verticalCenter; left: parent.left }
            font: uiConstants.HeaderFont
            text: headerholder.text
        }
    }
}
