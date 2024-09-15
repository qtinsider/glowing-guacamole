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
#include "qmdevicemodereader.h"

/*!
 * Constructor is called when the instance is created. We start to listen
 * for the signals from instance of QmDeviceMode class.
 */
QmDeviceModeReader::QmDeviceModeReader(QObject *parent) :
    QObject(parent),
	m_deviceMode(NULL)
{
    //! Create instance of QmDeviceMode for accessing its methods. Memory allocated from heap.
    m_deviceMode = new QmDeviceMode();
    Q_ASSERT(m_deviceMode);

    //! Emit signal when device operation mode changed
    connect(m_deviceMode, SIGNAL(deviceModeChanged(MeeGo::QmDeviceMode::DeviceMode)), this, SIGNAL(deviceModeChanged()));

    //! Notify when device powersave mode changed
    connect(m_deviceMode, SIGNAL(devicePSMStateChanged(MeeGo::QmDeviceMode::PSMState)), this, SIGNAL(psmStateChanged()));
}

/*!
 * Destructor is called when instance is to be destroyed.
 */
QmDeviceModeReader::~QmDeviceModeReader()
{
    //! Check if pointer to QmDeviceMode class instance exists
    if (!m_deviceMode) return;

    //! Destroy created instance
    delete m_deviceMode;
}

/*!
 * Function to read current device operation mode (e.g. Normal or Flight mode)
 * and convert result to string that can be displayed to user.
 */
QString QmDeviceModeReader::deviceMode() const
{
    QString str;

    switch ( m_deviceMode->getMode() ) {
    case QmDeviceMode::Normal:
        str = "Normal";
        break;
    case QmDeviceMode::Flight:
        str = "Flight mode";
        break;
    default:
        str = "Unknown";
        break;
    }

    return str;
}

/*!
 * Function to read current device powersave mode and convert result to string that can be
 * displayed to user
 */
QString QmDeviceModeReader::psmState() const
{
    QString str;

    switch ( m_deviceMode->getPSMState() ) {
    case QmDeviceMode::PSMStateOn:
        str = "On";
        break;
    case QmDeviceMode::PSMStateOff:
        str = "Off";
        break;
    default:
        str = "Unknown";
        break;
    }

    return str;
}

//! End of File
