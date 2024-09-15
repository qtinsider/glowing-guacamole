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
   id: channel
   smooth: true
   width: parent.width
   height: uiConstants.ListItemHeightDefault
   color: (currentStream===uri) ? "darkgray" : "transparent"
   opacity: (currentStream===uri) ? 0.3 : 1.0

   Label {
       id: titleLabel
       text: title
       width: parent.width - 16*2
       elide: Text.ElideRight
       anchors {
           left: parent.left
           leftMargin: uiConstants.DefaultMargin
           top: parent.top
           topMargin: uiConstants.DefaultMargin/2
       }
       font: uiConstants.TitleFont
   }

   Label {
       text: uri
       width: parent.width - 16*2
       elide: Text.ElideRight
       anchors {
           left: parent.left
           top: titleLabel.bottom
           leftMargin: uiConstants.DefaultMargin

       }
       font: uiConstants.BodyTextFont
   }

   Menu {
       id: itemMenu
       visualParent: pageStack

       MenuItem {
           text: "Delete"
           onClicked: {
               channelModelProxy.remove(index);
           }
       }
   }

   MouseArea {
       anchors.fill: parent

       onClicked: {
           currentIndex = index

           if(favorite)
               playChannelPage.favouriteIconSource = "../../../multimedia/internetradio/qml/icons/icon-m-content-favourites-inverse_on.png"
           else
               playChannelPage.favouriteIconSource = "../../../multimedia/internetradio/qml/icons/icon-m-content-favourites-inverse_off.png"

           if (currentStream!==uri) {
               currentStream = uri;
               playChannelPage.currentStream = uri;
           }
           pageStack.push(playChannelPage);
       }
       onPressAndHold: {
           itemMenu.open();
       }
   }
}
