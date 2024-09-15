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

#include "nfcsendvcard.h"

/*!
 * Constructor.
 */
NfcSendvCard::NfcSendvCard(QObject *parent) :
    QObject(parent),
    m_nfcManager(NULL),
    m_detectedNFCTarget(NULL),
    m_contactmanager(NULL),
    m_pendingWritevCard(false)
{    

}

/*!
 * Destructor.
 */
NfcSendvCard::~NfcSendvCard()
{
    //! Check if m_contactmanager is valid
    if (m_contactmanager != NULL)
        delete m_contactmanager;

    //! Check if m_nfcManager is valid
    if (m_nfcManager != NULL)
        delete m_nfcManager;
}

/*!
 * Function to Initialise NearFieldManager.
 * Start Target detection and read tag information if any tag found.
 */
void NfcSendvCard::initAndStartNfc()
{    
    m_nfcManager = new QNearFieldManager(this);

    //! Check for validity of m_nfcManager
    Q_ASSERT(m_nfcManager);

    //Notify User if NFC is not enabled on the device.
    if (!m_nfcManager->isAvailable())
        emit nfcStatusError("NFC not enabled, enable NFC from \n Settings->Device->NFC");

    m_nfcManager->setTargetAccessModes(QNearFieldManager::NdefReadTargetAccess
                                       | QNearFieldManager::NdefWriteTargetAccess);

    //! Notify when target is out of NFC detecting range
    connect(m_nfcManager, SIGNAL(targetLost(QNearFieldTarget*)),
            this, SLOT(targetLost(QNearFieldTarget*)));
    //! Notify when target is inside NFC detecting range
    connect(m_nfcManager, SIGNAL(targetDetected(QNearFieldTarget*)),
            this, SLOT(targetDetected(QNearFieldTarget*)));    

    //! Start detecting targets
    bool activationSuccessful = m_nfcManager->startTargetDetection();

    if (!activationSuccessful)
        emit nfcStatusError("Error starting NFC target detection");
}

/*!
 * Slot called when QNearFieldTarget::targetDetected signal is emitted.
 * QNearFieldTarget::targetDetected signal emitted when NFC target is
 * detected by the device.
 */
void NfcSendvCard::targetDetected(QNearFieldTarget *nfcTarget)
{
    //! Handle potential errors emitted by the target
    connect(nfcTarget, SIGNAL(error(QNearFieldTarget::Error,QNearFieldTarget::RequestId)),
            this, SLOT(targetError(QNearFieldTarget::Error,QNearFieldTarget::RequestId)));
    connect(nfcTarget, SIGNAL(requestCompleted (const QNearFieldTarget::RequestId)),
            this, SLOT(requestCompleted(QNearFieldTarget::RequestId)));

    //! Cache the target in any case for future writing
    //! (so that we can also write on tags that are empty as of now)
    m_detectedNFCTarget = nfcTarget;

    if (m_pendingWritevCard)
        //! Write a cached NDEF message to the tag
        writepayload();
}

/*!
 * Function to write a vCard for a given Contact id to NFC target
 */
void NfcSendvCard::nfcWritevCard(int contactid)
{
    //! Create a new NDEF message used to store vCard record
    QNdefMessage vCard;
    bool isvCardrecordCreated = false;

    //! Check if we should create a vcard
    if (!isvCardrecordCreated) {
        m_contactmanager = new QContactManager();

        //! Check for validity of m_contactmanager
        Q_ASSERT(m_contactmanager);

        QContact contact = m_contactmanager->contact(contactid);
        VCardRecord vCardRecord;
        vCardRecord.setContact(contact);
        vCard.append(vCardRecord);
        qDebug() << "Creating vcard message ...";
        isvCardrecordCreated = true;
    }

    //! Write the vCard message to the target.
    if (isvCardrecordCreated) {
        m_pendingWritevCard = true;
        m_cachedvCardrecord = vCard;

        if (m_pendingWritevCard) writepayload();
    }
}

/*! 
 * Write the vCard record to the NFC tag
 */
void NfcSendvCard::writepayload()
{
    if (m_detectedNFCTarget) {
        //! Check target access mode
        QNearFieldManager::TargetAccessModes accessModes = m_nfcManager->targetAccessModes();

        if (accessModes.testFlag(QNearFieldManager::NdefWriteTargetAccess)) {
            m_writeRequestId = m_detectedNFCTarget->writeNdefMessages(QList<QNdefMessage>()
                                                                      << m_cachedvCardrecord);
            m_pendingWritevCard = false;
        }
    }
}

/*!
 * Slot called when QNearFieldTarget::targetLost signal is emitted.
 */
void NfcSendvCard::targetLost(QNearFieldTarget *nfcTarget)
{
    m_detectedNFCTarget = NULL;
    nfcTarget->deleteLater();
}

/*!
 * Slot called when QNearFieldTarget::targetError signal is emitted.
 */
void NfcSendvCard::targetError(QNearFieldTarget::Error error,
                               const QNearFieldTarget::RequestId &/*requestId*/)
{
    QString errorText("Error: " + convertTargetErrorToString(error));
    nfcReadTagError(errorText);
}

/*!
 * Function to convert QNearFieldTarget::Error type to string.
 */
QString NfcSendvCard::convertTargetErrorToString(QNearFieldTarget::Error error)
{
    QString errorString = "Unknown";

    switch (error) {
    case QNearFieldTarget::NoError:
        errorString = "No error has occurred.";
        break;
    case QNearFieldTarget::UnsupportedError:
        errorString = "The requested operation is unsupported by this near field target.";
        break;
    case QNearFieldTarget::TargetOutOfRangeError:
        errorString = "The target is no longer within range.";
        break;
    case QNearFieldTarget::NoResponseError:
        errorString = "The target did not respond.";
        break;
    case QNearFieldTarget::ChecksumMismatchError:
        errorString = "The checksum has detected a corrupted response.";
        break;
    case QNearFieldTarget::InvalidParametersError:
        errorString = "Invalid parameters were passed to a tag type specific function.";
        break;
    case QNearFieldTarget::NdefReadError:
        errorString = "Failed to read NDEF messages from the target.";
        break;
    case QNearFieldTarget::NdefWriteError:
        errorString = "Failed to write NDEF messages.";
        break;
    case QNearFieldTarget::UnknownError:
        errorString = "Unknown error.";
        break;        
    default:
        break;
    }
    return errorString;
}

/*!
 * Slot called when QNearFieldTarget::requestCompleted signal is emitted.
 */
void NfcSendvCard::requestCompleted(const QNearFieldTarget::RequestId &requestId)
{
    if (requestId == m_writeRequestId)
        emit nfcStatusUpdate("Message written to the tag.");
}

//! End of File
