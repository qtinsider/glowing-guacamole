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
 * @brief Includes sample code for QtMobility DeviceInfo demo
 * Show list of device information properties and its values.
 */
Item {
    id: deviceInfoPage

    anchors.fill: parent

    //! Stop monitoring for notification signals when component is to be destroyed
    Component.onDestruction: {
        deviceInfo.monitorCurrentProfileChanges = false
        deviceInfo.monitorBluetoothStateChanges = false
        deviceInfo.monitorThermalStateChanges = false
        deviceInfo.monitorLockStatusChanges = false
        deviceInfo.monitorWirelessKeyboardConnects = false
    }

    /*!
     * QtMobility.systeminfo 1.2 module has DeviceInfo element that allows
     * to access information about the device. currentProfile property
     * holds integer enumeration that represent current device profile.
     *
     * Function converts integer value of current profile into text format.
     */
    function deviceProfile() {
        var profile = "";

        switch(deviceInfo.currentProfile)
        {
        case 0:
            profile = "Unknown";
            break;
        case 1:
            profile = "Silent";
            break;
        case 2:
            profile = "Normal";
            break;
        case 3:
            profile = "Loud";
            break;
        case 4:
            profile = "Vibrate";
            break;
        case 5:
            profile = "Offline";
            break;
        case 6:
            profile = "Powersave";
            break;
        case 7:
            profile = "Custom";
            break;
        case 8:
            profile = "Beep";
            break;
        default:
            profile = "Not Available";
            break;
        }
        return profile;
    }

    /*!
     * simStatus property of DeviceInfo element holds integer
     * enumeration that represent status of SIM card.
     *
     *   Function converts integer value of SIM card status into text format.
     */
    function simStatus() {
        var status = "";

        switch(deviceInfo.simStatus)
        {
        case 0:
            status = "No SIM";
            break;
        case 1:
            status = "Single SIM";
            break;
        case 2:
            status = "Dual SIM";
            break;
        case 3:
            status = "SIM locked";
            break;
        default:
            status = "Not Available";
            break;
        }
        return status;
    }

    /*!
     * currentThermalState property of DeviceInfo element holds integer
     * enumeration that represent thermal state.
     *
     * Function converts integer value of thermal state into text format.
     */
    function thermalState() {
        var state = "";

        switch(deviceInfo.currentThermalState)
        {
        case 0:
            state = "Unknown";
            break;
        case 1:
            state = "Normal";
            break;
        case 2:
            state = "Warning";
            break;
        case 3:
            state = "Alert";
            break;
        case 4:
            state = "Thermal error";
            break;
        default:
            state = "Not Available";
            break;
        }
        return state;
    }

    /*!
     * Instance of QtMobility DeviceInfo
     * The DeviceInfo element allows to access information about the device and receive
     * notifications from the device.
     */
    DeviceInfo {
        id: deviceInfo

        //! Set monitor properties to true in order to use notification signals.
        monitorCurrentProfileChanges: true
        monitorBluetoothStateChanges: true
        monitorThermalStateChanges: true
        monitorLockStatusChanges: true
        monitorWirelessKeyboardConnects: true
    }

    /*!
     * Custom defined class to get battery information from QmDeviceMode
     * Check systems/systeminfo/qmdevicemodereader.h for details
     */
    QmDeviceModeReader {
        id: qmDeviceMode
    }

    /*!
     * Custom PageHeader component
     */
    PageHeader {
        id: pageTitle

        height: parent.width < parent.height ? uiConstants.HeaderDefaultHeightPortrait
                                             : uiConstants.HeaderDefaultHeightLandscape
        width: parent.width
        text: "Device"
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
            contentHeight: deviceData.height

            Item {
                anchors.top: parent.top

                //! Device information aligned vertically in a column
                Column {
                    id: deviceData
                    spacing: 16

                    //! Display model
                    Column {
                        spacing: 5

                        Label {
                            text: "Model"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: deviceInfo.model
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display name
                    Column {
                        spacing: 5

                        Label {
                            text: "Name"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: deviceInfo.productName
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display manufacturer
                    Column {
                        spacing: 5

                        Label {
                            text: "Manufacturer"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: deviceInfo.manufacturer
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display bluetooth state
                    Column {
                        spacing: 5

                        Label {
                            text: "Bluetooth state"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: deviceInfo.currentBluetoothPowerState ? "On" : "Off"
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display device profile
                    Column {
                        spacing: 5

                        Label {
                            text: "Device profile"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: deviceProfile()
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display IMEI
                    Column {
                        spacing: 5

                        Label {
                            text: "IMEI"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: deviceInfo.imei
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display IMSI
                    Column {
                        spacing: 5

                        Label {
                            text: "IMSI"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: !deviceInfo.imsi ? "Not available" : deviceInfo.imsi
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display device ID
                    Column {
                        spacing: 5

                        Label {
                            text: "Device ID"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: deviceInfo.uniqueDeviceID
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground

                            //! Device ID string is long, use wrapping mode to wrap the text to
                            //! the label's width
                            width: bodyText.width
                            wrapMode: Text.Wrap
                        }
                    }

                    //! Display SIM status
                    Column {
                        spacing: 5

                        Label {
                            text: "SIM status"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: simStatus()
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display thermal state
                    Column {
                        spacing: 5

                        Label {
                            text: "Thermal state"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: thermalState()
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display device lock status
                    Column {
                        spacing: 5

                        Label {
                            text: "Device lock"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: deviceInfo.isDeviceLocked ? "Locked" : "Not locked"
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display wireless keyboard status
                    Column {
                        spacing: 5

                        Label {
                            text: "Wireless keyboard"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: deviceInfo.isWirelessKeyboardConnected ? "Connected"
                                                                         : "Not connected"
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display device mode
                    Column {
                        spacing: 5

                        Label {
                            text: "Device mode"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: qmDeviceMode.deviceMode
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display power save mode
                    Column {
                        spacing: 5

                        Label {
                            text: "Power save mode"
                            font: uiConstants.TitleFont
                        }
                        Label {
                            text: qmDeviceMode.psmState
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
