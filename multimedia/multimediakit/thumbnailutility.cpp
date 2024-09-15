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

#include "thumbnailutility.h"

#include <QtCore>

/*!
 * Defining Regular expression holding illegal characters to be removed
 * while creating hash tag for url's of audio and video files.
 */
#define QT_GALLERY_MEDIA_ART_ILLEGAL_CHARACTERS \
    "\\(.*\\)|\\{.*\\}|\\[.*\\]|<.*>|[\\(\\)_\\{\\}\\[\\]\\!@#$\\^&\\*\\+\\=\\|\\\\/\"'\\?~`]"

const QString PAUSE_THUMBNAIL_SUFFIX(".jpeg");
const QString PAUSE_FRAME_DIR_1(".cache/video-suite/video-grid");
const QString PAUSE_FRAME_DIR_2(".thumbnails/video-grid");
const QString PAUSE_FRAME_DIR_3(".thumbnails/grid");

/*!
 * Constructor.
 */
ThumbnailUtility::ThumbnailUtility(QObject *parent)
    : QObject(parent)
    , m_illegalCharacters(QLatin1String(QT_GALLERY_MEDIA_ART_ILLEGAL_CHARACTERS))
    , m_whitespace(QCryptographicHash::hash(" ", QCryptographicHash::Md5).toHex())
{
}


/*!
 * Destructor.
 */
ThumbnailUtility::~ThumbnailUtility()
{    
}


/*!
 * Helper function to check whether thumbnail path for video files exists.
 */
QString ThumbnailUtility::getVideothumbnailPath(const QString &url)
{
    QString result = thumbnailPath(url, PAUSE_FRAME_DIR_1);
    if(result == "")
        result = thumbnailPath(url, PAUSE_FRAME_DIR_2);

    if(result == "")
        result = thumbnailPath(url, PAUSE_FRAME_DIR_3);

    if(result == "")
        return "";
    else
        return result;
}

/*!
 * Helper function to generate video file path and check whether the thumbnail path exists.
 */
QString ThumbnailUtility::thumbnailPath(const QString &url, const QString &dirpath)
{
    //! Generate thumbnail path
    QString thumbnailPath = videoThumbnailDir(dirpath);
    thumbnailPath.append("/");
    thumbnailPath.append(hashforvideo(url));
    thumbnailPath.append(PAUSE_THUMBNAIL_SUFFIX);

    //! Check first for pause frame
    if (QFile::exists(thumbnailPath))
        return thumbnailPath;
    else
        return "";
}

/*!
 * Function to generate hash tag for a given video file url.
 */
QString ThumbnailUtility::hashforvideo(const QString &url)
{

    QString tmp = QUrl::fromPercentEncoding(url.toUtf8());
    QString encodedUrl = QUrl(tmp).toEncoded();
    encodedUrl.replace("#", "%23");

    QByteArray hashedVideoPath = QCryptographicHash::hash(encodedUrl.toUtf8(),
                                                          QCryptographicHash::Md5);
    return hashedVideoPath.toHex();
}


/*!
 * Function returns directory of stored video thumbnails.
 */
QString ThumbnailUtility::videoThumbnailDir(const QString &dirpath)
{
    QString pauseFrameDir = QDir::homePath();
    pauseFrameDir.append("/");
    pauseFrameDir.append(dirpath);

    QDir thumbnailDir = pauseFrameDir;

    //! Create thumbnail directory if it doesn't exist already
    if (!thumbnailDir.exists()) {
        thumbnailDir.mkpath(pauseFrameDir);
    }

    return pauseFrameDir;
}

/*!
 * Function to get path of audio thumbnail for given audio title if it exists in filesystem.
 */
QUrl ThumbnailUtility::getAlbumArtUrl(const QString &artist, const QString &title) const
{
    QString fileName = QDir::homePath()
            + QLatin1String("/.cache/media-art/album-")
            + hash(artist)
            + QLatin1Char('-')
            + hash(title)
            + QLatin1String(".jpeg");

    if (QFile::exists(fileName))
        return QUrl::fromLocalFile(fileName);

    return QUrl();
}

/*!
 * Helper fun to get album art thumbnail for a given audio title and artist.
 */
QUrl ThumbnailUtility::getAlbumArtThumbnailUrl(const QString &artist, const QString &title) const
{
    QUrl albumUrl = getAlbumArtUrl(artist, title);
    return albumUrl;
}

/*!
 * Function to generate hash tag for a given audio file url.
 */
QString ThumbnailUtility::hash(const QString &identifier) const
{
    if (identifier.isEmpty())
        return m_whitespace;
    else
        return QCryptographicHash::hash(
                    identifier.toLower().remove(m_illegalCharacters).simplified().toUtf8(),
                    QCryptographicHash::Md5).toHex();
}

//! End of File
