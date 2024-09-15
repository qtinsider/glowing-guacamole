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
 * @brief Includes sample code for QtMobility NetworkInfo demo
 * Show list of network information properties and its values.
 */
Item {
    id: networkInfoPage

    anchors.fill: parent

    //! Stop monitoring network parameters changes when component is to be destroyed
    Component.onDestruction: {
        wcdmaInfo.monitorStatusChanges = false
        wcdmaInfo.monitorNameChanges = false
        wcdmaInfo.monitorCellIdChanges = false
        wcdmaInfo.monitorCurrentMobileCountryCodeChanges = false
        wcdmaInfo.monitorCurrentMobileNetworkCodeChanges = false
        wcdmaInfo.monitorSignalStrengthChanges = false

        wlanInfo.monitorStatusChanges = false
        wlanInfo.monitorNameChanges = false
        wlanInfo.monitorSignalStrengthChanges = false

        ethernetInfo.monitorStatusChanges = false
        ethernetInfo.monitorNameChanges = false
        ethernetInfo.monitorSignalStrengthChanges = false

        bluetoothInfo.monitorStatusChanges = false
        bluetoothInfo.monitorNameChanges = false
        bluetoothInfo.monitorSignalStrengthChanges = false

        gsmInfo.monitorStatusChanges = false
        gsmInfo.monitorNameChanges = false
        gsmInfo.monitorCellIdChanges = false
        gsmInfo.monitorCurrentMobileCountryCodeChanges = false
        gsmInfo.monitorCurrentMobileNetworkCodeChanges = false
        gsmInfo.monitorSignalStrengthChanges = false
    }

    /*!
     * Instance of QtMobility NetworkInfo with WCDMA mode used
     */
    NetworkInfo {
        id: wcdmaInfo

        /*!
         * Setting mode to NetworkInfo.WcdmaMode to get WCDMA network information.
         * If not set, default mode given by currentMode will be used.
         */
        mode: NetworkInfo.WcdmaMode
        monitorStatusChanges: true

        //! When WCDMA network status changes, we stop or start to monitor network's
        //! notification signals
        onStatusChanged: {
            //! Update text labels with correct values
            wcdmaSignal.text = networkSignalStrength + "%"
            wcdmaCell.text = (cellId > -1) ? cellId : "Not Available"

            //! Updating current mobile country code
            wcdmaMCC.text = (currentMobileCountryCode !== "")
                    ? currentMobileCountryCode + "/" + currentMobileNetworkCode : "N/A"
            if (networkStatus === "No Network Available" || networkSignalStrength <= 0) {
                //! No network available, stop listening for notification signals
                monitorNameChanges = false
                monitorCellIdChanges = false
                monitorCurrentMobileCountryCodeChanges = false
                monitorCurrentMobileNetworkCodeChanges = false
                monitorSignalStrengthChanges = false
            }
            else {
                //! If network is available, start monitoring for values changes
                monitorNameChanges = true
                monitorCellIdChanges = true
                monitorCurrentMobileCountryCodeChanges = true
                monitorCurrentMobileNetworkCodeChanges = true
                monitorSignalStrengthChanges = true
            }
        }
    }

    //! Instance of QtMobility NetworkInfo with WLAN mode used.
    NetworkInfo {
        id: wlanInfo

        //! Setting mode to NetworkInfo.WlanMode to get WLAN network information.
        mode: NetworkInfo.WlanMode
        monitorStatusChanges: true

        //! If WLAN network is available, start listening for notification signals
        onStatusChanged: {
            wlanSignal.text = networkSignalStrength + "%"

            if (networkStatus === "No Network Available" ) {
                //! No network available, stop listening for notification signals
                monitorNameChanges = false
                monitorSignalStrengthChanges = false
            }
            else {
                //! If network is available, start monitoring for values changes
                wlanName.text = networkName
                monitorNameChanges = true
                monitorSignalStrengthChanges = true
            }
        }
    }

    //! Instance of QtMobility NetworkInfo with Ethernet mode.
    NetworkInfo {
        id: ethernetInfo

        //! Setting mode to NetworkInfo.EthernetMode to get Ethernet network information.
        mode: NetworkInfo.EthernetMode
        monitorStatusChanges: true

        //! When Ethernet network status changes, we stop or start to monitor network's
        //! notification signals
        onStatusChanged: {
            ethernetSignal.text = networkSignalStrength + "%"

            if (networkStatus === "No Network Available" ) {
                //! No network available, stop listening for notification signals
                monitorNameChanges = false
                monitorSignalStrengthChanges = false
            }
            else {
                //! If network is available, start monitoring for values changes
                monitorNameChanges = true
                monitorSignalStrengthChanges = true
            }
        }
    }

    //! Instance of QtMobility NetworkInfo with Bluetooth mode.
    NetworkInfo {
        id: bluetoothInfo

        //! Setting mode to NetworkInfo.BluetoothMode to get Bluetooth network information.
        mode: NetworkInfo.BluetoothMode
        monitorNameChanges: true
        monitorSignalStrengthChanges: true
        monitorStatusChanges: true
    }

    //! Instance of QtMobility NetworkInfo with GSM mode.
    NetworkInfo {
        id: gsmInfo

        //! Setting mode to NetworkInfo.GsmMode to get GSM network information.
        mode: NetworkInfo.GsmMode
        monitorStatusChanges: true

        //! If GSM network is available, start listening for notification signals
        onStatusChanged: {
            gsmSignal.text = networkSignalStrength + "%"
            gsmCell.text = (cellId > -1) ? cellId : "Not Available"
            gsmCell.text = (currentMobileCountryCode !== "")
                    ? currentMobileCountryCode + "/" + currentMobileNetworkCode : "N/A"

            if (networkStatus === "No Network Available" || networkSignalStrength <= 0) {
                //! No network available, stop listening for notification signals
                monitorNameChanges = false
                monitorCellIdChanges = false
                monitorCurrentMobileCountryCodeChanges = false
                monitorCurrentMobileNetworkCodeChanges = false
                monitorSignalStrengthChanges = false
            }
            else {
                //! If network is available, start monitoring for values changes
                monitorNameChanges = true
                monitorCellIdChanges = true
                monitorCurrentMobileCountryCodeChanges = true
                monitorCurrentMobileNetworkCodeChanges = true
                monitorSignalStrengthChanges = true
            }
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
        text: "Network"
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
            contentHeight: networkData.height

            Item {
                anchors.top: parent.top

                Column {
                    id: networkData
                    spacing: 32

                    //! Displaying WCDMA network information arranged in a column
                    Column {
                        id: wcdmaData
                        spacing: 16
                        visible: wcdmaInfo.networkStatus !== "No Network Available" ? true : false

                        Column {
                            spacing: 5

                            Label {
                                text: "WCDMA operator"
                                font: uiConstants.TitleFont
                            }
                            Label {
                                text: wcdmaInfo.networkName
                                font: uiConstants.SubtitleFont
                                color: rootWindow.secondaryForeground
                            }
                        }

                        Column {
                            spacing: 5

                            Label {
                                text: "Signal strength"
                                font: uiConstants.TitleFont
                            }
                            Label {
                                id: wcdmaSignal
                                text: wcdmaInfo.networkSignalStrength > -1
                                      ? wcdmaInfo.networkSignalStrength + "%" : "Not Available"
                                font: uiConstants.SubtitleFont
                                color: rootWindow.secondaryForeground
                            }
                        }

                        Column {
                            spacing: 5

                            Label {
                                text: "WCDMA network status"
                                font: uiConstants.TitleFont
                            }
                            Label {
                                text: wcdmaInfo.networkStatus
                                font: uiConstants.SubtitleFont
                                color: rootWindow.secondaryForeground
                            }
                        }

                        Column {
                            spacing: 5

                            Label {
                                text: "Cell ID"
                                font: uiConstants.TitleFont
                            }
                            Label {
                                id: wcdmaCell
                                text: wcdmaInfo.cellId > -1 ? wcdmaInfo.cellId : "Not Available"
                                font: uiConstants.SubtitleFont
                                color: rootWindow.secondaryForeground
                            }
                        }

                        Column {
                            spacing: 5

                            Label {
                                text: "MCC/MNC"
                                font: uiConstants.TitleFont
                            }
                            Label {
                                id: wcdmaMCC
                                text: wcdmaInfo.currentMobileCountryCode + "/"
                                      + wcdmaInfo.currentMobileNetworkCode
                                font: uiConstants.SubtitleFont
                                color: rootWindow.secondaryForeground
                            }
                        }
                    }

                    //! Displaying GSM network information arranged in a column
                    Column {
                        id: gsmData
                        spacing: 16
                        visible: gsmInfo.networkStatus !== "No Network Available" ? true : false

                        Column {
                            spacing: 5

                            Label {
                                text: "GSM Operator"
                                font: uiConstants.TitleFont
                            }
                            Label {
                                text: gsmInfo.networkName
                                font: uiConstants.SubtitleFont
                                color: rootWindow.secondaryForeground
                            }
                        }

                        Column {
                            spacing: 5

                            Label {
                                text: "Signal strength"
                                font: uiConstants.TitleFont
                            }
                            Label {
                                id: gsmSignal
                                text: gsmInfo.networkSignalStrength > -1
                                      ? gsmInfo.networkSignalStrength + "%" : "Not Available"
                                font: uiConstants.SubtitleFont
                                color: rootWindow.secondaryForeground
                            }
                        }

                        Column {
                            spacing: 5

                            Label {
                                text: "GSM network status"
                                font: uiConstants.TitleFont
                            }
                            Label {
                                text: gsmInfo.networkStatus
                                font: uiConstants.SubtitleFont
                                color: rootWindow.secondaryForeground
                            }
                        }

                        Column {
                            spacing: 5

                            Label {
                                text: "Cell ID"
                                font: uiConstants.TitleFont
                            }
                            Label {
                                id: gsmCell
                                text: gsmInfo.cellId > -1 ? gsmInfo.cellId : "Not Available"
                                font: uiConstants.SubtitleFont
                                color: rootWindow.secondaryForeground
                            }
                        }

                        Column {
                            spacing: 5

                            Label {
                                text: "MCC/MNC"
                                font: uiConstants.TitleFont
                            }
                            Label {
                                id: gsmMcc
                                text: gsmInfo.currentMobileCountryCode + "/"
                                      + gsmInfo.currentMobileNetworkCode
                                font: uiConstants.SubtitleFont
                                color: rootWindow.secondaryForeground
                            }
                        }
                    }

                    //! Displaying WLAN network information arranged in a column
                    Column {
                        id: wlanData
                        spacing: 16
                        visible: wlanInfo.networkStatus !== "No Network Available" ? true : false

                        Column {
                            spacing: 5

                            Label {
                                text: "WLAN network name"
                                font: uiConstants.TitleFont
                            }
                            Label {
                                id: wlanName
                                text: wlanInfo.networkName
                                font: uiConstants.SubtitleFont
                                color: rootWindow.secondaryForeground
                            }
                        }

                        Column {
                            spacing: 5

                            Label {
                                text: "Signal strength"
                                font: uiConstants.TitleFont
                            }
                            Label {
                                id: wlanSignal
                                text: wlanInfo.networkSignalStrength > -1
                                      ? wlanInfo.networkSignalStrength + "%" : "Not Available"
                                font: uiConstants.SubtitleFont
                                color: rootWindow.secondaryForeground
                            }
                        }

                        Column {
                            spacing: 5

                            Label {
                                text: "WLAN network status"
                                font: uiConstants.TitleFont
                            }
                            Label {
                                text: wlanInfo.networkStatus
                                font: uiConstants.SubtitleFont
                                color: rootWindow.secondaryForeground
                            }
                        }

                        Column {
                            spacing: 5

                            Label {
                                text: "WLAN MAC address"
                                font: uiConstants.TitleFont
                            }
                            Label {
                                text: wlanInfo.macAddress
                                font: uiConstants.SubtitleFont
                                color: rootWindow.secondaryForeground
                            }
                        }
                    }

                    //! Displaying Ethernet network information arranged in a column
                    Column {
                        id: ethernetData
                        spacing: 16
                        visible: ethernetInfo.networkStatus !== "No Network Available" ? true
                                                                                       : false

                        Column {
                            spacing: 5

                            Label {
                                text: "Ethernet network name"
                                font: uiConstants.TitleFont
                            }
                            Label {
                                text: ethernetInfo.networkName
                                font: uiConstants.SubtitleFont
                                color: rootWindow.secondaryForeground
                            }
                        }

                        Column {
                            spacing: 5

                            Label {
                                text: "Signal strength"
                                font: uiConstants.TitleFont
                            }
                            Label {
                                id: ethernetSignal
                                text: ethernetInfo.networkSignalStrength > -1
                                      ? ethernetInfo.networkSignalStrength + "%" : "N/A"
                                font: uiConstants.SubtitleFont
                                color: rootWindow.secondaryForeground
                            }
                        }

                        Column {
                            spacing: 5

                            Label {
                                text: "Ethernet network status"
                                font: uiConstants.TitleFont
                            }
                            Label {
                                text: ethernetInfo.networkStatus
                                font: uiConstants.SubtitleFont
                                color: rootWindow.secondaryForeground
                            }
                        }

                        Column {
                            spacing: 5

                            Label {
                                text: "Ethernet MAC address"
                                font: uiConstants.TitleFont
                            }
                            Label {
                                text: ethernetInfo.macAddress
                                font: uiConstants.SubtitleFont
                                color: rootWindow.secondaryForeground
                            }
                        }
                    }

                    //! Displaying Bluetooth network information arranged in a column
                    Column {
                        id: bluetoothData
                        spacing: 16

                        Column {
                            spacing: 5

                            Label {
                                text: "Bluetooth network name"
                                font: uiConstants.TitleFont
                            }
                            Label {
                                text: bluetoothInfo.networkName
                                font: uiConstants.SubtitleFont
                                color: rootWindow.secondaryForeground
                            }
                        }

                        Column {
                            spacing: 5

                            Label {
                                text: "Signal strength"
                                font: uiConstants.TitleFont
                            }
                            Label {
                                text: bluetoothInfo.networkSignalStrength > 0
                                      ? bluetoothInfo.networkSignalStrength + "%" : "Not Available"
                                font: uiConstants.SubtitleFont
                                color: rootWindow.secondaryForeground
                            }
                        }

                        Column {
                            spacing: 5

                            Label {
                                text: "Bluetooth network status"
                                font: uiConstants.TitleFont
                            }
                            Label {
                                text: bluetoothInfo.networkStatus
                                font: uiConstants.SubtitleFont
                                color: rootWindow.secondaryForeground
                            }
                        }

                        Column {
                            spacing: 5

                            Label {
                                text: "Bluetooth MAC address"
                                font: uiConstants.TitleFont
                            }
                            Label {
                                text: bluetoothInfo.macAddress
                                font: uiConstants.SubtitleFont
                                color: rootWindow.secondaryForeground
                            }
                        }
                    }
                }
            }
        }

        //! Scroll decorator for the flickable
        ScrollDecorator {
            flickableItem: bodyFlick
        }
    }
}

//!  End of File
