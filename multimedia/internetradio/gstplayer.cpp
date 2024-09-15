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

#include "gstplayer.h"

GstPlayer::GstPlayer() : m_pipeline(NULL), m_bus(NULL),m_busPoller(new QTimer())
{
    connect(m_busPoller,SIGNAL(timeout()),this,SLOT(bus_call()));

    QNetworkConfigurationManager manager;
    const bool canStartIAP = (manager.capabilities() & QNetworkConfigurationManager::CanStartAndStopInterfaces);

     // Is there default access point, use it
     QNetworkConfiguration cfg = manager.defaultConfiguration();
     if (!cfg.isValid() || (!canStartIAP && cfg.state() != QNetworkConfiguration::Active)) {
         m_sErrorMsg = "No Access Point found.";
         qWarning() << m_sErrorMsg;
         emit error();
         return;
     }

     session = new QNetworkSession(cfg, this);

     if (session) {
         connect(session,SIGNAL(stateChanged(QNetworkSession::State)),this,SLOT(handleNetworkStateChanged(QNetworkSession::State)));
         m_bNetworkConnection = (session->state()==QNetworkSession::Connected);

         if (!m_bNetworkConnection) {
            session->open();

            if (session->waitForOpened()) {
                m_sErrorMsg = session->errorString();
                qWarning() << m_sErrorMsg;
                emit error();
                return;
            }
         }
     } else {
         qDebug() << "session could not be initialized";
     }

    m_bPlaying = false;
    connect(this,SIGNAL(buffering(int)),this,SLOT(setBuffer(int)));

    gst_init (NULL,NULL);

    bool ok = createPipeline();

    m_bInitialized = ok;
    emit initializedChanged();
    publishNotification(MNotification::MessageEvent,"Harmattan API Showcase","Internet Radio has been started");
}

GstPlayer::~GstPlayer()
{
    publishNotification(MNotification::MessageEvent,"Harmattan API Showcase","Internet Radio has been closed");
    if (isPlaying() || isRecording()) {
        pause();
    }

    if (m_bus) {
        gst_object_unref(m_bus);
    }

    if (m_pipeline) {
        gst_object_unref(m_pipeline);
    }
}

void GstPlayer::handleNetworkStateChanged(QNetworkSession::State state)
{
    if (!m_bInitialized) {
        return;
    }

    m_bNetworkConnection = (state==QNetworkSession::Connected);

    if (!m_bNetworkConnection) {
        pause();
        emit error();
    }

    switch (state) {
        case QNetworkSession::NotAvailable:
        publishNotification(MNotification::NetworkEvent,"Harmattan API Showcase","Network not available");
            break;
        case QNetworkSession::Connecting:
            publishNotification(MNotification::NetworkEvent,"Harmattan API Showcase","Connecting to network");
            break;
        case QNetworkSession::Connected:
            publishNotification(MNotification::NetworkConnectedEvent,"Harmattan API Showcase","Connected to network");
            break;
        case QNetworkSession::Closing:
            publishNotification(MNotification::NetworkEvent,"Harmattan API Showcase","Closing connection to network");
            break;
        case QNetworkSession::Disconnected:
            publishNotification(MNotification::NetworkDisconnectedEvent,"Harmattan API Showcase","Disconnected from network");
            break;
        case QNetworkSession::Roaming:
            publishNotification(MNotification::NetworkEvent,"Harmattan API Showcase","Roaming in network");
            break;
        default:
            publishNotification(MNotification::NetworkEvent,"Harmattan API Showcase","Unknown network state");
            break;
    }
}

void GstPlayer::setStream(const QString &stream)
{
    if (!m_bInitialized) {
        return;
    }

    if (stream.length()==0) {
        qWarning() << "stream length is zero";
        return;
    }

    m_artist = "";
    m_song = "";
    m_album = "";
    m_organization = "";
    m_bitrate = 0;
    emit artistChanged();
    emit albumChanged();
    emit songChanged();
    emit bitrateChanged();
    emit organizationChanged();


    this->m_stream = stream;
    pause();
    bool ok = createPipeline();
    if (ok) {
        play();
        emit streamChanged();
    }
}

QString GstPlayer::getStream()
{
    return this->m_stream;
}

int GstPlayer::getBuffer()
{
    return m_buffer;
}

