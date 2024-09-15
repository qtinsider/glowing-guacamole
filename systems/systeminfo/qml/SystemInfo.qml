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

/*!
 * @brief System information
 * Display list of all available system info demos
 */
Page {
    id: systemInfoList

    //! Propert holding page number that need to be opened
    property int pageNumber: 0

    //! Main window margins apply
    anchors.margins: uiConstants.DefaultMargin

    //! Using common toolbar defined in main/qml/main.qml
    tools: commonTools

    /*!
     * Make new page component and push it into stack. Function from rootWindow can't be used here
     * as created component should have access to pageNumber property.
     */
    function openFile(file) {
        var component = Qt.createComponent(file)
        if (component.status === Component.Ready)
            pageStack.push(component);
        else
            console.log("Error loading component:", component.errorString());
    }

    //! List model of all available pages
    ListModel {
        id: systemInfoModel

        ListElement { title: "Battery"; subtitle: "QtSystemInfo, QmSystem" }
        ListElement { title: "Device"; subtitle: "QtSystemInfo, QmSystem" }
        ListElement { title: "Display"; subtitle: "QtSystemInfo, QmSystem" }
        ListElement { title: "General information"; subtitle: "QtSystemInfo" }
        ListElement { title: "Network"; subtitle: "QtSystemInfo" }
        ListElement { title: "Storage"; subtitle: "QtSystemInfo" }
        ListElement { title: "System states"; subtitle: "QmSystem" }
        ListElement { title: "Time settings"; subtitle: "QmSystem" }
    }

    //! List view to display demos for System information
    ListView {
        id: listView
        anchors.fill: parent
        model: systemInfoModel
        visible: ( rootWindow.pageStack.depth !== 1 ) ? true : false

        delegate: ListDelegate {
            //! Arrow image
            Image {
                id: arrowImage
                source: "image://theme/icon-m-common-drilldown-arrow"
                        + (theme.inverted ? "-inverse" : "")
                anchors { right: parent.right; verticalCenter: parent.verticalCenter }
            }

            onClicked: {
                listView.currentIndex = index

                //! Setting pageNumber property
                systemInfoList.pageNumber = index
                systemInfoList.openFile("SystemInfoView.qml")
            }
        }
    }

    //! Scroll decorator for list
    ScrollDecorator {
        flickableItem: listView
    }
}

//!  End of File
