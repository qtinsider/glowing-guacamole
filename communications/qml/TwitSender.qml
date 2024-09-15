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

//! Importing the system systemInfo component supplied by QT Mobility 1.2 components
import QtMobility.systeminfo 1.2
import com.nokia.harmattanapishowcase 1.0

/*!
 * @brief  Tweet sender to send SMS to a particular service number
 * Displays the status when the message is send and verify the
 * precondition of SIM card and message status
 */

//! Page for creating and sending Tweet SMS
Page {
    id: tweetsendingPage
    orientationLock: PageOrientation.LockPortrait

    //! Variable to check for sim status.
    property alias simPresent: deviceInfo.simStatus;

    //! Variable to check for QmessageService instance.
    property bool qMessageServieInstance: false;

    //! Function to send Tweets, which internally calls QT member function
    function sendTweet(number)
    {
        //! Check if sim present and initialize message service.
        if (simPresent) {
            //! Show busy indicator.
            twitSenderInfoID.spinner.running = true;
            twitSenderInfoID.spinner.opacity = 1.0;

            //! Initialize QMessageService if not already active.
            if (qMessageServieInstance === false) {
                myMessenger.initialiseMessageService();
                qMessageServieInstance = true;
            }

            //! Send SMS to tweet server.
            myMessenger.msgSent = myMessenger.sendSMS(number,twitSenderInfoID.messageText.text);

            //! Stop busy indicator.
            twitSenderInfoID.spinner.running = false;
            twitSenderInfoID.spinner.opacity = 0.0;
        } else {
            //! If no SIM is present display a error message
            twitSenderInfoID.infobanner.text = "No Active Sim"
            twitSenderInfoID.infobanner.show();
        }
    }

    //! Function to process the logic on clicking the SEND button
    function sendButtonClicked()
    {
        //! Set focus from message text so text is commited from predictive text engine.
        sheet.acceptButton.forceActiveFocus();

        //! Check if Flight mode is on.
        if (qmDeviceMode.deviceMode === "Flight mode") {
            twitSenderInfoID.infobanner.text = "No mobile network available"
        }
        //! Check if message is empty.
        else if( twitSenderInfoID.messageText.text.length === 0 ) {
            //! Display error message.
            twitSenderInfoID.infobanner.text = "Enter tweet message";
            twitSenderInfoID.messageText.forceActiveFocus();
        }
        //! check if Flight mode is on
        else if (qmDeviceMode.deviceMode === "Flight mode") {
            twitSenderInfoID.infobanner.text = "No mobile network available"
            twitSenderInfoID.messageText.forceActiveFocus();
            twitSenderInfoID.messageText.closeSoftwareInputPanel();
        }
        //! check if Operator support is there
        else if (myTwitterCode.operatorSupportInfo() === false) {
            twitSenderInfoID.infobanner.text = "Operator not supporting"
            twitSenderInfoID.messageText.forceActiveFocus();
            twitSenderInfoID.messageText.closeSoftwareInputPanel();
        } else {
            //! Disable required components.
            twitSenderInfoID.messageText.forceActiveFocus();
            twitSenderInfoID.messageText.closeSoftwareInputPanel();
            twitSenderInfoID.messageText.enabled = false;
            sheet.acceptButton.enabled = false;

            //! Send Tweet SMS.
            sendTweet(twitSenderInfoID.contactsInput.text);

            //! Check if message was sent successfully.
            if (myMessenger.msgSent === true) {
                //! Set message text to disbaled color.
                twitSenderInfoID.messageText.color = "#b2b2b4"

                //! Reset display message to wipe out message buffer.
                twitSenderInfoID.infobanner.text = "";

                // Set accept button text.
                sheet.acceptButtonText = "Sent";
            } else {
                //! Show error message.
                twitSenderInfoID.infobanner.text = "Error sending tweet";

                //! Reenable required components.
                sheet.acceptButton.enabled = true;
                twitSenderInfoID.messageText.enabled = true;
                twitSenderInfoID.messageText.forceActiveFocus();
                twitSenderInfoID.messageText.openSoftwareInputPanel();
            }
        }

        //! Display message.
        if ( twitSenderInfoID.infobanner.text.length > 0 )
            twitSenderInfoID.infobanner.show();
    }

    //! Function to process the logic on clicking the cancel button
    function cancelButtonClicked()
    {
        //! Keypad is active so force active focus.
        twitSenderInfoID.messageText.forceActiveFocus();
        twitSenderInfoID.messageText.closeSoftwareInputPanel();

        //! Pop page stack.
        pageStack.pop();
    }

    Component.onCompleted: {
        //! After page is loaded, open the sheet
        sheet.open();
    }

    Sheet {
        id: sheet
        acceptButtonText: "Send"
        rejectButtonText: "Cancel"
        anchors.fill: parent

        content: TwitSenderInfo { id: twitSenderInfoID }

        onAccepted: {
            //! By default Accept button closes the sheet. Here opening the sheet again.
            sheet.open();

            //! Send button functionality implemented in sendButtonClicked() method
            sendButtonClicked();
        }

        onRejected: {
            //! Cancel button functionality implemented in cancelButtonClicked() method
            cancelButtonClicked();
        }
    }

    //! Class component for sending message
    TwitSender {
        id: myTwitterCode
        property bool msgSent
    }

    //! Class component for sending message
    Messenger {
        id: myMessenger
        property bool msgSent

        onStateChanged: {
            twitSenderInfoID.spinner.opacity=0.0;
            twitSenderInfoID.spinner.running = false;
            sheet.acceptButtonText = "Sent"
            twitSenderInfoID.messageText.enabled = false;
        }
    }

    //! DeviceInfo element allows you to access information about the device
    DeviceInfo { id: deviceInfo }

    //! QmDeviceModeReader element allows to access information about
    //! the device mode(Flight mode/Normal Mode)
    QmDeviceModeReader { id: qmDeviceMode }
}

//! End of File
