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

#ifndef LANDMARKSHELPER_H
#define LANDMARKSHELPER_H

#include <QObject>
#include <QLandmarkManager>
#include <QLandmarkFetchRequest>
#include <QLandmarkAbstractRequest>
#include <QLandmarkRemoveRequest>
#include <QLandmarkImportRequest>

#define LANDMARKS_FILENAME           "/opt/harmattanapishowcase/location/landmarks/qml/seven.lmx"

QTM_USE_NAMESPACE

class LandmarksHelper : public QObject
{
    Q_OBJECT
public:
    explicit LandmarksHelper(QObject *parent = 0);
    ~LandmarksHelper();
    
    Q_INVOKABLE void initSevenWonders();
    Q_INVOKABLE void cancelActiveRequests();

private slots:
    void landmarkFetchRequestHandler(QLandmarkAbstractRequest::State state);
    void landmarkRemoveRequestHandler(QLandmarkAbstractRequest::State state);
    void landmarkImportRequestHandler(QLandmarkAbstractRequest::State state);

private:
    QLandmarkManager* m_landmarkManager;
    QLandmarkFetchRequest* m_fetchLandmarks;
    QLandmarkRemoveRequest* m_removeLandmarks;
    QLandmarkImportRequest* m_importLandmarks;
};

#endif // LANDMARKSHELPER_H
