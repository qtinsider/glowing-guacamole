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

#ifndef VCARDRECORD_H
#define VCARDRECORD_H

#include <QNdefRecord>
#include <qndefmessage.h>
#include <qndefrecord.h>
#include <QDebug>
#include <QVersitDocument>
#include <QVersitReader>
#include <QVersitWriter>
#include <QVersitContactImporter>
#include <QVersitContactExporter>
#include <QContact>
#include <QBuffer>
#include <QContactName>

QTM_USE_NAMESPACE

/*!
 * CLASS DECLARATION
 */
class VCardRecord : public QNdefRecord
{
public:
    /*!
     * Declaring QNdefRecord of type vCard.
     */
    Q_DECLARE_NDEF_RECORD(VCardRecord, QNdefRecord::Mime, "text/x-vCard", QByteArray(0, char(0)))

    /*!
     * @brief Member Function
     *
     * Store a single contact into the payload of the vCard record.
     * @param contacts List of contacts, In this case holds the contact
     * to be written to NFC target.
     * @param versitType Holds the type used to generate versit document
     * of type QVersitDocument.
     * @return return true in case of no error, false in case of error
     */
    bool setContact(const QContact& contacts,
                    QVersitDocument::VersitType versitType = QVersitDocument::VCard30Type);

    /*!
     * @brief Member Function
     *
     * Store the list of contacts into the payload of the vCard record.
     * @param contacts List of contacts, In this case holds the
     * contact to be written to NFC target.
     * @param versitType Holds the type used to generate versit document
     * of type QVersitDocument.
     * @return return true in case of no error, false in case of error
     */
    bool setContact(const QList<QContact> contacts,
                    QVersitDocument::VersitType versitType = QVersitDocument::VCard30Type);

    /*!
     * @brief Member Function
     *
     * Returns the error message in case there was a problem
     * parsing the record into a QContact or assembling the payload.
     *
     * @return return error string
     */
    QString error();

private:
    /*!
     * Creating a object of class QString, used to store the error string.
     */
    QString m_cachedErrorText;
};

#endif //VCARDRECORD_H
