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
import com.nokia.meego 1.0

/*!
 * @brief Help page with information about application
 * It is displayed when clicked on icon on toolbar.
 */
Page {
    id: aboutPage
    orientationLock: PageOrientation.LockPortrait
    anchors { fill: parent; margins: uiConstants.DefaultMargin }

    property bool _rootWindow_statusbar: false     //! The statusbar state before loading this page
    property bool _rootWindow_toolbar: false       //! The toolbar state before loading this page
    property bool _theme_inverted: false           //! The theme.inverted state before loading page

    //! We will hide the statusbar and show the toolbar onCompleted signal
    Component.onCompleted: {
        _rootWindow_statusbar = rootWindow.showStatusBar;
        _rootWindow_toolbar = rootWindow.showToolBar;
        _theme_inverted = theme.inverted;
        rootWindow.showStatusBar = true;
        rootWindow.showToolBar = false;
    }

    //! We will revert the statuses of the common elements onDestruction signal
    Component.onDestruction: {
        rootWindow.showStatusBar = _rootWindow_statusbar;
        rootWindow.showToolBar = _rootWindow_toolbar;
        theme.inverted = _theme_inverted;
    }

    Image {
        id: appIcon
        source: "/usr/share/icons/hicolor/80x80/apps/harmattanapishowcase80.png"
        anchors { top: parent.top; horizontalCenter: parent.horizontalCenter }
        visible: (rootWindow.pageStack.depth !== 1) ? true : false
    }

    Label {
        id: appName
        anchors {
            top: appIcon.bottom
            topMargin: uiConstants.DefaultMargin
            horizontalCenter: parent.horizontalCenter
        }

        text: appInfo.getApplicationName() + " Ver" + appInfo.getApplicationVersion()
              + "\n(C) 2012 " + appInfo.getOrganizationName() + "\n"
        visible: (rootWindow.pageStack.depth !== 1) ? true : false
    }

    Column {
        id: buttonsColumn
        spacing: 5
        anchors { bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }
        visible: (rootWindow.pageStack.depth !== 1) ? true : false

        Button {
            text: "Website"

            onClicked: Qt.openUrlExternally("http://harmattan-dev.nokia.com/docs/examples/api-showcase")
        }

        Button {
            text: "Close"

            onClicked: {
                pageStack.pop();
                theme.inverted = _theme_inverted
            }
        }
    }

    Flickable {
        id: flickText

        clip: true
        contentHeight: helpText.height

        anchors {
            top: appName.bottom;
            bottom: buttonsColumn.top
            bottomMargin: uiConstants.DefaultMargin
            left: parent.left
            right: parent.right
        }

        Column {
            id: helpText
            width: aboutPage.width

            Label {
                width: parent.width
                textFormat: Text.RichText
                wrapMode: Text.WordWrap
                visible: (rootWindow.pageStack.depth !== 1) ? true : false
                onLinkActivated: Qt.openUrlExternally("http://harmattan-dev.nokia.com/docs/examples/api-showcase")
                text: "Harmattan API Showcase application showcases the key APIs "
                      + "of the MeeGo 1.2 Harmattan API offering. The showcase application "
                      + "utilizes APIs with QML bindings as much as possible, but falls back to "
                      + "using C++ code when there's no QML API available for a particular "
                      + "functionality. The demonstrated APIs include system information, messaging, "
                      + "NFC, location, multimedia, camera, sensors, etc. To help developers with their "
                      + "application development for Nokia N9, the source code of showcase application is "
                      + "<a href=\"http://harmattan-dev.nokia.com/docs/examples/api-showcase\">available here</a> "
                      + "for download. Harmattan API Showcase Application License Agreement can be"
            }

            Label {
                width: parent.width
                textFormat: Text.RichText
                wrapMode: Text.WordWrap
                visible: (rootWindow.pageStack.depth !== 1) ? true : false
                onLinkActivated: Qt.openUrlExternally("http://harmattan-dev.nokia.com/docs/examples/api-showcase/license.html")
                text: "<a href=\"http://harmattan-dev.nokia.com/docs/examples/api-showcase/license.html\">found here</a> "
                      + "and also in source code ( License_Agreement.txt )."
            }

            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                visible: (rootWindow.pageStack.depth !== 1) ? true : false
                text: "\nSMS:\nThe application window will let you send SMS to a selected contact"
                      + "or a phone number entered in 'To:' field. A contact can be selected by "
                      + "tapping on '+' button or type phone number by tapping on 'Add Contact'. "
                      + "After a valid phone number or contact is added tap on 'Send' button to send "
                      + "the short message."

                      + "\n\nTweet by SMS:\nThe application window will let you send twitter message "
                      + "through SMS from your mobile. The number displayed in 'To:' field is the "
                      + "twitter service number for your current region. Type a message and tap on "
                      + "'Send' button to send the twitter message.\n\n"
                      + "NOTE: The phone number must be already registered with respective account "
                      + "from twitter website to successfully post messages from this application."

                      + "\n\nSend vCard by NFC:\nThe application window will let you share a contact "
                      + "through NFC with other devices. Select the contact you want to share in "
                      + "contacts selection window and bring the phone near target device when asked"
                      + "to share the contact.\n\n"
                      + "NOTE: Enable NFC hardware before you use this application."

                      + "\n\nShow/Pick Location:\nThe application window demonstrates the following "
                      + "key features of location APIs.\n"
                      + "* geocoding - geographical co-ordinates ( latitude and longitude ) of a location.\n"
                      + "* reverse geocoding - human readable street address or place name.\n"
                      + "* maps\n"
                      + "* accessing current coordinate information\n"
                      + "* pick a location on the map by long pressing\n"
                      + "* access information for a specific or selected map location"

                      + "\n\nSeven Wonders of the world:\nThe application window demonstrates the following "
                      + "key features of location APIs.\n"
                      + "* geocoding - geographical co-ordinates ( latitude and longitude ) of a location.\n"
                      + "* reverse geocoding - human readable street address or place name.\n" 
                      + "* maps\n"
                      + "* tag a location on map\n"
                      + "* pick a tagged location on the map by long pressing\n"
                      + "* access information for a selected tag"

                      + "\n\nPlay Audio:\nThis part of application showcases the following key "
                      + "features of multimediakit ( audio ) APIs.\n"
                      + "* access audio media on the device\n"
                      + "* select a audio track to play\n"
                      + "* access meta data of the tracks\n"
                      + "* play, pause selected track\n"
                      + "* seek through playing track\n"
                      + "The application window lets you to choose audio media from the list present "
                      + "on device. In audio play window you can play, pause selected track, navigate "
                      + "through audio tracks by tapping on next and previous buttons, seek through "
                      + "track by flicking/tapping on the progress bar, view duration and track "
                      + "information."

                      + "\n\nPlay Video:\nThis part of application showcases the following key "
                      + "features of multimediakit ( video ) APIs.\n"
                      + "* access video media on the device\n"
                      + "* select a video to play\n"
                      + "* access meta data of the video\n"
                      + "* play, pause selected video\n"
                      + "* seek through playing video\n"
                      + "The application lets you to choose a video from the list present on "
                      + "device. In video play window you can play, pause selected track, seek "
                      + "through track by flicking/tapping on the progress bar. The meta data area "
                      + "of the video can be toggled by tapping on the video region in the window."

                      + "\n\nView Image:\nThis part of application showcases the following key features of "
                      + "multimediakit ( images ) APIs.\n"
                      + "* access images present on device\n"
                      + "* usage of gallery models to display images\n"
                      + "* access meta data of images\n"
                      + "The application window lets you select an image from grid view by tapping to display "
                      + "image in full screen. The meta data of the displayed image is shown by default which "
                      + "can be toggled by tapping on the image screen area."

                      + "\n\nSound Effects:\nThis part of application showcases the following key features of "
                      + "multimediakit ( sound effects ) APIs.\n"
                      + "* sound effects API usage\n"
                      + "* play a sound files\n"
                      + "The application window lets you select an image from grid view by tapping to display "
                      + "image in full screen. The meta data of the displayed image is shown by default which "
                      + "can be toggled by tapping on the image screen area."

                      + "\n\nRecord Audio:\nThis part of application showcases the following key features of "
                      + "multimediakit APIs.\n"
                      + "* record audio from microphone\n"
                      + "* play back recorded audio\n"
                      + "The application window will let you record audio from device microphone and playback "
                      + "the stream. The recordings are saved to MyDocs/recordings on the device file system."

                      + "\n\nCapture Image:\nThis part of application showcases the following key features of "
                      + "multimedia ( camera ) APIs.\n"
                      + "* use camera viewfinder for camera UI\n"
                      + "* capture images\n"
                      + "* select among various camera properties like flash and scene modes\n"
                      + "* view captured image\n"
                      + "The application window will let you capture pictures of predefined resolution from main "
                      + "camera with possibility to chose among camera properties like flash and scene modes. The "
                      + "captured picture is shown in full screen until back button is tapped to resume to view "
                      + "finder window."

                      + "\n\nInternet Radio:\nThis part of application showcases the following key features of "
                      + "multimedia ( QML Audio, GStreamer ), Events Feed and Notification APIs.\n"
                      + "* Retrieve information of audio streams\n"
                      + "* Play, pause and resume internet audio streams\n"
                      + "* Record internet audio streams\n"
                      + "* Mark internet radio stations as favourite\n"
                      + "The application window will let you add internet radio stations and display its meta data "
                      + "when being played. It also provides ability to record internet radio streams and save "
                      + "stations to favourites. The saved recordings can be found in MyDocs/Music."

                      + "\n\nSystem Information:\nThis part of application showcases the following key features of "
                      + "system information APIs which can be used to access various information of the device.\n"
                      + "* battery information\n"
                      + "* device information\n"
                      + "* display information\n"
                      + "* general information\n"
                      + "* network information\n"
                      + "* storage information\n"
                      + "* system state information\n"
                      + "* time settings information\n"
                      + "The application window will let you know hardware and software capabilities, current states "
                      + "and various other information reflected on the device. The initial window shows the list of "
                      + "information that can be browsed by tapping on the respective item and then navigate across by "
                      + "flick gestures."

                      + "\n\nAccelerometer, Tap Sensors:\nThis part of application showcases the following key features of "
                      + "accelerometer and tap sensor APIs.\n"
                      + "* accessing realtime X, Y and Z axis values from accelerometer sensor\n"
                      + "* accessing realtime tap readings from device\n"
                      + "The application window displays the realtime readings of X, Y and Z axis from accelerometer "
                      + "sensor. The UI utilizes a graphical ball that moves around the screen showcasing how the sensor "
                      + "readings can be used by developers. The application also showcase usage of Tap sensor readings "
                      + "whenever the graphical ball touches edges of the screen. The record button enables application "
                      + "to save accelerometer sensor readings to a file saved in folder /MyDocs/sensorReadings."

                      + "\n\nAmbient Light, Proximity, Orientation Sensors:\nThis part of application showcases the "
                      + "following key features of ambient light, proximity and orientation sensor APIs.\n"
                      + "* accessing realtime device orientation\n"
                      + "* accessing realtime proximity to device\n"
                      + "* accessing realtime light level detected by device\n"
                      + "The application window shows the current ambient light level and proximity level readings from "
                      + "respective sensors when an object is close to sensors located at top the device ( also an indicator "
                      + "is shown in application window ). The application window orientation is respectively updated to "
                      + "match device orientation sensor reading and also the current orientation can be heard by tapping on "
                      + "icon located next to orientation text."

                      + "\n\nCompass, Rotation Sensors:\nThis part of application showcases the following key features of "
                      + "compass and rotation sensor APIs.\n"
                      + "* accessing realtime compass reading\n"
                      + "* accessing realtime rotation sensor reading\n"
                      + "The application window graphically shows the current compass reading with a compass dial on camera "
                      + "view finder background. The readings of compass azimuth and calibration level along with rotation "
                      + "sensor reading are displayed at top of application window."
            }
        }
    }

    //! Scroll decorator for the flickable area
    ScrollDecorator {
        flickableItem: flickText
    }
}

//!  End of File
