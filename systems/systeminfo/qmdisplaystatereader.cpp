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
#include "qmdisplaystatereader.h"

/*!
 * Constructor is called when the instance is created.
 */
QmDisplayStateReader::QmDisplayStateReader(QObject *parent) :
    QObject(parent),
	m_displayState(NULL)
{
    //! Create instance of QmDisplayState for accessing class methods.
    m_displayState = new QmDisplayState();
    Q_ASSERT(m_displayState);

    //! Emit signal when display state changed
    connect(m_displayState, SIGNAL(displayStateChanged(MeeGo::QmDisplayState::DisplayState)), this, SIGNAL(displayStateChanged()));
}

/*!
 * Destructor is called when instance is to be destroyed.
 */
QmDisplayStateReader::~QmDisplayStateReader()
{
    //! Check if QmDisplayState class instance exists
    if (!m_displayState) return;

    //! Destroy created instance
    delete m_displayState;
}

/*!
 * Function to read current display state and convert result to string that can be displayed
 * to user.
 */
QString QmDisplayStateReader::displayState() const
{
    QString str;

    switch ( m_displayState->get()) {
    case QmDisplayState::Off:
        str = "Off";
        break;
    case QmDisplayState::Dimmed:
        str = "Dimmed";
        break;
    case QmDisplayState::On:
        str = "On";
        break;
    default:
        str = "Unknown";
        break;
    }

    return str;
}

/*!
 * Function to get display dimming timeout in seconds.
 */
int QmDisplayStateReader::dimTimeout() const
{
    return m_displayState->getDisplayDimTimeout();
}

/*!
 * Function to get display blanking timeout in seconds.
 */
int QmDisplayStateReader::blankTimeout() const
{
    return m_displayState->getDisplayBlankTimeout();
}

//! End of File
