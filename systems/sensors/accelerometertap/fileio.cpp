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

#include "fileio.h"
#include <QDebug>
#include <QDateTime>
#include <QDir>

const QString BASE_DIR("MyDocs/sensorReadings");

/*!
 * Constructor.
 */
FileIO::FileIO(QObject *parent) :
    QObject(parent)
{
    // Get file path.
    m_filePath = QDir::homePath();
    m_filePath.append("/");
    m_filePath.append(BASE_DIR);

    // Create if directory does not exist
    QDir dir(m_filePath);
    if (!dir.exists()) {
        dir.mkpath(m_filePath);
    }
}

/*!
 * Destructor.
 */
FileIO::~FileIO()
{
    // Close file if open
    if (m_destinationFile.isOpen())
        m_destinationFile.close();
}

/*!
 * Function to return the current fileName in which the recorded audio is stored.
 */
QString FileIO::getFilePathName()
{
    return m_destinationFile.fileName();
}

/*!
 * Called from QML code to write to flat file.
 */
bool FileIO::writeLine(QString text)
{
    if(!m_destinationFile.isOpen() && !createFile()) {
        return false;
    } else {
        // Write line to file
        text.append("\n");
        return (m_destinationFile.write(text.toAscii(), text.length()) ? 1 : 0);
    }
}

/*!
 * Called from QML code to close the file.
 */
QString FileIO::closeFile()
{
    if(m_destinationFile.isOpen()){
        m_destinationFile.close();
        return m_destinationFile.fileName();
    } else {
        return QString();
    }
}

/*!
 * Function to create and open a new file when recording starts.
 */
bool FileIO::createFile()
{
    // Generate file name.
    m_fileName = "AccelerometerReadings_";
    m_fileName += QDateTime::currentDateTime().toString().remove(" ").remove(":");
    m_fileName += ".txt";
    while(QFile::exists(m_filePath + "/" + m_fileName));

    // Set absolutive file name
    m_destinationFile.setFileName(m_filePath + "/" + m_fileName);

    // Try openning file
    if(!m_destinationFile.open( QIODevice::ReadWrite | QIODevice::Append ))
        // Return error.
        return false;
    else
        // File creation is successfull.
        return true;
}

//! End of File
