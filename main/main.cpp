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

/*!
 * INCLUDES
 */
#include "multimedia/multimediakit/audiorecorder.h"
#include "multimedia/multimediakit/thumbnailutility.h"
#include "communications/messenger.h"
#include "communications/twitsender.h"
#include "communications/nfcsendvcard.h"
#include "location/geocoding/reversegeocode.h"
#include "location/landmarks/landmarkshelper.h"
#include "systems/systeminfo/qmbatteryreader.h"
#include "systems/systeminfo/qmcabcreader.h"
#include "systems/systeminfo/qmdevicemodereader.h"
#include "systems/systeminfo/qmdisplaystatereader.h"
#include "systems/systeminfo/qmsystemstatereader.h"
#include "systems/systeminfo/qmtimereader.h"
#include "systems/sensors/accelerometertap/fileio.h"
#include "qmlapplicationviewer/qmlapplicationviewer.h"
#include "multimedia/internetradio/channelitem.h"
#include "multimedia/internetradio/channelmodelproxy.h"
#include "multimedia/internetradio/listmodel.h"

#include <QtGui/QApplication>
#include <qdeclarative.h>
#include <QDeclarativeContext>

#include <qtorganizer.h>

#include "appinfo.h"
#include "main/phonetools.h"
#include "multimedia/internetradio/gstplayer.h"
#include "main/appsettings.h"

#ifdef NO_DEBUG_PRINTS
//! Disable debug messages for Release build
void myMessageHandler(QtMsgType type, const char *msg)
{
}
#endif

Q_DECL_EXPORT int main(int argc, char *argv[])
{
#ifdef NO_DEBUG_PRINTS
    qInstallMsgHandler(myMessageHandler);
#endif

    //! Get application instance
    QScopedPointer<QApplication> app(createApplication(argc, argv));
    QScopedPointer<QmlApplicationViewer> viewer(QmlApplicationViewer::create());

    app->setFont(QFont("Nokia Pure Text"));

    //! Set application information
    app->setApplicationName("Harmattan API Showcase");
    app->setOrganizationName("Nokia Corporation");
    app->setOrganizationDomain("nokia.com");

    //! These defines are coming from .pro file
    app->setApplicationVersion(QString("%0.%1.%2").arg(APPVERSION_MAJOR).arg(APPVERSION_MINOR).arg(APPVERSION_PATCH));

    qRegisterMetaType<QOrganizerAbstractRequest::State>("QOrganizerAbstractRequest::State");

    qmlRegisterType<AppInfo>("com.nokia.harmattanapishowcase", 1, 0, "AppInfo");
    qmlRegisterType<Audiorecorder>("com.nokia.harmattanapishowcase", 1, 0, "Audiorecorder");
    qmlRegisterType<Messenger>("com.nokia.harmattanapishowcase", 1, 0, "Messenger");
    qmlRegisterType<TwitSender>("com.nokia.harmattanapishowcase", 1, 0, "TwitSender");
    qmlRegisterType<GeoCoder>("com.nokia.harmattanapishowcase",1,0 ,"GeoCoder");
    qmlRegisterType<LandmarksHelper>("com.nokia.harmattanapishowcase",1,0 ,"LandmarksHelper");
    qmlRegisterType<NfcSendvCard>("com.nokia.harmattanapishowcase", 1, 0, "NfcSendvCard");
    qmlRegisterType<ThumbnailUtility>("com.nokia.harmattanapishowcase", 1,0, "ThumbnailUtility");

    qmlRegisterType<PhoneTools>("com.nokia.harmattanapishowcase",1,0,"PhoneTools");
	qmlRegisterType<GstPlayer>("com.nokia.harmattanapishowcase",1,0,"GstPlayer");
	qmlRegisterType<QEventsFeed>("com.nokia.harmattanapishowcase",1,0,"EventsFeed");
    qmlRegisterType<AppSettings>("com.nokia.harmattanapishowcase",1,0,"AppSettings");

    ListModel *model = new ListModel(new ChannelItem);
    ChannelModelProxy modelProxy(model);
    viewer->rootContext()->setContextProperty("channelModel",model);
    viewer->rootContext()->setContextProperty("channelModelProxy",&modelProxy);

    //! Register types that used for displaying System information
    qmlRegisterType<FileIO>("com.nokia.harmattanapishowcase", 1, 0, "FileIO");
    qmlRegisterType<QmBatteryReader>("com.nokia.harmattanapishowcase", 1, 0, "QmBatteryReader");
    qmlRegisterType<QmCABCReader>("com.nokia.harmattanapishowcase", 1, 0, "QmCABCReader");
    qmlRegisterType<QmDeviceModeReader>("com.nokia.harmattanapishowcase", 1, 0, "QmDeviceModeReader");
    qmlRegisterType<QmDisplayStateReader>("com.nokia.harmattanapishowcase", 1, 0, "QmDisplayStateReader");
    qmlRegisterType<QmSystemStateReader>("com.nokia.harmattanapishowcase", 1, 0, "QmSystemStateReader");
    qmlRegisterType<QmTimeReader>("com.nokia.harmattanapishowcase", 1, 0, "QmTimeReader");

    viewer->setMainQmlFile(QLatin1String("main/qml/main.qml"));
    viewer->showExpanded();

    return app->exec();
}

//!  End of File
