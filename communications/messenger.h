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

#ifndef MESSENGER_H
#define MESSENGER_H

/*!
 * INCLUDES
 */
#include <QObject>
#include <QMessageService>
#include <QDeclarativeContext>
#include <QSystemNetworkInfo>

QTM_USE_NAMESPACE

/*!
 * CLASS DECLARATION
 */

/*!
 *  @class Messenger messenger.h communication/messenger.h
 *  @brief Class inherited from QObject provides methods to
 *  initialize, write and send messages.
 */
class Messenger : public QObject
{
    Q_OBJECT

public:
    /*!
     * @brief A member function
     *
     * Constructor method for the class Messenger
     * @param parent a QObject pointer
     */
    explicit Messenger(QObject *parent = 0);

    /*!
     * Destructor
     */
    ~Messenger();

    /*!
     * Called from QML code with phone number and messageText content as
     * arguments in order to send the SMS
     * @param to String variable to hold the "TO" number
     * @param text String variable to hold the message content
     * @return bool True if message was sent successfully
     */
    Q_INVOKABLE bool sendSMS(const QString &to, const QString &text);

    /*!
     * Called from QML code to initialize message service
     * @return void
     */
    Q_INVOKABLE void initialiseMessageService();

    /*!
     * Called from QML code to check the network status
     * @return bool True if device is in Home mobile network or Roaming
     */
    Q_INVOKABLE bool networkStatus();

    /*!
     * Called from QML code to check the contacts availability
     * @return bool True if contact list not empty
     */
    Q_INVOKABLE bool isContactsAvailable(bool nfcAddressBook);

public slots:
    /*!
     * Signal emitted from QMessageService when state Changed
     * @param newState holds new state
     * @return void
     */
    void currentState(QMessageService::State newState);

signals:
    /*!
     * @brief Signal
     *
     * Signal emitted when state changed
     * @param state holds the current state
     * @return void
     */
    void stateChanged(bool state);

private:
    /*!
     * Pointer object to the QMessageService
     */
    QMessageService *m_pMessageService;

    /*!
     * Pointer object to the QSystemNetworkInfo
     */
    QSystemNetworkInfo *m_networkInfo;

    /*!
     * Bool variable declared, used to store SMS State
     */
    bool m_smsState;
};

#endif

//! MESSENGER_H
