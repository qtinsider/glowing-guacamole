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

#ifndef THUMBNAILUTILITY_H
#define THUMBNAILUTILITY_H

#include <QtCore/QObject>
#include <QtCore/QRegExp>
#include <QtCore/QUrl>

class ThumbnailUtility : public QObject
{
    Q_OBJECT

public:
    /*!
     * @brief Member Function
     *
     * Constructor.
     */
    ThumbnailUtility(QObject *parent = 0);
    /**
     * @brief Member Function
     *
     * Destructor.
     */
    ~ThumbnailUtility();

    /*!
     * @brief Member Function
     *
     * Function to get path of audio thumbnail for given audio title if it exists in filesystem.
     * @param artist holds the artist name for the given audio file
     * @param title holds the title for the given audio file
     * @return QUrl returns the file path url for the audio album thumbnail image
     */
    QUrl getAlbumArtUrl(const QString &artist, const QString &title) const;

    /*!
     * @brief Member Function
     *
     * Helper function called from QML code to get album art thumbnail for a given audio title
     * and artist.
     * @param artist holds the artist name for the given audio file
     * @param title holds the title for the given audio file
     * @return QUrl returns the file path url for the audio album thumbnail image
     */
    Q_INVOKABLE QUrl getAlbumArtThumbnailUrl(const QString &artist, const QString &title) const;

    /*!
     * @brief Member Function
     *
     * Function returns directory of stored video thumbnails.
     * @param dirpath holds directory path for given video file
     * @return QString returns the directory where video thumbnails are stored
     */
    QString videoThumbnailDir(const QString &dirpath);

    /*!
     * @brief Member Function
     *
     * Helper function called from the QML code to return thumbnail path if video files exists
     * @param url holds url for given video file
     * @return QString return the file path of video thumbnail image
     */
    Q_INVOKABLE QString getVideothumbnailPath(const QString &url);

    /*!
     * @brief Member Function
     *
     * Function to generate video file path and check whether the
     * thumbnail path exists.
     * @param url holds url for given video file
     * @param dirpath holds directory path for given video file
     * @return QString return the generated video thumbnail path
     */
    QString thumbnailPath(const QString &url, const QString &dirpath);

    /*!
     * @brief Member Function
     *
     * Function to generate hash tag for a given video file url
     * @param url holds file path of video file for which hash tag needs to be generated
     * @return QString return the hash tag generated
     */
    QString hashforvideo(const QString &url);

    /*!
     * @brief Member Function
     *
     * Function to generate hash tag for a given audio file url.
     * @param identifier holds given identifier for which hash tag needs to generated
     * @return QString return the hash tag generated
     */
    QString hash(const QString &identifier) const;

private:
    /*!
     * Regular Expression to store the list of illegal characters
     * to be removed during hash tag creation.
     */
    QRegExp m_illegalCharacters;

    /**
     * String to hold white space used during hash tag creation.
     */
    QString m_whitespace;
};

#endif //THUMBNAILUTILITY_H
