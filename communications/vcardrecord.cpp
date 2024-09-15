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

#include "vcardrecord.h"

/*!
 * Store a single contact into the payload of the vCard record.
 */
bool VCardRecord::setContact(const QContact &contact,
                             QVersitDocument::VersitType versitType)
{
    return setContact(QList<QContact>() << contact, versitType);
}

/*!
 * Store the list of contacts into the payload of the vCard record.
 */
bool VCardRecord::setContact(const QList<QContact> contacts,
                             QVersitDocument::VersitType versitType)
{
    //! Export the contacts into a versit document
    QVersitContactExporter contactExporter;

    if (!contactExporter.exportContacts(contacts, versitType)) {
        //! Error exporting - create an error message and return false.
        QString errorMessage;
        QMap<int, QVersitContactExporter::Error>::const_iterator iterator =
                contactExporter.errorMap().constBegin();

        while (iterator != contactExporter.errorMap().constEnd()) {
            switch (iterator.value()) {
            case QVersitContactExporter::EmptyContactError:
                errorMessage += QString("Index %1:").arg(iterator.key());
                errorMessage += "One of the contacts was empty";
                break;
            case QVersitContactExporter::NoNameError:
                errorMessage += QString("Index %1:").arg(iterator.key());
                errorMessage += "One of the contacts has no QContactName field";
                break;
            default:
                errorMessage += QString("Index %1:%2 ").arg(iterator.key())
                        .arg("Unknown error");
                break;
            }

            ++iterator;
        }

        m_cachedErrorText = "Error while writing vCard: " + errorMessage;
        return false;
    }

    //! Exporting the contacts to a versit document was successful.
    //! Retrieve the versit documents.
    QList<QVersitDocument> versitDocuments = contactExporter.documents();

    //! Create an array to store the payload.
    QByteArray p;
    QBuffer buffer(&p);
    buffer.open(QIODevice::WriteOnly);

    //! Create a versit writer which will serialize the versit document
    //! into our byte array.
    QVersitWriter writer;
    writer.setDevice(&buffer);

    //! Handle the writing synchronously.
    writer.startWriting(versitDocuments);
    writer.waitForFinished();

    //! Check if there was an error writing the contact.
    const QVersitWriter::Error writeError = writer.error();

    if (writeError == QVersitWriter::NoError) {
        //! No error - commit the byte array to the payload of the
         //! base record class.
        setPayload(p);
    } else {
        //! Error - create the error message.
        QString errorMessage;

        switch (writeError) {
        case QVersitWriter::UnspecifiedError:
            errorMessage += "The most recent operation failed for an undocumented reason";
            break;
        case QVersitWriter::IOError:
            errorMessage += "The most recent operation failed because of a problem with the device";
            break;
        case QVersitWriter::OutOfMemoryError:
            errorMessage += "The most recent operation failed due to running out of memory";
            break;
        case QVersitWriter::NotReadyError:
            errorMessage += "The most recent operation failed because there is an operation in progress";
            break;
        default:
            errorMessage += "Unknown error";
            break;
        }

        m_cachedErrorText = "Error while serializing vCard: " + errorMessage;
        return false;
    }

    return true;
}

/*!
 * Returns the error message in case there was a problem
 * parsing the record into a QContact or assembling the payload.
 */
QString VCardRecord::error()
{
    return m_cachedErrorText;
}

//! End of File
