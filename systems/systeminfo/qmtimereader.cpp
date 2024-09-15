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
#include "qmtimereader.h"
#include <QDebug>
#include <QTimer>

using namespace MeeGo;

/*!
 * Constructor is called when the instance is created. We also start listening for
 * MeeGo::QmTime::timeOrSettingsChanged signal and add timer for updating current local time.
 */
QmTimeReader::QmTimeReader(QObject *parent) :
    QObject(parent),
	m_time(NULL)
{
    //! Create instance of QmTime for accessing class methods.
    m_time = new QmTime();
    Q_ASSERT(m_time);

    //! Start listening for MeeGo::QmTime::timeOrSettingsChanged signal
    connect(m_time, SIGNAL(timeOrSettingsChanged(MeeGo::QmTime::WhatChanged)), this, SLOT(settingsChanged(MeeGo::QmTime::WhatChanged)));

    //! One second (1000 milliseconds) timer
    QTimer *timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SIGNAL(localTimeChanged()));
    timer->start(1000);

}

/*!
 * Destructor is called when instance is to be destroyed.
 */
QmTimeReader::~QmTimeReader()
{
    if (!m_time) return;

    //! Destroy created instance
    delete m_time;
}

/*!
 * Slot called when timeOrSettingsChanged signal recieved from
 * QmTime instance.
 */
void QmTimeReader::settingsChanged(MeeGo::QmTime::WhatChanged what)
{
    Q_UNUSED(what);

    //! Emmiting signals
    emit autoSystemTimeChanged();
    emit autoTimeZoneChanged();
    emit timezoneChanged();
    emit timezoneAutoChanged();
}

/*!
 * Function to get status of the automatic system time setting and convert result to string
 * that can be displayed to user.
 */
QString QmTimeReader::autoSystemTime() const
{
    QString str;

    switch ( m_time->autoSystemTime()) {
    case QmTime::AutoSystemTimeOff:
        str = "Set manually by a user";
        break;
    case QmTime::AutoSystemTimeOn:
        str = "Set automatically";
        break;
    default:
        str = "Unknown";
        break;
    }

    return str;
}

/*!
 * Function to get status of the automatic time zone guessing and convert result to string
 * that can be displayed to user.
 */
QString QmTimeReader::autoTimeZone() const
{
    QString str;

    switch ( m_time->autoTimeZone()) {
    case QmTime::AutoTimeZoneOff:
        str = "Set manually by a user";
        break;
    case QmTime::AutoTimeZoneOn:
        str = "Guessed automatically";
        break;
    default:
        str = "Unknown";
        break;
    }

    return str;
}

/*!
 * Function to get current time zone.
 */
QString QmTimeReader::timezone() const
{
    //! String variable to store the result
    QString str;

    if (m_time->getTimezone(str))
        return str;
    else
        return ("Not Available");
}

/*!
 * Function to get automatically guessed time zone.
 */
QString QmTimeReader::timezoneAuto() const
{
    //! String variable to store the result when m_time->getAutoTimezone(str) executed
    QString str;

    if (m_time->getAutoTimezone(str))
        return str;
    else
        return ("Not Available");
}

/*!
 * Function to check if device supports time updates from cellular network operator and
 * convert result to string that can be displayed to user.
 */
QString QmTimeReader::timeFromOperator() const
{
    //! Boolean variable to store the result
    bool bln;

    if (m_time->isOperatorTimeAccessible(bln)) {
        if (bln)
            return ("Supported");
        else
            return ("Not supported");

    } else
        return ("Not Available");
}

/*!
 * Function to get default time zone defined during device manufacture.
 */
QString QmTimeReader::defaultTimeZone() const
{
    //! String variable to store the result
    QString str;

    if (m_time->deviceDefaultTimezone(str))
        return str;
    else
        return ("Not Available");
}

/*!
 * Function to get local time in current timezone and
 * convert result to string that can be displayed to user.
 */
QString QmTimeReader::localTime() const
{
    QString str;
    QDateTime tmp_time;
    time_t auto_time;

    //! Get time received from automatic time source
    auto_time = m_time->getAutoTime();

    //! If time is valid, convert it to the needed format. If not valid, return "N/A".
    if (auto_time != (time_t)(-1)) {
        if (QmTime::localTime(auto_time, tmp_time))
            str = tmp_time.toString("ddd MMM dd yyyy hh:mm:ss");
        else
            str = "Not Available";
    } else
        str = "Not Available";

    return str;
}

//! End of File
