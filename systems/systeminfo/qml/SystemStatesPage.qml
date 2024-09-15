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
 * @brief Includes sample code for QmSystemState demo
 * Show list of system states and its values.
 */
Item {
    id: systemStatesPage

    anchors.fill: parent

    /*!
     * Custom defined class to get system state information from QmSystemState
     * Check systems/systeminfo/qmsystemstatereader.h for details
     */
    QmSystemStateReader {
        id: qmSystemState
    }

    /*!
     * Custom PageHeader component
     */
    PageHeader {
        id: pageTitle

        height: parent.width < parent.height ? uiConstants.HeaderDefaultHeightPortrait
                                             : uiConstants.HeaderDefaultHeightLandscape
        width: parent.width
        text: "System states"
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
            right:  parent.right
            margins: uiConstants.DefaultMargin
        }

        //! Displaying system states information arranged in a column
        Column {
            id: statesData
            spacing: 16

            //! Show total time device was power on
            Column {
                spacing: 5

                Label {
                    text: "Total power on time"
                    font: uiConstants.TitleFont
                }
                Label {
                    text: Math.floor(qmSystemState.powerOnTime/60) > 0
                          ? Math.floor(qmSystemState.powerOnTime/60) + " hours "
                            + (qmSystemState.powerOnTime - 60 * Math.floor(qmSystemState.powerOnTime/60))
                            + " minutes"
                          : qmSystemState.powerOnTime + " minutes"
                    font: uiConstants.SubtitleFont
                    color: rootWindow.secondaryForeground
                }
            }

            //! Show last boot reason
            Column {
                spacing: 5

                Label {
                    text: "Boot reason"
                    font: uiConstants.TitleFont
                }
                Label {
                    text: qmSystemState.bootReason
                    font: uiConstants.SubtitleFont
                    color: rootWindow.secondaryForeground
                }
            }

            //! Show current run state
            Column {
                spacing: 5

                Label {
                    text: "Run state"
                    font: uiConstants.TitleFont
                }
                Label {
                    text: qmSystemState.runState
                    font: uiConstants.SubtitleFont
                    color: rootWindow.secondaryForeground
                }
            }
        }
    }
}

//!  End of File
