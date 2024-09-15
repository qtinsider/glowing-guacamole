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

import QtQuick 1.0
import com.nokia.meego 1.0
import com.nokia.extras 1.0

//! Flickable element holds the sheet content
Flickable {
    id: flickableContact
    anchors.fill: parent
    flickableDirection: Flickable.VerticalFlick

    //! Variables accessed by the TwitSender.qml
    property alias contactsInput: contactsInput
    property alias messageText: messageText
    property alias spinner: spinner;
    property alias infobanner: infobanner;

    //! Rectangle component hosting Label "To" ,TextInput element contains the Local Service Number
    Rectangle {
        id: contactsRect
        width: parent.width; height: 52
        anchors.left: parent.left
        color: "#E0E1E2"

        //! "To" Label
        Label {
            id: toLabel
            anchors {
                left: contactsRect.left
                leftMargin: uiConstants.DefaultMargin
                verticalCenter: parent.verticalCenter
            }

            font.pixelSize: 28
            text: "To:"
            color: "#4591FF"
        }

        //! TextInput for Local Service Number
        TextInput {
            id: contactsInput
            width: 300
            anchors { left: toLabel.right; leftMargin: 10; verticalCenter: parent.verticalCenter }
            font.pixelSize: 28
            color: "grey"
            readOnly: true
            text: myTwitterCode.localServiceNumber();
        }
    } //!  end of contactsRect Rectangle

    //! Rectangle holding the  TextEdit element for typing the twitter message
    Rectangle {
        id: messageBox
        width: parent.width; height: parent.height - (contactsRect.height + contactsRect.height)
        anchors.top: contactsRect.bottom

        //! TextEdit for twitter message
        TextEdit {
            id: messageText
            anchors { fill: parent; leftMargin: 10; topMargin: 10 }
            font.pixelSize: 26
            focus: true
            cursorVisible: false
            text: ""
            wrapMode: TextEdit.Wrap

            //! Explicit basic PlaceHolder Implemenatation
            Text {
                id: messageTextPlaceholder
                anchors.fill: parent.fill
                font.pixelSize: 26
                color: "#b2b2b4"
                visible: messageText.cursorPosition === 0 && !messageText.text
                         && messageTextPlaceholder.text && !messageText.inputMethodComposing
                opacity: 0.65
                text: qsTr("Write your message here")
            }
        }
    } //! end of messageBox Rectangle

    //! Spinner to indicate the message sending in process,by default transparent
    BusyIndicator {
        id: spinner
        platformStyle: BusyIndicatorStyle { size: "medium" }
        anchors.centerIn: parent
        opacity: 0.0
        running: false
    }

    //! Information Banners to convey alerts and information to user
    InfoBanner { id: infobanner }
}//! end of Flickable
