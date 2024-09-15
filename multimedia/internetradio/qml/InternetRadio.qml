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
import com.nokia.extras 1.0
import com.nokia.harmattanapishowcase 1.0

Page {
    id: page
    tools: internetRadioToolBar
    orientationLock: PageOrientation.LockPortrait

    property int pageWidth : (screen.displayWidth<screen.displayHeight ? screen.displayWidth
                                                                       : screen.displayHeight)

    property string currentStream : ""

    property bool _rootWindow_statusbar: false     //! The statusbar state before loading this page
    property bool _rootWindow_toolbar: false       //! The toolbar state before loading this page
    property bool _theme_inverted: false           //! The theme.inverted state before loading page

    property int currentIndex;

    //! We will hide the statusbar and show the toolbar onCompleted signal
    Component.onCompleted: {
        _rootWindow_statusbar = rootWindow.showStatusBar;
        _rootWindow_toolbar = rootWindow.showToolBar;
        _theme_inverted = theme.inverted;
        rootWindow.showStatusBar = true;
        rootWindow.showToolBar = true;
    }

    //! We will revert the statuses of the common elements onDestruction signal
    Component.onDestruction: {
        rootWindow.showStatusBar = _rootWindow_statusbar;
        rootWindow.showToolBar = _rootWindow_toolbar;
        theme.inverted = _theme_inverted;
        channelModelProxy.save();
    }

    PlayChannelPage {
        id: playChannelPage
    }

    ToolBarLayout {
        id: internetRadioToolBar
        ToolIcon {
            iconId: (screen.currentOrientation === Screen.Landscape)
                    ? "toolbar-back-landscape"  + (theme.inverted ? "" : "-white") : "toolbar-back"
            onClicked: {
                pageStack.pop();
            }
        }

        ToolIcon {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            iconId: "toolbar-add"
            onClicked: {
                var comp = Qt.createComponent("AddChannelSheet.qml")
                if (comp.status === Component.Ready) {
                    var addChannelSheet = comp.createObject(page);
                    addChannelSheet.open();
                }
            }
        }
    }

    PageHeader {
        id: pageHeader
        anchors.top: parent.top
        height: uiConstants.HeaderDefaultHeightPortrait
        width: parent.width
        text: "Internet Radio"
    }

    Label {
        visible: presetChannels.count===0
        text: "No channels"
        font: uiConstants.HeaderFont
        anchors.centerIn: parent
        z: 100
    }

    Flickable {
        anchors { bottom: parent.bottom; top: pageHeader.bottom }
        contentWidth: colContent.width
        contentHeight: colContent.height
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: colContent
            anchors.left: parent.left
            spacing: uiConstants.DefaultMargin
            width: pageWidth

            ListView {
                id: presetChannels
                height: page.height - pageHeader.height - uiConstants.DefaultMargin*2
                width: pageWidth
                Keys.onLeftPressed: decrementCurrentIndex()
                Keys.onRightPressed: incrementCurrentIndex()
                focus: true
                section.property: "favorite"
                section.delegate:   SectionHeader { text: (section === "true") ? "My favorite streams" : "Other streams" }

                model: channelModel

                delegate: ChannelDelegate {}
            }
        }
    }

}
