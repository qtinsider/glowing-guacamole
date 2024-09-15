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
import com.nokia.harmattanapishowcase 1.0

/*!
 * @brief Includes sample code for QmTime demo
 * Show list of system time settings and its values.
 */
Item {
    id: systemStatesPage
    anchors.fill: parent

    /*!
     * Custom defined class to get system state information from QmTimeReader
     * Check systems/systeminfo/qmtimereader.h for details
     */
    QmTimeReader {
        id: qmTime
    }

    /*!
     * Custom PageHeader component
     */
    PageHeader {
        id: pageTitle

        height: parent.width < parent.height ? uiConstants.HeaderDefaultHeightPortrait
                                             : uiConstants.HeaderDefaultHeightLandscape
        width: parent.width
        text: "Time settings"
    }

    /*!
     * Item holds main text area of the page. Area is scrollable vertically
     * and text data arranged in a column.
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

        Flickable {
            id: bodyFlick
            anchors.fill: parent
            contentHeight: timeData.height

            Item {
                anchors.top: parent.top

                //! Displaying time information arranged in a column
                Column {
                    id: timeData
                    spacing: 16

                    //! Show system time status
                    Column {
                        spacing: 5

                        Label {
                            text: "System time status"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: qmTime.autoSystemTime
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Show time zone status
                    Column {
                        spacing: 5

                        Label {
                            text: "Time zone status"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: qmTime.autoTimeZone
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Show current time zone
                    Column {
                        spacing: 5

                        Label {
                            text: "Current time zone"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: qmTime.timezone
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Show automatically guessed time zone
                    Column {
                        spacing: 5

                        Label {
                            text: "Automatically guessed time zone"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: qmTime.timezoneAuto
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Show time updates from operator
                    Column {
                        spacing: 5

                        Label {
                            text: "Time updates from operator"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: qmTime.timeFromOperator
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Show default time zone from manufacture
                    Column {
                        spacing: 5

                        Label {
                            text: "Default time zone from manufacture"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: qmTime.defaultTimeZone
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Show automatic time at local time zone
                    Column {
                        spacing: 5

                        Label {
                            text: "Automatic time at local time zone"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: qmTime.localTime
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }
                }
            }
        }
    }
}

//!  End of File
