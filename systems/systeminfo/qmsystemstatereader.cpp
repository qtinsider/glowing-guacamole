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
#include "qmsystemstatereader.h"

/*!
 * Constructor is called when the instance is created.
 */
QmSystemStateReader::QmSystemStateReader(QObject *parent) :
    QObject(parent),
	m_systemState(NULL)
{
    //! Create instance of QmSystemState for accessing class methods.
    m_systemState = new QmSystemState();
    Q_ASSERT(m_systemState);
}

/*!
 * Destructor is called when instance is to be destroyed.
 */
QmSystemStateReader::~QmSystemStateReader()
{
    //! Check if QmSystemState class instance exists
    if (!m_systemState) return;

    //! Destroy created instance
    delete m_systemState;
}

/*!
 * Function to get last boot reason and convert result to string that can be displayed to user.
 */
QString QmSystemStateReader::bootReason() const
{
    QString str;

    switch ( m_systemState->getBootReason()) {
    case QmSystemState::BootReason_SwdgTimeout:
        str = "Security watchdog timeout";
        break;
    case QmSystemState::BootReason_SecViolation:
        str = "Security violation";
        break;
    case QmSystemState::BootReason_Wdg32kTimeout:
        str = "32k watchdog timeout";
        break;
    case QmSystemState::BootReason_PowerOnReset:
        str = "Power on reset issued by the HW";
        break;
    case QmSystemState::BootReason_PowerKey:
        str = "Power key pressed";
        break;
    case QmSystemState::BootReason_MBus:
        str = "MBus";
        break;
    case QmSystemState::BootReason_Charger:
        str = "Charger plugged in";
        break;
    case QmSystemState::BootReason_Usb:
        str = "USB charger plugged in";
        break;
    case QmSystemState::BootReason_SWReset:
        str = "SW reset issued by the system";
        break;
    case QmSystemState::BootReason_RTCAlarm:
        str = "Real Time Clock Alarm";
        break;
    case QmSystemState::BootReason_NSU:
        str = "Software update";
        break;
    default:
        str = "Unknown";
        break;
    }

    return str;
}

/*!
 * Function to get total time the device has been powered on. As function getPowerOnTimeInSeconds()
 * returns value in seconds, we devide it by 60 to get result in minutes.
 */
int QmSystemStateReader::powerOnTime() const
{
    return (m_systemState->getPowerOnTimeInSeconds()/60);
}

/*!
 * Function to get current run state and convert the result to string that can be shown to user.
 */
QString QmSystemStateReader::runState() const
{
    QString str;

    switch ( m_systemState->getBootReason()) {
    case QmSystemState::RunState_User:
        str = "RunState_User";
        break;
    case QmSystemState::RunState_ActDead:
        str = "RunState_ActDead";
        break;
    case QmSystemState::RunState_Test:
        str = "RunState_Test";
        break;
    case QmSystemState::RunState_Local:
        str = "RunState_Local";
        break;
    case QmSystemState::RunState_Malf:
        str = "RunState_Malf";
        break;
    case QmSystemState::RunState_Flash:
        str = "RunState_Flash";
        break;
    case QmSystemState::RunState_Shutdown:
        str = "RunState_Shutdown";
        break;
    default:
        str = "Unknown";
        break;
    }

    return str;
}

//! End of File

