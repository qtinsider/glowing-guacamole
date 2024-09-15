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
 * @brief Includes sample code for QtMobility DisplayInfo demo
 * Show list of display information properties and its values.
 */
Item {
    id: displayInfoPage

    anchors.fill: parent

    /*!
     * QtMobility.systeminfo 1.2 module has DisplayInfo element that allows
     * to access information about the display. backlightStatus property
     * holds integer enumeration that represent backlight state of the
     * screen.
     *
     * Function converts integer value of backlight state into text format.
     */
    function backlightState() {
        var state = "";

        switch(displayInfo.backlightStatus)
        {
        case DisplayInfo.BacklightStateUnknown:
            state = "Unknown";
            break;
        case DisplayInfo.BacklightStateOff:
            state = "Off";
            break;
        case DisplayInfo.BacklightStateDimmed:
            state = "Dimmed";
            break;
        case DisplayInfo.BacklightStateOn:
            state = "On";
            break;
        default:
            state = "Not Available";
            break;
        }
        return state;
    }

    /*!
     * Instance of QtMobility DisplayInfo
     * The DisplayInfo element allows to get information and receive notifications about
     * the display.
     */
    DisplayInfo {
        id: displayInfo
    }

    /*!
     * Custom defined class to get Content Adaptive Backlight Control (CABC) mode from QmCABC
     * Check systems/systeminfo/qmcabcreader.h for details
     */
    QmCABCReader {
        id: qmCABC
    }

    /*!
     * Custom defined class to get device display state information from QmDisplayState
     * Check systems/systeminfo/qmdisplaystatereader.h for details
     */
    QmDisplayStateReader {
        id: qmDisplayState
    }

    /*!
     * Custom PageHeader component
     */
    PageHeader {
        id: pageTitle

        height: parent.width < parent.height ? uiConstants.HeaderDefaultHeightPortrait
                                             : uiConstants.HeaderDefaultHeightLandscape
        width: parent.width
        text: "Display"
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

        //! Defining scrollable area
        Flickable {
            id: bodyFlick
            anchors.fill: parent
            contentHeight: displayData.height

            Item {
                anchors.top: parent.top

                //! Information of device's display aligned vertically in a column
                Column {
                    id: displayData
                    spacing: 16

                    //! Display color depth
                    Column {
                        spacing: 5

                        Label {
                            text: "Color depth"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: displayInfo.colorDepth > -1
                                  ? displayInfo.colorDepth  + " bits" : "Not Available"
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display contrast
                    Column {
                        spacing: 5

                        Label {
                            text: "Contrast"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: displayInfo.contrast > -1 ? displayInfo.contrast : "Not Available"
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display brightness
                    Column {
                        spacing: 5

                        Label {
                            text: "Brightness"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: displayInfo.displayBrightness > -1
                                  ? displayInfo.displayBrightness + "%" : "Not Available"
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display Dots Per Inch (DPI)
                    Column {
                        spacing: 5

                        Label {
                            text: "Dots Per Inch (DPI)"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: (displayInfo.dpiHeight > -1 && displayInfo.dpiWidth > -1)
                                  ? displayInfo.dpiHeight + "x" + displayInfo.dpiWidth + " dpi"
                                  : "Not Available"
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Show display size
                    Column {
                        spacing: 5

                        Label {
                            text: "Size"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: (displayInfo.physicalHeight > -1
                                   && displayInfo.physicalWidth > -1)
                                  ? displayInfo.physicalHeight + "x" + displayInfo.physicalWidth + " mm"
                                  : "Not Available"
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Show backlight state
                    Column {
                        spacing: 5

                        Label {
                            text: "Backlight"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: backlightState()
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Show CABC mode
                    Column {
                        spacing: 5

                        Label {
                            text: "CABC mode"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: qmCABC.mode
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Show display state
                    Column {
                        spacing: 5

                        Label {
                            text: "Display state"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: qmDisplayState.displayState
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Show dimming timeout
                    Column {
                        spacing: 5

                        Label {
                            text: "Dimming timeout"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: qmDisplayState.dimTimeout > -1
                                  ? qmDisplayState.dimTimeout + " sec" : "Not Available"
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Show blanking timeout
                    Column {
                        spacing: 5

                        Label {
                            text: "Blanking timeout"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: qmDisplayState.blankTimeout > -1
                                  ? qmDisplayState.blankTimeout + " sec" : "Not Available"
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }
                }
            }
        }

        //! Scroll decorator for the flickable area
        ScrollDecorator {
            flickableItem: bodyFlick
        }
    }
}

//!  End of File
