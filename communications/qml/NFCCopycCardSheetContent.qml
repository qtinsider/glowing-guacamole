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
import QtMobility.connectivity 1.2
import QtMobility.sensors 1.2
import QtMobility.systeminfo 1.2
import QtMobility.feedback 1.1
import QtMultimediaKit 1.1
import com.nokia.harmattanapishowcase 1.0

Item  {
   id: nfcCopycCardItem
   anchors.fill: parent

   //! Fill the whole page with red color for 1000ms when error occurred.
   Rectangle {
       id: fillOnError
       color: "red"
       opacity: 0.0
       anchors.fill: parent

       PropertyAnimation {
           id: hideanimation
           target: fillOnError
           property: "opacity"
           to: 0.0
           duration: 1000
       }

       PropertyAnimation {
           id: visibleanimation
           target: fillOnError
           property: "opacity"
           to: 1.0
           duration: 1000
       }

       PropertyAnimation {
           id: hidepageelements
           targets: [background, buttonRect, label,infotext]
           property: "visible"
           to: false
           duration: 500
       }

       PropertyAnimation {
           id: showpageelements
           targets: [background, buttonRect, label,infotext]
           property: "visible"
           to: true
           duration: 500
       }
   }

   //! Timer to show error screen in case of an error
   //! Timer running for 2sec.
   Timer {
       id: animatetimer
       interval: 2000
       repeat: false
       triggeredOnStart: false

       onTriggered: {
           showpageelements.running = true;
           hideanimation.running = true;
       }
   }

   //! Interface for NdefManager Implementation
   NfcSendvCard {
       id: sendvCard

       function initNfc() {
           sendvCard.initAndStartNfc();
       }

       Component.onCompleted: initNfc()

       //! Display the status of the NFC detection and write events
       //! In an event of error reading message from NFC tag
       onNfcReadTagError: {
           visibleanimation.running = true;
           hidepageelements.running = true;
           animatetimer.start();
           infobanner.text = nfcTagError;
           infobanner.timerShowTime = 10000;
           infobanner.show();
           audiofeedback.source = "media/error.wav";

           //! plays a rumble effect
           rumbleEffect.start();
           audiofeedback.play();
       }

       //! In an event of error during reading or writing messages to NFC tag
       onNfcStatusError: {
           infobanner.text = nfcStatusErrorText;
           infobanner.timerShowTime = 10000;
           infobanner.show();
           audiofeedback.source = "media/error.wav";
           audiofeedback.play();

           //! Plays a rumble effect
           rumbleEffect.start();
       }

       //! In an event of status of NearFieldManager changes.
       onNfcStatusUpdate: {
           infobanner.text = nfcStatusText;
           infobanner.timerShowTime = 5000;
           infobanner.show();
           audiofeedback.source = "media/beep.wav";
           audiofeedback.play();
       }
   }

   //! QML element to cause rumble effect.
   HapticsEffect {
       id: rumbleEffect
       attackIntensity: 0.5
       attackTime: 250
       intensity: 1.0
       duration: 100
       fadeTime: 250
       fadeIntensity: 0.0
   }

   //! Using QML audio element to play file
   Audio {
       id: audiofeedback
       volume: 1.0
       onStopped: source = ""
   }

   //! Check if the version is PR 1.0 or PR 1.1
   function checkOSversion(stringValue) {
       if (stringValue.indexOf("DFL61_HARMATTAN_1") == -1)
           //! Not PR 1.0
           return false;
       else
           //! PR 1.0
           return true;
   }

   //! Using ProximitySensor to read the proximity status
   ProximitySensor {
       id: proximitySensor
       active: true

       onReadingChanged: {
           //! Do not proceed if OS version is PR 1.0 or the device model is N950
           if ((deviceInfo.model == "N950") || (checkOSversion(generalInfo.firmwareVersion))) {
               infobanner.text = "Feature not supported on this device"
               infobanner.show();
           }
           else if (reading.close) {
               sendvCard.nfcWritevCard(addressbookpage.contactid)
           }
       }
   }

   //! Create GeneralInfo element
   GeneralInfo {
       id: generalInfo
   }

   //! Create DeviceInfo element
   DeviceInfo {
       id: deviceInfo
   }

   //! Information Banners to convey alerts and information to user
   InfoBanner {
       id: infobanner
       anchors.bottom: parent.bottom
       anchors.bottomMargin: 10
       timerEnabled: true
   }

   //! Background Image for the contact detail page.
   Item {
       id: background
       anchors.top: parent.top
       width: parent.width
       height: 425

       Image {
           id: backgroundimg
           source: "image://theme/meegotouch-sharing-thumbnail-area-background"
           width: parent.width
           anchors.fill: parent

           Image {
               id: avatarimg
               source: "image://theme/icon-l-sharing-avatar-placeholder"
               anchors.centerIn: parent
           }
       }
   }

   //! Highlight for the contact name display
   Rectangle {
       id: label
       anchors { top: background.bottom }
       width: parent.width
       height: 100
       color: "darkgray"

       //! Display contact first or last name whichever exists
       Text {
           id: contactname
           anchors.top: label.top
           anchors.topMargin: 15
           anchors.left: label.left
           anchors.leftMargin: 20
           color: "white"
           text: addressbookpage.contactName
           width: label.width
           font { bold: true; pixelSize: 32 }
           wrapMode: Text.Wrap
           elide: Text.ElideRight
       }

       //! Display text "Contact card"
       Text {
           id: contacttext
           anchors {
               top: contactname.bottom
               topMargin: 6
               left: label.left
               leftMargin: 20
           }
           width: label.width
           text: "Contact card"
           color: "white"
           opacity: .6
           font.pixelSize: 26
           wrapMode: Text.Wrap
           elide: Text.ElideRight
           maximumLineCount: 1
       }
   }

   //! Text field to show the instructions for copying the contact to the NFC tag.
   Text {
       id: infotext
       anchors {
           top: label.bottom
           topMargin: 30
           left: label.left
           leftMargin: 20
           right: label.right
           rightMargin: 20
       }
       width: label.width
       text: "To send vCard, cover the screen and hold device close to NFC tag."
       color: "black"
       font.pixelSize: 26
       wrapMode: Text.Wrap
       elide: Text.ElideRight
       maximumLineCount: 2
   }

}
