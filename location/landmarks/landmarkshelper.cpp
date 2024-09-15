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

#include "landmarkshelper.h"
#include <QLandmarkNameFilter>
#include <QLandmarkUnionFilter>
#include <QStringList>
#include <QLandmark>

#include <QDebug>

LandmarksHelper::LandmarksHelper(QObject *parent) :
    QObject(parent)
{
    m_landmarkManager = new QLandmarkManager();
    m_fetchLandmarks = new QLandmarkFetchRequest(m_landmarkManager);
    m_removeLandmarks = new QLandmarkRemoveRequest(m_landmarkManager);
    m_importLandmarks = new QLandmarkImportRequest(m_landmarkManager);
}

LandmarksHelper::~LandmarksHelper()
{
    if (m_fetchLandmarks)
        delete m_fetchLandmarks;

    if (m_removeLandmarks)
        delete m_removeLandmarks;

    if (m_importLandmarks)
        delete m_importLandmarks;

    if (m_landmarkManager)
        delete m_landmarkManager;
}

void LandmarksHelper::initSevenWonders()
{
    QStringList sevenWonders;

    sevenWonders << "Chichen Itza" << "Christ the Redeemer" << "Colosseum"
                 << "Great Wall of China" << "Machu Picchu" << "Taj Mahal" << "Petra"
                 << "Great Pyramid of Giza" << "Hanging Gardens of Babylon"
                 << "Statue of Zeus at Olympia" << "Temple of Artemis at Ephesus"
                 << "Mausoleum of Maussollos at Halicarnassus" << "Colossus of Rhodes"
                 << "Lighthouse of Alexandria";

    QLandmarkUnionFilter filter;
    QLandmarkNameFilter name;

    foreach (const QString &str, sevenWonders) {
        name.setName(str);
        filter.append(name);
    }

    m_fetchLandmarks->setFilter(filter);

    connect(m_fetchLandmarks, SIGNAL(stateChanged(QLandmarkAbstractRequest::State)),
            this, SLOT(landmarkFetchRequestHandler(QLandmarkAbstractRequest::State)));

    if (!m_fetchLandmarks->start())
        qDebug() << "Unable to request landmarks, error code:" << m_fetchLandmarks->error();
    else
        qDebug() << "Requested landmarks, awaiting results...";
}

void LandmarksHelper::cancelActiveRequests()
{
    if (m_fetchLandmarks->isActive())
        m_fetchLandmarks->cancel();

    if (m_removeLandmarks->isActive())
        m_removeLandmarks->cancel();

    if (m_importLandmarks->isActive())
        m_importLandmarks->cancel();
}

void LandmarksHelper::landmarkFetchRequestHandler(QLandmarkAbstractRequest::State state)
{
    if (state == QLandmarkAbstractRequest::FinishedState) {
        if (m_fetchLandmarks->error() == QLandmarkManager::NoError) {
            QList<QLandmark> landmarks = m_fetchLandmarks->landmarks();
            m_removeLandmarks->setLandmarks(landmarks);

            connect(m_removeLandmarks, SIGNAL(stateChanged(QLandmarkAbstractRequest::State)), this,
                    SLOT(landmarkRemoveRequestHandler(QLandmarkAbstractRequest::State)));

            if (!m_removeLandmarks->start())
                qDebug() << "Unable to remove landmark, error code: " << m_removeLandmarks->error();
        } else {
            qDebug() << "Landmarks fetch was unsuccessful";
        }
    }
}

void LandmarksHelper::landmarkRemoveRequestHandler(QLandmarkAbstractRequest::State state)
{
    if (state == QLandmarkAbstractRequest::FinishedState) {
        if (m_removeLandmarks->error() == QLandmarkManager::NoError) {
            m_importLandmarks->setFileName(LANDMARKS_FILENAME);

            connect(m_importLandmarks, SIGNAL(stateChanged(QLandmarkAbstractRequest::State)), this,
                    SLOT(landmarkImportRequestHandler(QLandmarkAbstractRequest::State)));
            if (!m_importLandmarks->start())
                qDebug() << "Unable to import landmarks, error code: " << m_importLandmarks->error();
        } else {
            qDebug() << "Landmark removal was unsuccessful";
        }
    }
}

void LandmarksHelper::landmarkImportRequestHandler(QLandmarkAbstractRequest::State state)
{
    if (state == QLandmarkAbstractRequest::FinishedState) {
        if (m_importLandmarks->error() == QLandmarkManager::NoError)
            qDebug() << "Landmark import successfully completed";
        else
            qDebug() << "Landmark import was unsuccessful";
    }
}
