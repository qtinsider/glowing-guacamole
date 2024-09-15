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
 * @brief Includes sample code for QtMobility BatteryInfo demo
 * Show list of battery information properties and its values.
 */
Item {
    id: batteryInfoPage

    anchors.fill: parent

    //! Stop monitoring for notification signals when component is to be destroyed
    Component.onDestruction: {
        batteryInfo.monitorBatteryStatusChanges = false
        batteryInfo.monitorChargerTypeChanges = false
        batteryInfo.monitorChargingStateChanges = false
        batteryInfo.monitorNominalCapacityChanges = false
        batteryInfo.monitorRemainingCapacityBarsChanges = false
        batteryInfo.monitorRemainingCapacityChanges = false
        batteryInfo.monitorRemainingCapacityPercentChanges = false
        batteryInfo.monitorRemainingChargingTimeChanges = false
    }

    /*!
     * QtMobility.systeminfo 1.2 module has BatteryInfo element that allows
     * to receive battery information from the device. batteryStatus property
     * holds integer enumeration that represent status of the battery.
     *
     * Function converts integer value of battery status into text format.
     */
    function batteryStatus() {
        var status = "";

        switch(batteryInfo.batteryStatus)
        {
        case BatteryInfo.BatteryEmpty:
            status = "Empty";
            break;
        case BatteryInfo.BatteryCritical:
            status = "Critical";
            break;
        case BatteryInfo.BatteryVeryLow:
            status = "Very low";
            break;
        case BatteryInfo.BatteryLow:
            status = "Low";
            break;
        case BatteryInfo.BatteryOk:
            status = "Ok";
            break;
        case BatteryInfo.BatteryFull:
            status = "Full";
            break;
        case BatteryInfo.BatteryUnknown:
            status = "Unknown";
            break;
        default:
            status = "Not Available";
            break;
        }
        return status;
    }

    /*!
     * energyMeasurementUnit property of BatteryInfo element holds integer
     * enumeration that represent energy unit used by the system.
     *
     * Function converts integer value of energy unit into text format.
     */
    function batteryUnit() {
        var unit = "";

        switch(batteryInfo.energyMeasurementUnit)
        {
        case 0:
            unit = "mAh";
            break;
        case 1:
            unit = "mWh";
            break;
        default:
            unit = " ";
            break;
        }
        return unit;
    }

    /*!
     * chargerType property of BatteryInfo element holds integer
     * enumeration that represent type of currently used charger.
     *
     * Function converts integer value of used charger into text format.
     */
    function chargerType() {
        var charger = "";

        switch(batteryInfo.chargerType)
        {
        case BatteryInfo.NoCharger:
            charger = "No charger";
            break;
        case BatteryInfo.WallCharger:
            charger = "Wall";
            break;
        case BatteryInfo.USBCharger:
        case BatteryInfo.USB_100mACharger:
        case BatteryInfo.USB_500mACharger:
            charger = "USB";
            break;
        case BatteryInfo.VariableCurrentCharger:
            charger = "Variable current";
            break;
        case BatteryInfo.UnknownCharger:
            charger = "Unknown";
            break;
        default:
            charger = "Not Available";
            break;
        }
        return charger;
    }

    /*!
     * chargingState property of BatteryInfo element holds integer
     * enumeration that represent charging state of the main battery.
     *
     * Function converts integer value of charging state into text format.
     */
    function chargingState() {
        var state = "";

        switch(batteryInfo.chargingState)
        {
        case BatteryInfo.NotCharging:
            state = "Not charging";
            break;
        case BatteryInfo.Charging:
            state = "Charging";
            break;
        case BatteryInfo.ChargingError:
            state = "Charging error";
            break;
        default:
            state = "Not Available";
            break;
        }
        return state;
    }

    /*!
     * Instance of QtMobility BatteryInfo
     * The BatteryInfo element allows to receive battery change notifications from the device.
     */
    BatteryInfo {
        id: batteryInfo

        //! Set monitor properties to true in order to use notification signals.
        monitorBatteryStatusChanges: true
        monitorChargerTypeChanges: true
        monitorChargingStateChanges: true
        monitorNominalCapacityChanges: true
        monitorRemainingCapacityBarsChanges: true
        monitorRemainingCapacityChanges: true
        monitorRemainingCapacityPercentChanges: true
        monitorRemainingChargingTimeChanges: true
    }

    /*!
     * Custom defined class to get battery information from QmBattery
     * Check systems/systeminfo/qmbatteryreader.h for details
     */
    QmBatteryReader {
        id: qmBattery
    }

    /*!
     * Custom PageHeader component
     */
    PageHeader {
        id: pageTitle

        height: parent.width < parent.height ? uiConstants.HeaderDefaultHeightPortrait
                                             : uiConstants.HeaderDefaultHeightLandscape
        width: parent.width
        text: "Battery"
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
            contentHeight: batteryData.height

            Item {
                anchors.top: parent.top

                //! Battery information aligned vertically in a column
                Column {
                    id: batteryData
                    spacing: 16

                    //! Display battery status
                    Column {
                        spacing: 5

                        Label {
                            text: "Battery status"
                            font: uiConstants.TitleFont
                        }

                        Label {
                            text: batteryStatus()
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display charger type
                    Column {
                        spacing: 5

                        Label {
                            text: "Charger type"
                            font: uiConstants.TitleFont
                        }

                        Label {
                            text: chargerType()
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display charging state
                    Column {
                        spacing: 5

                        Label {
                            text: "Charging state"
                            font: uiConstants.TitleFont
                        }

                        Label {
                            text: chargingState()
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display current flow
                    Column {
                        spacing: 5

                        Label {
                            text: "Current flow"
                            font: uiConstants.TitleFont
                        }

                        Label {
                            text: qmBattery.currentFlow + " " + batteryUnit()
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display nominal capacity
                    Column {
                        spacing: 5

                        Label {
                            text: "Nominal capacity"
                            font: uiConstants.TitleFont
                        }

                        Label {
                            text: batteryInfo.nominalCapacity > -1
                                  ? batteryInfo.nominalCapacity + " " + batteryUnit()
                                  : "Not Available"
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display remaining capacity in units
                    Column {
                        spacing: 5

                        Label {
                            text: "Remaining capacity"
                            font: uiConstants.TitleFont
                        }

                        Label {
                            text: batteryInfo.remainingCapacity > -1
                                  ? batteryInfo.remainingCapacity + " " + batteryUnit()
                                  : "Not Available"
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display remaining capacity in percentage
                    Column {
                        spacing: 5

                        Label {
                            text: "Remaining capacity"
                            font: uiConstants.TitleFont
                        }

                        Label {
                            text: batteryInfo.remainingCapacityPercent > -1
                                  ? batteryInfo.remainingCapacityPercent + "%" : "Not Available"
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display remaining charging time
                    Column {
                        spacing: 5

                        Label {
                            text: "Remaining charging time"
                            font: uiConstants.TitleFont
                        }

                        Label {
                            text: batteryInfo.remainingChargingTime > -1
                                  ? batteryInfo.remainingChargingTime + " s" : "Not Available"
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display voltage
                    Column {
                        spacing: 5

                        Label {
                            text: "Voltage"
                            font: uiConstants.TitleFont
                        }

                        Label {
                            text: batteryInfo.voltage > -1 ? batteryInfo.voltage + " mV"
                                                           : "Not Available"
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display battery condition
                    Column {
                        spacing: 5

                        Label {
                            text: "Battery condition"
                            font: uiConstants.TitleFont
                        }

                        Label {
                            text: qmBattery.condition
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display remaining talk time
                    Column {
                        spacing: 5

                        Label {
                            text: "Remaining talk time"
                            font: uiConstants.TitleFont
                        }

                        Label {
                            /*!
                             * Function remainingTalkTime returns results in seconds.
                             * To display it in minutes result is divided by 60.
                             * toFixed(0) formats number in a way to show only whole number.
                             */
                            text: qmBattery.remainingTalkTime > -1
                                  ? (qmBattery.remainingTalkTime/60).toFixed(0) + " minutes"
                                  : "Not Available"
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display remaining active use time
                    Column {
                        spacing: 5

                        Label {
                            text: "Remaining active use time"
                            font: uiConstants.TitleFont
                        }

                        Label {
                            /*!
                             * Function remainingActiveTime returns results in seconds.
                             * To display it in minutes result is divided by 60.
                             * toFixed(0) formats number to show only whole number.
                             */
                            text: qmBattery.remainingActiveTime > -1
                                  ? (qmBattery.remainingActiveTime/60).toFixed(0) + " minutes"
                                  : "Not Available"
                            font: uiConstants.SubtitleFont
                            color: rootWindow.secondaryForeground
                        }
                    }

                    //! Display remaining idle time
                    Column {
                        spacing: 5

                        Label {
                            text: "Remaining idle time"
                            font: uiConstants.TitleFont
                        }

                        Label {
                            /*!
                             * Function remainingIdleTime returns results in seconds.
                             * To display it in minutes result is divided by 60.
                             * toFixed(0) formats number to show only whole number.
                             */
                            text: qmBattery.remainingIdleTime > -1
                                  ? (qmBattery.remainingIdleTime/60).toFixed(0) + " minutes"
                                  : "Not Available"
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
