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
#include "phonetools.h"

PhoneTools::PhoneTools(QObject *parent) :
    QObject(parent), m_activeCall(new ContextProperty("/com/nokia/CallUi/ActiveCall"))
{
    connect(m_activeCall, SIGNAL(valueChanged()), SLOT(activeCallChanged()));
}

PhoneTools::~PhoneTools() {
    //! disconnect everything which is connected to this object's signals
    m_activeCall->disconnect();
    m_activeCall->deleteLater(); //! lets delete the object later
}

void PhoneTools::activeCallChanged() {
   QVariantMap activeCallInfo = m_activeCall->value().toMap();
   if (!activeCallInfo.contains("state") || !activeCallInfo.value("status", false).toBool()) {
        return;
   }
   if (activeCallInfo["state"].toInt() == 0) {
        QString displayName = activeCallInfo["displayName"].toString();
        if (displayName.isEmpty() || displayName=="") {
               return;
        }
        emit incomingCall(displayName);
   }
}

//!  End of File
