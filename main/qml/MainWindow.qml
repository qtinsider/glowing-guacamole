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

//! using system systemInfo componentsupplied by qt Mobility components.
import QtMobility.systeminfo 1.2

/*!
 * @brief  This is a main page of the application. It shows a list of all examples
 * available in the application. List is divided to logical sections.
 */
Page {
    id: listPage
    tools: commonTools

    //! Page title contains label with application name.
    PageHeader {
        id: headerholder
        text: "Harmattan API Showcase"
        visible: (pageStack.busy && theme.inverted) ? false : true
    }

    /*!
    *  Item holds main page area, which contains list of available examples
    */
    Item {
        anchors {
            top: headerholder.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: uiConstants.DefaultMargin
        }

        visible: (pageStack.busy && theme.inverted) ? false : true

        ListView {
            id: listView
            anchors.fill: parent
            model: ExampleSections {}
            keyNavigationWraps: true
            visible: (pageStack.depth === 1) ? true : false

            delegate: ListDelegate {
                onClicked: {
                    listView.currentIndex = index

                    if (page === "../../communications/qml/SMSSender.qml"
                            || page === "../../communications/qml/TwitSender.qml") {
                        if (deviceInfo.simStatus !== 0 &&  myMessenger.networkStatus() !== false) {
                            rootWindow.openFile(page);

                        } else {
                            infobanner.text = "No Active SIM"
                            infobanner.show();
                        }
                    } else if (page == "../../location/geocoding/qml/Location.qml"
                               && !appSettings.accepted) {
                        rootWindow.openFile(page)
                        acceptDialog.open();
                    } else {
                        rootWindow.openFile(page)
                    }
                }
            }

            //! List sections
            section.property: "section"
            section.criteria: ViewSection.FullString

            //! Section delegate consists of separator image and section name text
            section.delegate: Item {
                id: textblock
                width: listView.width
                height: 20

                //! Section separator image
                Image {
                    anchors {
                        right: text.left
                        left: parent.left
                        verticalCenter: text.verticalCenter
                        rightMargin: 24
                    }

                    source: "image://theme/meegotouch-groupheader"
                            + (theme.inverted ? "-inverted" : "") + "-background"
                }

                //! Section name
                Label {
                    id: text
                    anchors {
                        verticalCenter: parent.verticalCenter
                        top: parent.top
                        right: textblock.right
                    }

                    text: section
                    color: "#8c8c8c"
                    font: uiConstants.GroupHeaderFont
                }
            }
        }
    }

    InfoBanner {
        id: infobanner
        z: 3
        timerEnabled: true;
        timerShowTime: 3000;
    }

    QueryDialog {
        id: acceptDialog
        icon: "/usr/share/icons/hicolor/80x80/apps/harmattanapishowcase80.png"
        message: "Using services or downloading content may involve transmitting large amount of "
                 + "data through your service provider's network. All the services may not be "
                 + "available or accurate at all the times. Your first consideration while using "
                 + "services in traffic has to be safety. Use of service may involve sending "
                 + "location information."

        acceptButtonText: "Accept"
        rejectButtonText: "Quit"
        titleText: "Harmattan API Showcase"

        onAccepted: appSettings.accepted = true

        onRejected: if (pageStack.depth > 1) pageStack.pop()
    }

    //! Used to access GConf values for the application
    AppSettings { id: appSettings }

    DeviceInfo {
        id: deviceInfo
    }

    //! Custom defined Class component for sending message
    Messenger {
        id: myMessenger
    }

    //! Section scroller
    SectionScroller {
        id: scroller
        z: 2
        listView: listView
    }
}

//! End of file
