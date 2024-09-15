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

/*!
 * INCLUDES
 */
#include "qmbatteryreader.h"
#include "qmdevicemode.h"

/*!
 * Constructor is called when the instance is created. We start periodic
 * current measurement with rate 5000 milliseconds. We also start listening
 * for the signals from instance of QmBattery class.
 */
QmBatteryReader::QmBatteryReader(QObject *parent) :
    QObject(parent),
	m_battery(NULL)
{
    //! Create instance of QmBattery for accessing battery information and status.
    //! Memory allocated from heap.
    m_battery = new QmBattery();
    Q_ASSERT(m_battery);

    //! Start battery current measurement
    m_battery->startCurrentMeasurement(QmBattery::RATE_5000ms);

    //! Start listening for signals from m_battery and emit NOTIFY signals for properties
    //! when needed
    connect(m_battery, SIGNAL(batteryRemainingCapacityChanged(int, int)), this, SIGNAL(remainingTalkTimeChanged()));
    connect(m_battery, SIGNAL(batteryRemainingCapacityChanged(int, int)), this, SIGNAL(remainingActiveTimeChanged()));
    connect(m_battery, SIGNAL(batteryRemainingCapacityChanged(int, int)), this, SIGNAL(remainingIdleTimeChanged()));
    connect(m_battery, SIGNAL(batteryCurrent(int)), this, SIGNAL(currentFlowChanged()));
}

/*!
 * Destructor is called when instance is to be destroyed.
 */
QmBatteryReader::~QmBatteryReader()
{
    //! Check if pointer to QmBattery class instance exists
    if (!m_battery) return;

    //! Stop battery current measurement
    m_battery->stopCurrentMeasurement();
    m_battery->disconnect();

    //! Destroy created instance
    delete m_battery;
}

/*!
 * Function to read battery condition and convert it to string that can be displayed to user
 */
QString QmBatteryReader::condition() const
{
    QString str;

    switch ( m_battery->getBatteryCondition() ) {
    case QmBattery::ConditionGood:
        str = "Good";
        break;
    case QmBattery::ConditionPoor:
        str = "Need to be replaced";
        break;
    default:
        str = "Unknown";
        break;
    }

    return str;
}

/*!
 * Function to get battery remaining talk time. Value is different for Normal and Powersave modes.
 */
int QmBatteryReader::remainingTalkTime() const
{
    //! QmDeviceMode class provides information and actions on device operation mode and
    //! power save mode
    QmDeviceMode deviceMode;

    //! Get current power save mode of the device and check remaining talk time based on it
    if (deviceMode.getPSMState() == QmDeviceMode::PSMStateOn)
        return m_battery->getRemainingTalkTime(QmBattery::PowersaveMode);
    else
        return m_battery->getRemainingTalkTime(QmBattery::NormalMode);
}

/*!
 * Function to get battery remaining active use time. Value is different for Normal and
 * Powersave modes.
 */
int QmBatteryReader::remainingActiveTime() const
{
    QmDeviceMode deviceMode;

    //! Get current power save mode of the device and check remaining active use time based on it
    if (deviceMode.getPSMState() == QmDeviceMode::PSMStateOn)
        return m_battery->getRemainingActiveTime(QmBattery::PowersaveMode);
    else
        return m_battery->getRemainingActiveTime(QmBattery::NormalMode);
}

/*!
 * Function to get battery remaining idle time. Value is different for Normal and Powersave modes.
 */
int QmBatteryReader::remainingIdleTime() const
{
    QmDeviceMode deviceMode;

    //! Get current power save mode of the device and check remaining idle time based on it
    if (deviceMode.getPSMState() == QmDeviceMode::PSMStateOn)
        return m_battery->getRemainingIdleTime(QmBattery::PowersaveMode);
    else
        return m_battery->getRemainingIdleTime(QmBattery::NormalMode);
}

/*!
 * Function to get the amount of current flowing out from the battery.
 */
int QmBatteryReader::currentFlow() const
{
    return m_battery->getBatteryCurrent();
}

//! End of File