void GstPlayer::play()
{
    if (!m_bInitialized) {
        return;
    }

    if (!m_pipeline)  {
        qWarning() << __PRETTY_FUNCTION__ << "pipeline is not initialized";
        return;
    }

    if (!m_bNetworkConnection) {
        qWarning() << "No network connection";
        pause();
        m_sErrorMsg = "No network connection";
        emit error();
        return;
    }

    bool ok = createPipeline();
    if (!ok) { return; }

    //Start the GStreamer pipeline playing process
    gst_element_set_state (GST_ELEMENT (m_pipeline), GST_STATE_PLAYING);
    m_bPlaying = true;
    emit playing();
    emit stateChanged();
}

void GstPlayer::record(QString fileName)
{
    if (!m_bInitialized) {
        return;
    }

    if (!m_pipeline)  {
        qWarning() << __PRETTY_FUNCTION__ << "pipeline is not initialized";
        return;
    }

    if (!m_bNetworkConnection) {
        qWarning() << "No network connection";
        pause();
        m_sErrorMsg = "No network connection";
        emit error();
        return;
    }

    QFile testFileAccess(fileName);
    if (!testFileAccess.open(QIODevice::ReadWrite)) {
        m_sErrorMsg = "Could not open file for reading/writing";
        emit error();
        return;
    }

    testFileAccess.close();

    m_filename = fileName;
    emit filenameChanged();
    m_bRecording = true;

    m_bRecording = createPipeline();

    //Start the GStreamer pipeline playing process
    gst_element_set_state (GST_ELEMENT (m_pipeline), GST_STATE_PLAYING);

    emit recordingChanged();
    emit stateChanged();
}

void GstPlayer::pause()
{
    if (!m_bInitialized) {
        return;
    }

    if (!m_pipeline)  {
        qWarning() << __PRETTY_FUNCTION__ << "pipeline is not initialized";
        return;
    }

    m_buffer = 0;
    emit buffering(m_buffer);

    m_filename = "";
    emit filenameChanged();

    m_bRecording = false;
    m_bPlaying = false;
    m_bStoped = false;
    gst_element_set_state (GST_ELEMENT (m_pipeline), GST_STATE_READY);
    emit paused();
    emit stateChanged();
    emit recordingChanged();
    emit stopChanged();
}

void GstPlayer::stop()
{
    if (!m_bInitialized) {
        return;
    }

    if (!m_pipeline)  {
        qWarning() << __PRETTY_FUNCTION__ << "pipeline is not initialized";
        return;
    }

    m_buffer = 0;
    emit buffering(m_buffer);

    m_filename = "";
    emit filenameChanged();

    m_bRecording = false;
    m_bPlaying = false;
    m_bStoped = true;
    gst_element_set_state (GST_ELEMENT (m_pipeline), GST_STATE_NULL);
    emit stopChanged();
    emit stateChanged();
    emit recordingChanged();
}

void GstPlayer::setBuffer(const int &buf)
{
    m_buffer = buf;
}

bool GstPlayer::createPipeline()
{
    if (!m_bNetworkConnection) {
        qWarning() << "No network connection";
        m_sErrorMsg = "No network connection";
        emit error();
        return false;
    }

    if (isPlaying() || isRecording()) {
        bool wasRecording = isRecording();
        QString fileName = m_filename;
        pause();
        m_bRecording = wasRecording;
        m_filename = fileName;
        gst_object_unref(m_bus);
        gst_object_unref(m_pipeline);
    }

    if (isRecording()) {
        QFile filu(getFilename());
        if (filu.exists()) {
            m_filename = QString("/home/user/MyDocs/Music/%0.mp3").arg(QDateTime::currentMSecsSinceEpoch());
            emit filenameChanged();
        }
        filu.close();
        m_pipeline = gst_parse_launch(QString("souphttpsrc name=source location=%0 iradio-mode=true ! queue2 use-buffering=true low-percent=50 use-rate-estimate=true ! tee name=t ! queue2 ! decodebin ! audioconvert ! audioresample ! autoaudiosink  t. ! queue2 ! icydemux ! filesink name=fileoutput location=%1").arg(m_stream).arg(getFilename()).toAscii(), NULL);
    } else {
        m_pipeline = gst_parse_launch("playbin2 www=1.0 uri=" + m_stream.toAscii(), NULL);
    }
    if (!m_pipeline) {
        qWarning() << "Could not create pipeline";
        m_sErrorMsg = "Could not create pipeline";
        emit error();
        return false;
    }

    if (m_bus!=NULL) {
        gst_object_unref (GST_OBJECT (m_bus));
        m_bus = NULL;
    }
    m_bus = gst_pipeline_get_bus(GST_PIPELINE (m_pipeline));

    m_busPoller->start(250);
    return true;
}

