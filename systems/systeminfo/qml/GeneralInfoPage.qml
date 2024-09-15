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
 * @brief Includes sample code for QtMobility GeneralInfo demo
 * Show list of general information properties and its values.
 */
Item {
    id: generalInfoPage

    anchors.fill: parent

    /*!
     * QtMobility.systeminfo 1.2 module has GeneralInfo element that allows
     * to access general system information. hasFeatureSupported function
     * returns true if feature given as parameter is supported, otherwise
     * returns false. Features of the device are described with
     * QSystemInfo::Feature enumeration.
     *
     * Function returns list of supported hardware features on device in
     * text format.
     */
    function supportedHardware() {
        var features = "";

        if (generalInfo.hasFeatureSupported(GeneralInfo.BluetoothFeature))
            features += "Bluetooth, ";

        if (generalInfo.hasFeatureSupported(GeneralInfo.CameraFeature))
            features += "Camera, ";

        //! Currently FM Radio not supported in Harmattan, only HW is there
        if (generalInfo.hasFeatureSupported(GeneralInfo.FmradioFeature))
            features += "FM Radio, ";

        if (generalInfo.hasFeatureSupported(GeneralInfo.IrFeature)) features += "Infrared, ";
        if (generalInfo.hasFeatureSupported(GeneralInfo.LedFeature)) features += "LED, ";

        if (generalInfo.hasFeatureSupported(GeneralInfo.MemcardFeature))
            features += "Memory card, ";

        if (generalInfo.hasFeatureSupported(GeneralInfo.UsbFeature)) features += "USB, ";
        if (generalInfo.hasFeatureSupported(GeneralInfo.VibFeature)) features += "Vibration, ";
        if (generalInfo.hasFeatureSupported(GeneralInfo.WlanFeature)) features += "WLAN, ";
        if (generalInfo.hasFeatureSupported(GeneralInfo.SimFeature)) features += "SIM, ";
        if (generalInfo.hasFeatureSupported(GeneralInfo.LocationFeature)) features += "GPS, ";

        if (generalInfo.hasFeatureSupported(GeneralInfo.VideoOutFeature))
            features += "Video out, ";

        if (generalInfo.hasFeatureSupported(GeneralInfo.HapticsFeature)) features += "Haptics, ";

        //! Currently FM transmitter not supported in Harmattan, only HW is there
        if (generalInfo.hasFeatureSupported(GeneralInfo.FmTransmitterFeature))
            features += "FM Radio transmitter ";

        return features;
    }

    /*!
     * Instance of QtMobility GeneralInfo
     * The GeneralInfo element allows to access general system information and
     * to receive notifications from the device.
     */
    GeneralInfo {
        id: generalInfo

        //! Handling current language change
        onCurrentLanguageChanged: {
            currentLang.text = "Current language: " + generalInfo.currentLanguage
            currentCountry.text = "Current country code: " + generalInfo.currentCountryCode
        }
    }

    /*!
     * Custom PageHeader component
     */
    PageHeader {
        id: pageTitle

        height: parent.width < parent.height ? uiConstants.HeaderDefaultHeightPortrait
                                             : uiConstants.HeaderDefaultHeightLandscape
        width: parent.width
        text: "General information"
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
            right:  parent.right
            margins: uiConstants.DefaultMargin
        }

        //! Defining scrollable area
        Flickable {
            id: bodyFlick
            anchors.fill: parent
            contentHeight: generalData.height

            Item {
                anchors.top: parent.top

                //! Displaying various general information from the system
                Column {
                    id: generalData
                    spacing: 16

                    //! Show firmware version
                    Column {
                        spacing: 5

                        Label {
                            text: "Firmware version"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: generalInfo.firmwareVersion !== "" ? generalInfo.firmwareVersion
                                                                     : "Not Available"
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                            width: bodyText.width
                            wrapMode:Text.Wrap
                        }
                    }

                    //! Show OS version
                    Column {
                        spacing: 5

                        Label {
                            text: "OS version"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: generalInfo.osVersion !== "" ? generalInfo.osVersion
                                                               : "Not Available"
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Show Qt version
                    Column {
                        spacing: 5

                        Label {
                            text: "Qt version"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: generalInfo.qtCoreVersion !== "" ? generalInfo.qtCoreVersion
                                                                   : "Not Available"
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Show Qt Mobility version
                    Column {
                        spacing: 5

                        Label {
                            text: "Qt Mobility version"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: generalInfo.qtMobilityVersion !== ""
                                  ? generalInfo.qtMobilityVersion : "Not Available"
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Show supported hardware
                    Column {
                        spacing: 5

                        Label {
                            text: "Supported hardware"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: supportedHardware()
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground

                            //! Supported hardware list is long, use wrapping mode to wrap the text
                            //! to the label's width
                            width: bodyText.width
                            wrapMode:Text.Wrap
                        }
                    }

                    //! Show current country code
                    Column {
                        spacing: 5

                        Label {
                            text: "Current country code"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            id: currentCountry
                            text: generalInfo.currentCountryCode !== ""
                                  ? generalInfo.currentCountryCode : "Not Available"
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Show current language
                    Column {
                        spacing: 5

                        Label {
                            text: "Current language"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            id: currentLang
                            text: generalInfo.currentLanguage !== ""
                                  ? generalInfo.currentLanguage : "Not Available"
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Show available languages
                    Column {
                        spacing: 5

                        Label {
                            text: "Available languages"
                            font: uiConstants.TitleFont
                        }

                        Label {
                            text: "" + generalInfo.availableLanguages
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                            width: bodyText.width
                            wrapMode:Text.Wrap
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

    //! Start monitoring current language change
    Component.onCompleted:  generalInfo.startCurrentLanguageChanged()
}

//!  End of File
