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

import QtQuick 1.1

/*!
 * @brief ListView of the componets and its sub-sections in the main page
 */
ListModel {
    id: exampleSections

    //! Communication
    ListElement {
        title: "SMS"
        subtitle: "Qt Mobility 1.2/ Messaging"
        page: "../../communications/qml/SMSSender.qml"
        section:"Communications"
    }

    ListElement {
        title: "Tweet by SMS"
        subtitle: "Qt Mobility 1.2/ Messaging"
        page: "../../communications/qml/TwitSender.qml"
        section:"Communications"
    }

    ListElement {
        title: "Send vCard by NFC"
        subtitle: "Qt Mobility 1.2/ Messaging"
        page: "../../communications/qml/AddressBookforNFC.qml"
        section:"Communications"
    }

    //! Location
    ListElement {
        title: "Show/Pick Location"
        subtitle: "Qt Mobility 1.2/ Location"
        page: "../../location/geocoding/qml/Location.qml"
        section: "Location"
    }

    ListElement {
        title: "Seven wonders of the world"
        subtitle: "Qt Mobility 1.2/ Location"
        page: "../../location/landmarks/qml/SevenWonders.qml"
        section: "Location"
    }

    //! Multimedia
    ListElement {
        title: "Play Audio"
        subtitle: "QtMultimediaKit"
        page: "../../multimedia/multimediakit/qml/AudioFileSelector.qml"
        section:"Multimedia"
    }

    ListElement {
        title: "Play Video"
        subtitle: "QtMultimediaKit"
        page: "../../multimedia/multimediakit/qml/VideoFileSelector.qml"
        section:"Multimedia"
    }

    ListElement {
        title: "View Image"
        subtitle: "QtMultimediaKit"
        page: "../../multimedia/multimediakit/qml/ImageViewer.qml"
        section:"Multimedia"
    }

    ListElement {
        title: "Sound Effects"
        subtitle: "QtMultimediaKit"
        page: "../../multimedia/multimediakit/qml/SoundEffects.qml"
        section:"Multimedia"
    }

    ListElement {
        title: "Record Audio"
        subtitle: "QtMultimediaKit"
        page: "../../multimedia/multimediakit/qml/AudioRecorder.qml"
        section:"Multimedia"
    }

    ListElement {
        title: "Capture Image"
        subtitle: "QtMultimediaKit"
        page: "../../multimedia/multimediakit/qml/Camera.qml"
        section:"Multimedia"
    }

    ListElement {
        title: "Internet Radio"
        subtitle: "QmlAudio,GStreamer,EventsFeed,MNotification"
        page: "../../multimedia/internetradio/qml/InternetRadio.qml"
        section: "Multimedia"
    }

    //! System Infomation
    ListElement {
        title: "System Information"
        subtitle: "Qt Mobility 1.2/ SystemInfo, QmSystem"
        page: "../../systems/systeminfo/qml/SystemInfo.qml"
        section: "System"
    }

    ListElement {
        title: "Accelerometer, Tap"
        subtitle: "Qt Mobility 1.2/ Sensors"
        page: "../../systems/sensors/accelerometertap/qml/AccelerometerTap.qml"
        section: "System"
    }

    ListElement {
        title: "Ambient Light, Proximity, Orientation"
        subtitle: "Qt Mobility 1.2/ Sensors"
        page: "../../systems/sensors/qml/AmbientProximity.qml"
        section: "System"
    }

    ListElement {
        title: "Compass, Rotation"
        subtitle: "Qt Mobility 1.2/ Sensors"
        page: "../../systems/compass/qml/CompassPage.qml"
        section: "System"
    }
}

//! End of File
