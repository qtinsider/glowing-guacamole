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

#ifndef GSTPLAYER_H
#define GSTPLAYER_H

#include <QtCore>
#include <QtNetwork>
#include <stdbool.h>

/*!
 * Following has been defined in .pro file to enable the gst include:
 * CONFIG += link_pkgconfig
 * PKGCONFIG += gstreamer-0.10
 */
#include <gst/gst.h>

#include <MNotification>
#include "qeventsfeed.h"

//! Define debug printing
#define DIN qDebug()  << ">>" << __FILE__ << __LINE__ << __PRETTY_FUNCTION__
#define DOUT qDebug()  << "<<" << __FILE__ << __LINE__ << __PRETTY_FUNCTION__

/*!
 * @class GstPlayer
 * @brief GstPlayer is a wrapper class around the gstreamer PlayBin2 for playing internet radio
 * streams
 */
class GstPlayer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool playing READ isPlaying NOTIFY stateChanged)
    Q_PROPERTY(int buffer READ getBuffer NOTIFY buffering)
    Q_PROPERTY(bool initialized READ isInitialized NOTIFY initializedChanged)
    Q_PROPERTY(QString error READ getError NOTIFY error)
    Q_PROPERTY(QString stream READ getStream WRITE setStream NOTIFY streamChanged)
    Q_PROPERTY(QString song READ getSong NOTIFY songChanged)
    Q_PROPERTY(QString album READ getAlbum NOTIFY albumChanged)
    Q_PROPERTY(QString artist READ getArtist NOTIFY artistChanged)
    Q_PROPERTY(quint64 bitrate READ getBitrate NOTIFY bitrateChanged)
    Q_PROPERTY(QString organization READ getOrganization NOTIFY organizationChanged)
    Q_PROPERTY(bool recording READ isRecording NOTIFY recordingChanged)
    Q_PROPERTY(QString filename READ getFilename NOTIFY filenameChanged)
    Q_PROPERTY(bool stopped READ isStoped NOTIFY stopChanged)

public:
    /*!
     * Constructor, gstreamer is initialized and QNetworkConfigurationManager is called to open
     * the default network connection
     */
    GstPlayer();

    /*!
     * Destructor
     */
    virtual ~GstPlayer();

public slots:
    /*!
     * Gets called when network state changes. If state is other than connected the gstreamer
     * is paused.
     * @param state the network state
     */
    void handleNetworkStateChanged(QNetworkSession::State state);

    /*!
     * Set stream for the playbin2, recreates the gstreamer pipeline and starts to play the
     * new stream
     * @param stream the uri for the web stream
     */
    Q_INVOKABLE void setStream(const QString &stream);

    /*!
     * Get the stream which is currently playing
     * @return the current stream uri
     */
    Q_INVOKABLE QString getStream();

    /*!
     * play current stream
     */
    Q_INVOKABLE void play();

    Q_INVOKABLE void record(QString fileName);

    /*!
     * pause current stream
     */
    Q_INVOKABLE void pause();

    /*!
     * stop recording
     */
    Q_INVOKABLE void stop();


    /*!
     * a function to call from QML to test if the given url is valid
     * @return url format is valid
     */
    Q_INVOKABLE bool isUrlValid(const QString &url);

signals:
    void paused();          //! gst has been paused
    void playing();         //! gst has started to play
    void stateChanged();    //! generic state change of the gst has changed
    void buffering(int);    //! the buffering level of gst has changed
    void error();           //! an error has been detected
    void initializedChanged(); //! initializing state has been changed
    void streamChanged();   //! the stream has been changed
    void tagReceived(QString name,QString value);
    void songChanged();
    void albumChanged();
    void artistChanged();
    void bitrateChanged();
    void organizationChanged();
    void recordingChanged();
    void filenameChanged();
    void stopChanged();

protected slots:
    /*!
     * Slot for Gst buffer level
     * @param buf the current buffer level
     */
    void setBuffer(const int &buf);
    /*!
     * a function for handling gstbus message polling
     */
    void bus_call();

    quint64 getBitrate() { return m_bitrate; }
    QString getAlbum() { return m_album; }
    QString getSong() { return m_song; }
    QString getArtist() { return m_artist; }
    QString getOrganization() { return m_organization; }
    QString getFilename() { return m_filename; }

protected:
    /*!
     * a protected function call which will create gst pipeline
     */
    bool createPipeline();

    /*!
     * a protected function call for QML property read
     */
    bool isPlaying();

    bool isRecording();

    bool isStoped();

    /*!
     * a protected function call for QML property read
     */
    bool isInitialized();

    /*!
     * a protected function call for QML property read
     */
    QString getError();

    /*!
     * a protected function call for QML property read
     */
    int getBuffer();

    void publishNotification(QString type, QString summary, QString body="", QString image="") {
        MNotification m_notification(type,summary,body);
        m_notification.setImage(image);
        m_notification.publish();
    }

    QNetworkSession* session;
    bool m_bInitialized;
    QString m_sErrorMsg;

    QString m_song;
    QString m_artist;
    QString m_album;
    quint64 m_bitrate;
    QString m_organization;

    GstElement *m_pipeline;
    GstBus *m_bus;
    bool m_bPlaying;
    bool m_bRecording;
    bool m_bStoped;
    QString m_stream;
    QTimer* m_busPoller;
    QString m_filename;
    int m_buffer;
    bool m_bNetworkConnection;


    QEventsFeed m_eventsFeed;
};

#endif // GSTPLAYER_H
