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
import QtMultimediaKit 1.1

//! AddChannelSheet container
Sheet {
    id: sheet
    acceptButtonText: "Save"
    rejectButtonText: "Cancel"

    //! sheet properties
    property int index : -1
    property alias title : radioNameField.text
    property alias uri : radioUrlField.text
    property alias favorite : addToFavoritesSwitch.checked
    property bool editMode : false 

    //! "Searching stream" mode
    Column {
        visible: !addChannelForm.visible
        z: 1
        anchors.centerIn: parent
        spacing: uiConstants.DefaultMargin*2

        Label {
            text: "Searching stream"
            anchors.horizontalCenter: parent.horizontalCenter
            font: uiConstants.HeaderFont
        }

        BusyIndicator  {
            id: radioNameDetection
            anchors.horizontalCenter: parent.horizontalCenter
            running: true
            platformStyle: BusyIndicatorStyle { size: "large" }
        }
    }

    //! QML Audio element for getting the metadata and channel name
    Audio {
            id: channelPrePlayer
            autoLoad: true
            muted: true

            onError: {
                addChannelForm.visible = true;
                infoField.visible = true;
                infoField.height = 80;
                getButton("acceptButton").enabled = false;
            }
            onStatusChanged: {
                if (channelPrePlayer.status === Audio.Loaded) {
                    addChannelForm.visible = true;
                    radioNameColumn.height = undefined;
                    channelPrePlayer.stop();
                    getButton("acceptButton").enabled = true;
                }
            }
        }

    //! reset sheet on visible change
    onVisibleChanged: {
        if (visible) {
            getButton("acceptButton").enabled = false;
            radioUrlField.focus = true;
        }
    }

    //! toggle toolbar on status change
    onStatusChanged: {
        if (status === DialogStatus.Opening) {
            rootWindow.showToolBar = false;
        } else if (status === DialogStatus.Closed) {
            rootWindow.showToolBar = true;
        }
    }

    //! add new channel to model when "Save" is pressed and destroy the sheet from memory
    onAccepted: {
        channelModelProxy.append(title,uri,favorite);
        channelModel.sort(0);

        index = -1;
        title = channelPrePlayer.metaData.publisher;
        uri = "";
        favorite = false;
        radioNameColumn.height = 0;

        rootWindow.showToolBar = true;
        channelPrePlayer.stop();

        sheet.destroy();
    }

    //! restore toolbar and destroy the sheet when "Cancel" is pressed
    onRejected:  {
        rootWindow.showToolBar = true;
        channelPrePlayer.stop();

        sheet.destroy();
    }

    //! The sheet content
    content: Flickable {
             id: flickable
             anchors.fill: parent
             contentWidth: col2.width
             contentHeight: col2.height + infoField.height
             flickableDirection: Flickable.VerticalFlick

             //! The error message container
             Rectangle {
                 id: infoField
                 color: "red"
                 height: (channelPrePlayer.error) ? 80 : 0
                 visible: (channelPrePlayer.error)
                 width: sheet.width
                 Label {
                     anchors {
                         centerIn: parent
                     }
                     font: uiConstants.SmallTitleFont
                     text: channelPrePlayer.errorString
                     color: "white"
                 }
                 Behavior on height {
                     NumberAnimation { duration: 250 }
                 }
             }

             //! The sheet content container
             Column {
                 id: col2
                 anchors {
                     top: infoField.bottom
                     left: parent.left
                     margins: uiConstants.DefaultMargin
                 }
                 width: sheet.width - uiConstants.DefaultMargin*2
                 spacing: uiConstants.DefaultMargin


                 //! the form contents in a column
                 Column {
                     id: addChannelForm
                     width: parent.width
                     spacing: parent.spacing

                     //! radio name
                     Column {
                         id: radioNameColumn
                         width: parent.width - parent.spacing
                         height: editMode ? undefined : ((channelPrePlayer.metaData.publisher!==undefined) ?  undefined : 0)
                         visible: (height!==0)
                         spacing: uiConstants.DefaultMargin

                         Behavior on height {
                             NumberAnimation { duration: 250 }
                         }

                         Label {
                             text: "Radio name"
                         }
                         Row {
                             spacing: uiConstants.DefaultMargin
                             width: parent.width

                             TextField {
                                 id: radioNameField
                                 width: parent.width
                                 placeholderText: "Type name here"
                                 platformStyle: TextFieldStyle {
                                     background: "image://theme/meegotouch-textedit-inverted-background"
                                     backgroundSelected: "image://theme/meegotouch-textedit-inverted-background-selected"
                                     backgroundDisabled: "image://theme/meegotouch-textedit-inverted-background-disabled"
                                     backgroundError: "image://theme/meegotouch-textedit-inverted-background-error"
                                 }
                                 text: (channelPrePlayer.metaData.publisher!==undefined) ? channelPrePlayer.metaData.publisher : ""
                             }

                         }
                     }

                     //! radio url
                     Column {
                         width: parent.width - parent.spacing
                         Label {
                             text: "Radio url"
                         }
                         TextField {
                             id: radioUrlField
                             width: parent.width - parent.spacing
                             placeholderText: "http://[ip address:port]"
                             focus: true
                             style: TextFieldStyle {
                                 background: "image://theme/meegotouch-textedit-inverted-background"
                                 backgroundSelected: "image://theme/meegotouch-textedit-inverted-background-selected"
                                 backgroundDisabled: "image://theme/meegotouch-textedit-inverted-background-disabled"
                                 backgroundError: "image://theme/meegotouch-textedit-inverted-background-error"
                             }
                             function urlHasChanged() {
                                 if (editMode===false && radioNameField.text==="") {
                                     if (activeFocus===false) {
                                         if (focus===false && text!=="") {
                                            infoField.visible = false;
                                            infoField.height = 0;
                                            channelPrePlayer.source = text;
                                            addChannelForm.visible = false;
                                            getButton("acceptButton").enabled = false;
                                         }
                                     }
                                 }
                             }

                             onTextChanged: {
                                 urlHasChanged();
                             }
                             onActiveFocusChanged: {
                                 urlHasChanged();
                             }
                         }
                     }

                     //! favorites
                     Row {
                         spacing: 20
                         width: parent.width - parent.spacing
                         Label {
                             text: "Add to favorites"
                             width: parent.width - addToFavoritesSwitch.width - parent.spacing
                             anchors.verticalCenter: parent.verticalCenter
                         }
                         Switch {
                            id: addToFavoritesSwitch
                            checked: false
                            style: SwitchStyle {
                                switchOn: "image://theme/meegotouch-switch-on-inverted"
                                switchOff: "image://theme/meegotouch-switch-off-inverted"
                            }
                         }
                     }
                 }
            }
    }
}
