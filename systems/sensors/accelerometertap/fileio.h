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

#ifndef FILEIO_H
#define FILEIO_H

/*!
 * INCLUDES
 */
#include <QObject>
#include <QString>
#include <QFile>

/*!
 * CLASS DECLARATION
 */

/*!
 *  @class FileIO fileio.h accelerometertaps/fileio.h
 *  @brief Flat text file IO.
 *
 *  FileIO class inherited from QObject provides methods to
 *  perform flat file io operations.
 *
 */
class FileIO : public QObject
{
    Q_OBJECT

public:
    /*!
     * @brief Member Function
     *
     * Constructor.
     */
    explicit FileIO(QObject *parent = 0);

    /*!
     * @brief Member Function
     *
     * Destructor.
     */
    ~FileIO();

public slots:
    /*!
     * @brief Member Function
     *
     * Function to return the current file path and name in use.
     * @return QString returns the current file name with absolute path.
     */
    Q_INVOKABLE QString getFilePathName();

    /*!
     * @brief Member Function
     *
     * Called from QML code to write text to flat file.
     * @return bool returns true if write is succesfull and false if it fails.
     */
    Q_INVOKABLE bool writeLine(QString text);

    /*!
     * @brief Member Function
     *
     * Called from QML code to close current file.
     * @return bool returns true if close is succesfull and false if it fails.
     */
    Q_INVOKABLE QString closeFile();

private:
    /*!
     * Creating a new file reference.
     */
    QFile m_destinationFile;

    /*!
      * QString variable to store file name used.
      */
    QString m_fileName;
    QString m_filePath;

    /*!
     * @brief Member Function
     *
     * Function to create and open a new file.
     * @return bool returns true is file creation is succesfull and false if it fails.
     */
    bool createFile();
};

#endif // FILEIO_H
