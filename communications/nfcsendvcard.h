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

#ifndef NFCSENDVCARD_H
#define NFCSENDVCARD_H

/*!
 * INCLUDES
 */

#include "vcardrecord.h"

#include <QObject>
#include <QDebug>
#include <QUrl>

#include <qnearfieldmanager.h>
#include <qndeffilter.h>
#include <qnearfieldtarget.h>
#include <qndefmessage.h>
#include <qndefrecord.h>
#include <qndefnfcurirecord.h>
#include <qndefnfctextrecord.h>

#include <QContact>
#include <QContactDisplayLabel>
#include <QContactEmailAddress>
#include <QContactPhoneNumber>
#include <QContactFetchRequest>

QTM_USE_NAMESPACE

/*!
 * CLASS DECLARATION
 */

/*!
 *  @class NfcSendvCard nfcsendvcard.h communication/nfcsendvcard.h
 *  @brief Class inherited from QObject provides methods to
 *  intitialize, read and write messages from and to NFC targets.
 *  QNearFieldManager initializes the NFC hardware on the device and
 *  starts the target detection.QNearFieldTarget is used to read or
 *  write messages of type QNdefMessage onto the NFC target.
 */
class NfcSendvCard : public QObject
{
    Q_OBJECT

public:
    /*!
     * @brief Member function
     *
     * Constructor method for the class NfcSendvCard
     * @param parent a QObject pointer
     */
    explicit NfcSendvCard(QObject *parent = 0);

    /*!
     * @brief Member Function
     *
     * Destructor
     */
    ~NfcSendvCard();

    /*!
     * List created of type QContact.
     */
    QList<QContact> contactlist;

    /*!
     * Integer variable declared, used to store index of the contact list
     */
    int m_Contactindex;

signals:
    /*!
     * @brief Signal
     *
     * Signal emitted when status of NFC Manager status changes.
     * @param nfcStatusText String variable to hold status text
     * @return void
     */
    void nfcStatusUpdate(const QString& nfcStatusText);

    /*!
     * @brief Signal
     *
     * Signal emitted when there is an error processing a request
     * in reading or writing to NFC target.
     * @param nfcStatusErrorText String variable to hold error status text
     * @return void
     */
    void nfcStatusError(const QString& nfcStatusErrorText);

    /*!
     * @brief Signal
     *
     * Signal emitted when there is an error reading message from NFC target.
     * @param nfcStatusText String variable to hold status text
     * @return void
     */
    void nfcReadTagError(const QString& nfcTagError);


public slots:
    /*!
     * @brief Slot
     *
     * Initialise NearFieldManager.
     * Start Target detection and read tag information if any tag found.
     * @return void
     */
    void initAndStartNfc();

    /*!
     * @brief Slot
     *
     * Function to write a vCard for a given Contact id to NFC target.
     * @param contactid, stores Id of a Contact object.
     * @return void
     */
    void nfcWritevCard(int contactid);

private slots:
    /*!
     * @brief Slot
     *
     * Slot called when QNearFieldTarget::targetDetected signal is emitted.
     * QNearFieldTarget::targetDetected signal emitted when NFC target is
     * detected by the device.
     * @param nfcTarget, Holds pointer object for class QNearFieldTarget.
     * @return void
     */
    void targetDetected(QNearFieldTarget *nfcTarget);

    /*!
     * @brief Slot
     *
     * Slot called when QNearFieldTarget::requestCompleted signal is emitted.
     * @param requestId, Holds request ID of type QNearFieldTarget::RequestId.
     * @return void
     */
    void requestCompleted(const QNearFieldTarget::RequestId & requestId);

    /*!
     * @brief Slot
     *
     * Slot called when QNearFieldTarget::targetError signal is emitted.    
     * @param error, Holds error of type enum QNearFieldTarget::Error
     * @param requestId, Holds request ID of type QNearFieldTarget::RequestId.
     * @return void
     */
    void targetError(QNearFieldTarget::Error error, const QNearFieldTarget::RequestId &requestId);

    /*!
     * @brief Slot
     *
     * Slot called when QNearFieldTarget::targetLost signal is emitted.
     * @param nfcTarget, Holds pointer object for class QNearFieldTarget.
     * @return void
     */
    void targetLost(QNearFieldTarget *nfcTarget);

private:
    /*!
     * @brief Member function
     *
     * Function to convert QNearFieldTarget::Error type to string.    
     * @param error, Holds error of type enum QNearFieldTarget::Error
     * @return QString return the converted error string
     */
    QString convertTargetErrorToString(QNearFieldTarget::Error error);

    /*!
     * @brief Member function
     *
     * Function to write the vCard record to the NFC tag.
     * @return void
     */
    void writepayload();

    /*!
     * Pointer object to the QNearFieldManager.
     */
    QNearFieldManager *m_nfcManager;

    /*!
     * Pointer object to the QNearFieldTarget.
     */
    QNearFieldTarget *m_detectedNFCTarget;

    /*!
     * Pointer object to the QContactManager.
     */
    QContactManager *m_contactmanager;

    /*!
     * Boolean variable to store the completion status of writing
     * message to NFC target.
     */
    bool m_pendingWritevCard;

    /*!
     * Creating a object of class QNdefMessage, used to store the
     * message to be written onto NFC target.
     */
    QNdefMessage m_cachedvCardrecord;

    /*!
     * Creating a object of type QNdefMessage, used to store the id
     * of a NFC read or write request.
     */
    QNearFieldTarget::RequestId m_writeRequestId;
};

#endif // NFCSENDVCARD_H