bool GstPlayer::isPlaying() {
    return m_bPlaying;
}

bool GstPlayer::isRecording() {
    return m_bRecording;
}

bool GstPlayer::isInitialized() {
    return m_bInitialized;
}

bool GstPlayer::isStoped() {
    return m_bStoped;
}

QString GstPlayer::getError() {
    if (!m_bNetworkConnection) {
        return QString("No network connection");
    } else {
        return m_sErrorMsg;
    }
}

void GstPlayer::bus_call()
{
    gint percent = 0;
    GstTagList *tags = NULL;
    gchar* taglistString = NULL;

    if (!m_bus) { qDebug() << "bus not initialized"; return; }
    gchar *artist, *song, *album, *organization = NULL;
    guint bitrate = 0;

    GstMessage* msg = gst_bus_pop(m_bus);
    while (msg) {
        switch(GST_MESSAGE_TYPE(msg))
        {
            case GST_MESSAGE_BUFFERING:
                gst_message_parse_buffering (msg, &percent);
                emit buffering((int)percent);
                break;
            case GST_MESSAGE_EOS:
                g_message("End-of-stream");
                this->m_sErrorMsg = QString::fromAscii("End-of-stream");
                emit error();
                pause();
                break;
            case GST_MESSAGE_TAG:
                gst_message_parse_tag (msg, &tags);
                taglistString = gst_structure_to_string (GST_STRUCTURE (tags));

                if (gst_tag_list_get_string(tags,GST_TAG_ORGANIZATION,&organization)) {
                    if (m_organization.compare(QString::fromAscii(organization))!=0) {
                        m_organization = QString::fromAscii(organization);
                        emit organizationChanged();
                    }
                    g_free(organization);
                    emit tagReceived("organization",m_organization);
                    m_eventsFeed.addItem("Internet Radio",QString("You are listening %0").arg(m_organization));

                }

                if (gst_tag_list_get_string(tags,GST_TAG_ARTIST,&artist)) {
                    if (m_artist.compare(QString::fromAscii(artist))!=0) {
                        m_artist = QString::fromAscii(artist);
                        emit artistChanged();
                    }
                    g_free(artist);
                    emit tagReceived("artist",m_artist);
                    m_eventsFeed.addItem("Internet Radio",QString("The current artist is %0").arg(m_artist));
                }

                if (gst_tag_list_get_string(tags,GST_TAG_TITLE,&song)) {
                    if (m_song.compare(QString::fromAscii(song))!=0) {
                        m_song = QString::fromAscii(song);
                        emit songChanged();
                    }
                    g_free(song);
                    emit tagReceived("song",m_song);
                    m_eventsFeed.addItem("Internet Radio",QString("The current song is %0").arg(m_song));
                }

                if (gst_tag_list_get_string(tags,GST_TAG_ALBUM,&album)) {
                    if (m_album.compare(QString::fromAscii(album))!=0) {
                        m_album = QString::fromAscii(album);
                        emit albumChanged();
                    }
                    g_free(album);
                    emit tagReceived("album",m_album);
                    m_eventsFeed.addItem("Internet Radio",QString("The current album is %0").arg(m_album));
                }
                if (gst_tag_list_get_uint(tags,GST_TAG_BITRATE,&bitrate)) {
                    if (m_bitrate != bitrate) {
                        m_bitrate = bitrate;
                        emit bitrateChanged();
                    }

                    emit tagReceived("bitrate",QString::number(m_bitrate));
                    m_eventsFeed.addItem("Internet Radio",QString("The current bitrate is %0").arg(QString::number(m_bitrate)));
                }

                g_free(taglistString);
                gst_object_unref(tags);
                break;
            case GST_MESSAGE_ERROR:
                gchar *debug;
                GError *err;
                gst_message_parse_error(msg, &err, &debug);
                g_free(debug);
                this->m_sErrorMsg = QString::fromAscii(err->message);
                emit error();
                g_error_free(err);
                m_eventsFeed.addItem("An error has occured",this->m_sErrorMsg);
                break;
            default:
                    break;
        }
        gst_object_unref(msg);
        msg = gst_bus_pop(m_bus);
    }
    gst_object_unref(msg);

    return;
}

bool GstPlayer::isUrlValid(const QString &url)
{
    QUrl newUrl(url);
    bool retval = newUrl.isValid() && !newUrl.isRelative();
    return retval;
}
