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
import com.nokia.harmattanapishowcase 1.0

//! using contact model supplied by the Contact QML plugin.
import QtMobility.contacts 1.1

/*!
 * @brief  AddressBook to select contact to be copied to NFC tag
 * Displays the list of contacts present on the device, single contact
 * at a time can be selected to be copied to NFC tag.
 */

Page {
    id: addressbookpage
    orientationLock: PageOrientation.LockPortrait

    property int contactid;
    property string contactName;
    property int indexValue;
    property bool firstCountChange: true;
    property alias nfcSheet: addressBookforNFCSheet

    Component.onCompleted: {
        if ( !myMessenger.isContactsAvailable(true) )
            addressBookforNFCSheetContentId.blankscreentextVisibility = true

        //! After paging is loaded, open the sheet
        addressBookforNFCSheet.open();
    }

    //!  Making new component and pushing created page to the stack.
    function openFile(file) {
        var component = Qt.createComponent(file)

        if (component.status === Component.Ready) {
            //! After closing the sheet only newly pushed component will be shown
            addressBookforNFCSheet.close();

            //! Push the newly created component
            pageStack.push(component);
        } else
            console.log("Error loading component:", component.errorString());
    }

    //!  Function to retrieve the first char of the string
    function firstChar(stringValue) {
        return stringValue.charAt(0);
    }

    Sheet {
        id: addressBookforNFCSheet
        anchors.fill: parent
        rejectButtonText: "Cancel"

        content: AddressBookforNFCSheetContent { id: addressBookforNFCSheetContentId }

        onRejected: {
            pageStack.pop();
        }
    }

    //! Custom defined Class component for sending message. Here we used to get the info about contacts availability.
    Messenger {
        id: myMessenger
    }
}

//! End of File
