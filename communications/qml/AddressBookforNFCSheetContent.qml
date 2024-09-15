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

//! using contact model supplied by the Contact QML plugin
import QtMobility.contacts 1.1

Item  {
   id: addressBookItem
   anchors.fill: parent

   //! property accessed by the AddressBookforNFC.qml
   property alias blankscreentextVisibility: blankscreentext.visible

   //! Text to display when no Contacts exist on the device
   Text {
       id: blankscreentext
       text: "No Contacts"
       font.pixelSize: 48
       opacity: 0.7

       anchors {
           verticalCenter: parent.verticalCenter
           horizontalCenter: parent.horizontalCenter
       }

       visible: false
       color: "black"
   }

   //! Spinner to indicate contacts are loading
   BusyIndicator {
       id: spinner
       platformStyle: BusyIndicatorStyle { size: "large" }
       anchors.centerIn: parent
       opacity: (blankscreentext.visible === false ? (contactListView.count > 0? 0 : 1) : 0 )
       running: (blankscreentext.visible === false ? (contactListView.count > 0?  false : true) : false )
   }

   //! List View to display the contacts from the contactModel
   ListView {
       id: contactListView

       anchors {
           top: parent.top
           bottom: parent.bottom
           left: parent.left
           right: parent.right
       }

       model: phonebookModel.contacts
       delegate: contactDelegate
       clip: true

       section.property: "displayLabel"
       section.criteria: ViewSection.FirstCharacter

       section.delegate: Item {
           //! Set width and height.
           width: parent.width;
           height: 40

           Text {
               id: headerLabel

               anchors {
                   right: parent.right
                   bottom: parent.bottom
                   rightMargin: 20
                   bottomMargin: 2
               }

               font: uiConstants.GroupHeaderFont
               color: rootWindow.secondaryForeground
               text: section.toUpperCase();
           }

           Image {
               anchors {
                   right: headerLabel.left
                   left: parent.left
                   leftMargin: uiConstants.DefaultMargin
                   verticalCenter: headerLabel.verticalCenter
                   rightMargin: 24
               }

               source: "image://theme/meegotouch-groupheader"
                       + (theme.inverted ? "-inverted" : "") + "-background"
           }
       }

       onCountChanged: {
           if (contactListView.count && blankscreentext.visible == true) {
               blankscreentext.visible = false
           } else if ( !firstCountChange && contactListView.count == 0 ) {
               blankscreentext.visible = true
           }

           firstCountChange = false
       }
   }

   //! ContactModel to provide requests and data access to contact store
   ContactModel {
       id: phonebookModel
       autoUpdate: true

       filter: UnionFilter {
           DetailFilter {
                     detail: ContactDetail.Name
                     field:  Name.FirstName
                 }
           DetailFilter {
                     detail: ContactDetail.Name
                     field:  Name.LastName
                 }
           DetailFilter {
                     detail: ContactDetail.NickName
                     field:  Nickname.NickName
                 }
       }

       sortOrders: SortOrder {
           detail: ContactDetail.DisplayLabel
           direction: Qt.AscendingOrder
           caseSensitivity: Qt.CaseInsensitive
       }
   }

   //! Delegate for each contact item
   Component {
       id: contactDelegate

       Item {
           id: listItem
           width: parent.width
           height: 80

           BorderImage {
               id: background

               anchors {
                   fill: parent
                   leftMargin: -addressbookpage.anchors.leftMargin
                   rightMargin: -addressbookpage.anchors.rightMargin
               }

               visible: mouseArea.pressed
               source: "image://theme/meegotouch-list-inverted-background-pressed-center"
           }

           Image {
               id: contactImage
               height: 60
               width: 60
               source: "image://theme/meegotouch-avatar-placeholder-background"

               anchors {
                   verticalCenter: parent.verticalCenter
                   left: parent.left
                   leftMargin: uiConstants.DefaultMargin
               }

               smooth: true

               Image {
                   id: contactPic
                   anchors.fill: parent
                   source: avatar.imageUrl

                   onStatusChanged: if (status === Image.Error)
                                        contactPic.source = ""
               }

               Text {
                   id: tagName
                   anchors.centerIn: parent
                   color: "white"
                   font { bold: true; pixelSize: 32 }
                   opacity: (contactPic.source == "") ? 1.0 : 0.0
                   text: (name.firstName !== "" || name.lastName  !== "")?
                             ((firstChar(name.firstName)).toUpperCase()
                              +(firstChar(name.lastName)).toUpperCase()):((firstChar(nickname.nickname)).toUpperCase())
               }
           }

           Image {
               id: maskedImage
               height: 60
               width: 60
               source: "image://theme/meegotouch-avatar-mask-small"

               anchors {
                   verticalCenter: parent.verticalCenter
                   left: parent.left
                   leftMargin: uiConstants.DefaultMargin
               }

               smooth: true
               opacity: 0.0
           }

           Label {
               id: contactName
               width: parent.width - (contactPic.width + uiConstants.DefaultMargin + 20)
               anchors {
                   left: contactImage.right
                   leftMargin: 20
                   verticalCenter: parent.verticalCenter
                   rightMargin: uiConstants.DefaultMargin
               }

               font: uiConstants.TitleFont
               wrapMode: Text.Wrap
               elide: Text.ElideRight
               color: "black"
               text: displayLabel
               maximumLineCount: 1
           }

           MouseArea {
               id: mouseArea
               anchors.fill: background

               onClicked: {
                   addressbookpage.contactid = phonebookModel.contacts[index].contactId

                   if(phonebookModel.contacts[index].name.firstName !== "")
                       addressbookpage.contactName = phonebookModel.contacts[index].name.firstName;
                   else if(phonebookModel.contacts[index].name.lastName !== "")
                       addressbookpage.contactName = phonebookModel.contacts[index].name.lastName;
                   else
                       addressbookpage.contactName = phonebookModel.contacts[index].nickname.nickname;

                   addressbookpage.openFile("NfcCopyvCard.qml")
               }

               onReleased: background.visible = false
           }
       }
   }

   ScrollDecorator {
       flickableItem: contactListView
   }
}
