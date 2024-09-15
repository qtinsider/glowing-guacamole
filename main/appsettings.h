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

#ifndef APPSETTINGS_H
#define APPSETTINGS_H

#include <QtCore>
#include <gq/GConfItem>

//! Defines for debug printing
#define DIN qDebug()  << ">>" << __FILE__ << __LINE__ << __PRETTY_FUNCTION__
#define DOUT qDebug()  << "<<" << __FILE__ << __LINE__ << __PRETTY_FUNCTION__
#define DERR qWarning() << "/!\\ Error /!\\" << __FILE__ << __LINE__ << __PRETTY_FUNCTION__

/*!
 * @class AppSettings
 * @brief AppSettings is a wrapper class around the libgq-conf
 */
class AppSettings : public QObject {
    Q_OBJECT

    Q_PROPERTY (bool accepted READ getAccepted WRITE setAccepted NOTIFY acceptedChanged)

public:
    /*!
     * constructor, which connects to GConfItems in /apps/ControlPanel/HarmattanAPIShowcase/
     */
    AppSettings() {
        m_accepted = new GConfItem("/apps/ControlPanel/HarmattanAPIShowcase/Accepted");
        connect(m_accepted,SIGNAL(valueChanged()),this,SLOT(handleAcceptedChanged()));
    }

    /*!
     * destructor, which deletes the GConfItems
     */
    virtual ~AppSettings() {
        m_accepted->deleteLater();
    }

signals:
    void acceptedChanged();

protected slots:

    /*!
     * Getter for GConfItem Accepted
     */
    bool getAccepted() { DIN << m_accepted->value(); DOUT; return m_accepted->value().toBool(); }

    /*!
     * Setter for GConfItem Bool
     * @param value The value of the GConfItem
     */
    void setAccepted(bool value) { DIN; m_accepted->set(value); DOUT; }
    
    void handleAcceptedChanged() { DIN; emit acceptedChanged(); DOUT; }

protected:
    GConfItem* m_accepted;
};

#endif // APPSETTINGS_H
