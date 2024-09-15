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

#ifndef PHONETOOLS_H
#define PHONETOOLS_H

/*!
 * INCLUDES
 */

#include <QObject>
#include <contextsubscriber/contextproperty.h>

/*!
 * CLASS DECLARATION
 */

/*!
 *  @class PhoneTools phonetools.h main/phonetools.h
 *  @brief Class inherited from QObject provides methods for
 *  call management
 */

class PhoneTools : public QObject
{
    Q_OBJECT

public:
    /*!
     * @brief A member function
     *
     * Constructor method for the class PhoneTools
     * @param parent a QObject pointer
     */
    explicit PhoneTools(QObject *parent = 0);

    /*!
     * @brief  A member function
     * Destructor, disconnects and deletes the m_activeCall
     */
    virtual ~PhoneTools();

signals:
    /*!
     * @brief Signal
     *
     * Signal emitted when incoming call arrives
     * @return Void
     * @param QString display name
     */
    void incomingCall(QString displayName);

public slots:
    /*!
     * @brief A member function Activate Call
     * @return Void
     */
    void activeCallChanged();

protected:
    /*!
     * Pointer object to the ContextProperty
     */
    ContextProperty* m_activeCall;

};

#endif

//! PHONETOOLS_H
