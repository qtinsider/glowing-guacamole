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
import QtMobility.systeminfo 1.2

/*!
 * @brief Includes sample code for QtMobility StorageInfo demo
 * Show list of logical drives and used/total space.
 */
Item {
    id: storageInfoPage

    anchors.fill: parent

    //! Total storage calculation
    function totalStorage() {
        var f = 0;

        for (var i = 0; i < storageInfo.logicalDrives.length; i++) {
            //! Summarize amount of total space on the every existing logical drive
            f += storageInfo.totalDiskSpace(storageInfo.logicalDrives[i])
        }

        //! Convert bytes to Gb
        return ((f/1073741824).toFixed(1));
    }

    //! Instance of QtMobility StorageInfo
    StorageInfo {
        id: storageInfo
    }

    /*!
     * Custom PageHeader component
     */
    PageHeader {
        id: pageTitle

        height: parent.width < parent.height ? uiConstants.HeaderDefaultHeightPortrait
                                             : uiConstants.HeaderDefaultHeightLandscape
        width: parent.width
        text: "Storage"
    }

    /*!
     * Item holds main text area of the page. Text data arranged in a column.
     */
    Item {
        id: bodyText
        anchors {
            top: pageTitle.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: uiConstants.DefaultMargin
        }

        Item {
            anchors.top: parent.top

            //! Displaying storage information arranged in a column
            Column {
                id: storageData
                spacing: 16

                //! Display total storage value
                Column {
                    spacing: 5

                    Label {
                        text: "Total storage"
                        font: uiConstants.TitleFont
                    }

                    Label {
                        text: totalStorage() + " GB"
                        font: uiConstants.SubtitleFont
                        color: rootWindow.secondaryForeground
                    }
                }

                //! Display storage value used for installed apps
                Column {
                    spacing: 5

                    Label {
                        text: "Installed apps"
                        font: uiConstants.TitleFont
                    }

                    //! Logical drive "/" used for Installed applications
                    Label {
                        /*!
                         * Functions availableDiskSpace and totalDiskSpace return results in bytes.
                         * To display it in Gb result is devided by 1073741824.
                         * toFixed(1) formats number to have only 1 digit in decimals.
                         */
                        text: ((storageInfo.totalDiskSpace("/")
                                - storageInfo.availableDiskSpace("/"))/1073741824).toFixed(1)
                              + " / " + (storageInfo.totalDiskSpace("/")/1073741824).toFixed(1)
                              + " GB"
                        font: uiConstants.SubtitleFont
                        color: rootWindow.secondaryForeground
                    }
                }

                //! Display storage value used for application data
                Column {
                    spacing: 5

                    Label {
                        text: "Application data"
                        font: uiConstants.TitleFont
                    }

                    //! Logical drive "/home" used for Application data
                    Label {
                        text: ((storageInfo.totalDiskSpace("/home")
                                - storageInfo.availableDiskSpace("/home"))/1073741824).toFixed(1)
                              + " / " + (storageInfo.totalDiskSpace("/home")/1073741824).toFixed(1)
                              + " GB"
                        font: uiConstants.SubtitleFont
                        color: rootWindow.secondaryForeground
                    }
                }

                //! Display storage value used for user data
                Column {
                    spacing: 5

                    Label {
                        text: "User data"
                        font: uiConstants.TitleFont
                    }

                    //! Logical drive "/home/user/MyDocs" used for User data
                    Label {
                        text: ((storageInfo.totalDiskSpace("/home/user/MyDocs")
                                - storageInfo.availableDiskSpace("/home/user/MyDocs"))/1073741824).toFixed(1)
                              + " / " + (storageInfo.totalDiskSpace("/home/user/MyDocs")/1073741824).toFixed(1)
                              + " GB"
                        font: uiConstants.SubtitleFont
                        color: rootWindow.secondaryForeground
                    }
                }
            }
        }
    }
}

//!  End of File
