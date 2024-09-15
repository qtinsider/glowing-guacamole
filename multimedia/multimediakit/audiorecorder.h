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

#ifndef AUDIORECORDER_H
#define AUDIORECORDER_H

/*!
 * INCLUDES
 */
#include <QObject>
#include <QAudioInput>
#include <QMediaPlayer>
#include <QFile>
#include <QDir>
#include <QMediaRecorder>
#include <QAudioCaptureSource>

/*!
 * CLASS DECLARATION
 */

/*!
 *  @class Audiorecorder audiorecorder.h multimedia/audiorecorder.h
 *  @brief Audio capture using QAudioCaptureSource as audio
 *  source.
 *
 *  Audiorecorder class inherited from QObject provides methods to
 *  intitialize and control audio capture using QAudioCaptureSource as audio
 *  source.
 *
 *  QMediaRecorder records the audio captured from QAudioCaptureSource.
 *
 *  QMediaPlayer is used to playback the captured audio file.
 */
class Audiorecorder : public QObject
{
    Q_OBJECT

public:
    /*!
     * @brief Member Function
     *
     * Constructor.
     */
    explicit Audiorecorder(QObject *parent = 0);

    /*!
     * @brief Member Function
     *
     * Destructor.
     */
    ~Audiorecorder();

    /*!
     * @brief Member Function
     *
     * Function to return current time in msec from Epoch.
     * @return qint returns the current time in msec from Epoch
     */
    qint64 getCurrentTime();

    /*!
     * @brief Member Function
     *
     * Function to generate file name to store recorded audio file.
     * @return QString returns the generated file path
     */
    Q_INVOKABLE QString getFilePath();

    /*!
     * @brief Member Function
     *
     * Function to return the current fileName in which the recorded audio is stored.
     * @return QString returns the current file name.
     */
    Q_INVOKABLE QString getFileName();

    /*!
     * @brief Member Function
     *
     * Function to generate directory to store recorded audio files
     * @return void
     */
    void generateBaseDir();

    /*!
     * @brief Member Function
     *
     * Function to create and open a new file when recording starts.
     * @return bool returns true is file creation is succesfull and false if it fails.
     */
    bool createFile();

    /*!
     * @brief Member Function
     *
     * Called from QML code to start recording the audio through audio input device.
     * @return void
     */
    Q_INVOKABLE void record();

    /*!
     * @brief Member Function
     *
     * Called from QML code to stop recording the audio through audio input device.
     * @return void
     */
    Q_INVOKABLE void stopRecording();

    /*!
     * @brief Member Function
     *
     * Called from QML code to pause recording the audio through audio input device.
     * @return void
     */
    Q_INVOKABLE void pauseRecording();

public:
    /*!
      * Integer variable to store and increment file name suffix
      */
    qint64 fileNameSuffix;

    /*!
      * Integer variable to store file name used for the file to store recorded audio
      */
    QString fileName;

signals:
    /*!
      * @brief Signal
      *
      * Signal emitted when the audio recording status changes
      * @param recstate holds state of the QMediaRecorder
      * @return void
      */
    void recStatuschanged(qint64 recstate);

    /*!
      * @brief Signal
      *
      * Signal emitted when the audio recording duration changes
      * @param recDuration holds duration of audio recording
      * @return void
      */
    void recDurationChanged(qint64 recDuration);

    /*!
      * @brief Signal
      *
      * Signal emitted when opening file to record audio fails   
      * @return void
      */
    void errorOpeningFile();

private:
    /*!
     * Pointer object to the Media Recorder which records audio available through
     * audio capture source.
     */
    QMediaRecorder *m_capture;

    /*!
     * Pointer object to the Audio capture source.
     */
    QAudioCaptureSource *m_audiosource;

    /*!
     * Creating a new file reference used to store recorded audio.
     */
    QFile m_destinationFile;

public slots:
    /*!
     * @brief Slot
     *
     * Called when state of the Media Recorder changes.     
     * @param state, Holds state of the QMediaRecorder
     * @return void
     */
    void stateChanged(QMediaRecorder::State state);

    /*!
     * @brief Slot
     *
     * Called when duration of the Media Player changes.    
     * @param duration, Holds duration of the audio recorder
     * @return void
     */
    void durationChanged(qint64 duration);
};

#endif // AUDIORECORDER_H
