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

#include "audiorecorder.h"
#include <QDebug>
#include <QTimer>
#include <QAudioCaptureSource>
#include <QDateTime>


const QString BASE_DIR("MyDocs/recorded");
const QString FORMAT("wav");


/*!
 * Constructor.
 */
Audiorecorder::Audiorecorder(QObject *parent) :
    QObject(parent),
	m_capture(NULL),
	m_audiosource(NULL)
{
    fileNameSuffix = getCurrentTime();
    generateBaseDir();
    m_audiosource = new QAudioCaptureSource;
    Q_ASSERT(m_audiosource);
    m_capture = new QMediaRecorder(m_audiosource);
    Q_ASSERT(m_capture);
    QAudioEncoderSettings audioSettings;
    audioSettings.setBitRate(320000);
    audioSettings.setSampleRate(22050);
    audioSettings.setChannelCount(1);

    QVideoEncoderSettings videoSettings;
    m_capture->setEncodingSettings(audioSettings, videoSettings, FORMAT);

    connect(m_capture, SIGNAL(durationChanged(qint64)), this, SLOT(durationChanged(qint64)));

}

/*!
 * Destructor.
 */
Audiorecorder::~Audiorecorder()
{
    if(m_capture) delete m_capture;
    if(m_audiosource) delete m_audiosource;
}

/*!
 * Function to return current time in msec from Epoch.
 */
qint64 Audiorecorder::getCurrentTime()
{
    return QDateTime::currentMSecsSinceEpoch();
}

/*!
 * Function to create and open a new file when recording starts.
 */
bool Audiorecorder::createFile()
{
    fileName = getFilePath();
    m_destinationFile.setFileName(fileName);

    if(!m_destinationFile.open( QIODevice::ReadWrite | QIODevice::Append )){
        qWarning()<<"\n File error code:" << m_destinationFile.error();
        return false;
    }
    return true;
}

/*!
 * Function to generate directory to store recorded audio files
 */
void Audiorecorder::generateBaseDir()
{
    QString temp = QDir::homePath();
    temp.append("/");
    temp.append(BASE_DIR);

    QDir::setCurrent(temp);

    QDir dir(temp);
    if (!dir.exists()) {
        dir.mkpath(temp);
    }
}

/*!
 * Function to generate file name to store recorded audio file.
 */
QString Audiorecorder::getFilePath()
{
    QString audioRecDir =  QDir::homePath();
    audioRecDir.append("/");
    audioRecDir.append(BASE_DIR);
    audioRecDir.append("/");
    audioRecDir.append("recorded");
    audioRecDir.append(QString::number(fileNameSuffix));
    audioRecDir.append(".");
    audioRecDir.append(FORMAT);
    return audioRecDir;
}


/*!
 * Function to return the current fileName in which the recorded audio is stored.
 */
QString Audiorecorder::getFileName()
{
    return fileName;
}


/*!
 * Called from QML code to stop recording the audio through audio input device.
 */
void Audiorecorder::stopRecording()
{
    m_capture->stop();
    m_destinationFile.close();
    fileNameSuffix = getCurrentTime();
    qWarning()<< "stopping recording "<< m_capture->error();
}


/*!
 * Called from QML code to pause recording the audio through audio input device.
 */
void Audiorecorder::pauseRecording()
{
    m_capture->pause();

    qWarning()<< "pausing recording "<< m_capture->error();
}


/*!
 * Called when state of the Media Recorder changes.
 */
void Audiorecorder::stateChanged(QMediaRecorder::State state)
{
    qWarning()<<"Rec state is:" << state;
    if(state == QMediaRecorder::RecordingState)
    {
        emit recStatuschanged(1);
    }
    else if(state == QMediaRecorder::StoppedState)
    {
        emit recStatuschanged(0);
    }
    else if(state == QMediaRecorder::PausedState)
    {
        emit recStatuschanged(2);
    }
}

/*!
 * Called when duration of the Media Player changes.
 */
void Audiorecorder::durationChanged(qint64 duration)
{
    emit recDurationChanged(duration);
}

/*!
 * Called from QML code to start recording the audio through audio input device.
 */
void Audiorecorder::record()
{
    //! Registering signal and slot for handling the state changes of Media Recorder
    connect(m_capture, SIGNAL(stateChanged(QMediaRecorder::State)), this, SLOT(stateChanged(QMediaRecorder::State)));
    if(!createFile())
        emit errorOpeningFile();
    else{
        //! Setting the location of recorder audio file.
        m_capture->setOutputLocation(QUrl(getFileName()));
        m_capture->record();
        qWarning()<<"starting recording" << m_capture->error();
    }
}

//! End of File
