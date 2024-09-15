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

//! using contact model supplied by the Contact QML plugin
import QtMobility.contacts 1.1

/*!
 * @brief  AddressBook to select contact to be copied for SMS
 * Displays the list of contacts present on the device, one contact
 * can be selected at a time to send SMS.
 */
Page {
    id: addressbookpage
    orientationLock: PageOrientation.LockPortrait

    property int indexValue;
    property string selectedContactName;
    property bool firstCountChange: true;

    //! Function to retrieve the first char of the string to be displayed
    function firstChar(stringValue) {
        return stringValue.charAt(0);
    }

    //! Function to update each individuals phone number in a model
    function updatephoneNumberList() {
        for (var i = 0; i < addressBookSheetContentId.phonebookModel.contacts[indexValue].phoneNumbers.length; i++) {
            addressBookSheetContentId.phoneNumberList.append({"name": addressBookSheetContentId.phonebookModel.contacts[indexValue].phoneNumbers[i].number})
        }
    }

    Sheet {
        id: addressBookSheet
        anchors.fill: parent
        rejectButtonText: "Cancel"

        content: AddressBookSheetContent { id: addressBookSheetContentId }

        onRejected: {
            pageStack.pop();

            //! By default sheet doesn't open. Need to open the sheet in SMSSender.qml
            smssendingPage.smsSheet.open();
        }
    }

    Component.onCompleted: {
        //! After paging is loaded, open the sheet
        addressBookSheet.open();
    }
}

//! End of File
