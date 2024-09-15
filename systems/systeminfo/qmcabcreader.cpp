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
#include "qmcabcreader.h"

/*!
 * Constructor is called when the instance is created.
 */
QmCABCReader::QmCABCReader(QObject *parent) :
    QObject(parent),
	m_cabc(NULL)
{
    //! Create instance of QmCABC for getting CABC mode. Memory allocated from heap.
    m_cabc = new QmCABC();
    Q_ASSERT(m_cabc);
}

/*!
 * Destructor is called when instance is to be destroyed.
 */
QmCABCReader::~QmCABCReader()
{
    //! Check if pointer to QmCABC class instance exists and delete.
    if (!m_cabc) delete m_cabc;
}

/*!
 * Function to read CABC mode and convert result to string that can be displayed to user
 */
QString QmCABCReader::mode() const
{
    QString str;

    switch ( m_cabc->get() ) {
    case QmCABC::Off:
        str = "Not activated";
        break;
    case QmCABC::Ui:
        str = "Best quality";
        break;
    case QmCABC::StillImage:
        str = "Suitable for images";
        break;
    case QmCABC::MovingImage:
        str = "Suitable for video";
        break;
    default:
        str = "Unknown";
        break;
    }

    return str;
}


//! End of File
