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

/*!
 * @brief  Copy vCard to NFC tag.
 * Class NfcSendvCard to copy a selected contact from Address book to NFC tag
 */
Page {
    id: nfcpage

    //! Locking the page to Portrait
    orientationLock: PageOrientation.LockPortrait

    Component.onCompleted: {
        //! After paging is loaded, open the sheet
        nfcCopyvCardSheet.open();
    }

    Sheet {
        id: nfcCopyvCardSheet
        anchors.fill: parent
        rejectButtonText: "Cancel"

        content: NFCCopycCardSheetContent { id: nfcCopycCardSheetContentId }

        onRejected: {
            pageStack.pop();
            addressbookpage.nfcSheet.open();
        }
    }
}

//! End of File
