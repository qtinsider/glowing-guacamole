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
import QtMobility.sensors 1.2
import QtMultimediaKit 1.1
import com.nokia.harmattanapishowcase 1.0

/*!
 * CompassPage
 * Includes sample code for QtMobility Compass, RotationSensor and OrientationSensor
 */
Page {
    id: compassPage
    tools: commonTools
    orientationLock: PageOrientation.LockLandscape

    property bool _rootWindow_statusbar: false     //! The statusbar state before loading this page
    property bool _rootWindow_toolbar: false       //! The toolbar state before loading this page
    property bool _theme_inverted: false           //! The theme.inverted state before loading page

    //! We will hide the statusbar and show the toolbar onCompleted signal
    Component.onCompleted: {
        _rootWindow_statusbar = rootWindow.showStatusBar;
        _rootWindow_toolbar = rootWindow.showToolBar;
        _theme_inverted = theme.inverted;
        rootWindow.showStatusBar = false;
        rootWindow.showToolBar = false;
        screen.allowSwipe = false;
    }

    //! We will revert the statuses of the common elements onDestruction signal
    Component.onDestruction: {
        rootWindow.showStatusBar = _rootWindow_statusbar;
        rootWindow.showToolBar = _rootWindow_toolbar;
        theme.inverted = _theme_inverted;
        screen.allowSwipe = true;
    }

    //! Instance of QtMobility RotationSensor
    RotationSensor {
        id: rotation
        active: true

        onReadingChanged: {
            compassUI.rotationX = reading.x;
            compassUI.rotationY = reading.y;
            compassUI.rotationZ = reading.z;
        }
    }

    //! Instance of QtMobility OrientationSensor
    OrientationSensor {
        id: orientation
        active: true

        onReadingChanged: {
            compassUI.isFaceUp = (reading.orientation === OrientationReading.FaceUp);

            switch (reading.orientation) {
            case OrientationReading.FaceUp:
                compassUI.orientationDesc = "Face Up";
                break;
            case OrientationReading.FaceDown:
                compassUI.orientationDesc = "Face Down";
                break;
            case OrientationReading.LeftUp:
                compassUI.orientationDesc = "Left Up";
                break;
            case OrientationReading.RightUp:
                compassUI.orientationDesc = "Right Up";
                break;
            case OrientationReading.TopDown:
                compassUI.orientationDesc = "Top Down"
                break;
            case OrientationReading.TopUp:
                compassUI.orientationDesc = "Top Up";
                break;
            default:
                compassUI.orientationDesc = reading.orientation
                break;
            }
        }
    }

    //! Instance of QtMobility Compass
    Compass {
        id: compass
        active: true

        onReadingChanged: {
            compassUI.azimuth = reading.azimuth;
            compassUI.calibrationLevel = reading.calibrationLevel
        }
    }

    PhoneTools { id: phoneTools }

    Connections {
        target: phoneTools

        onIncomingCall: {
            camera.stop();
            compass.active = false;
            orientation.active = false;
            rotation.active = false;
            pageStack.pop();
            screen.allowSwipe = true;
        }
    }

    Camera {
        id: camera
        x: 0
        y: 0
        width: screen.displayWidth
        height: screen.displayHeight
        captureResolution: Qt.size(screen.displayWidth,screen.displayHeight)

        onStateChanged: {
            print("onStateChanged: " . state)
        }
    }

    Column {
        anchors.fill: parent

        CompassUIStats {
            id: compassStats
            height: 50
            azimuth: compassUI.azimuth
            calibrationLevel: compassUI.calibrationLevel.toPrecision(2)
            rotationX: compassUI.rotationX
            rotationY: compassUI.rotationY
            rotationZ: compassUI.rotationZ

            Image {
                anchors.top: compassStats.bottom
                height: 10
                width: parent.width
                source: "image://theme/meegotouch-menu-shadow-bottom"
            }
        }

        CompassUI {
            id: compassUI
            width: parent.width
            height: parent.height-50
        }
    }

    Image {
        id : backIcon;
        anchors { left: parent.left; bottom: parent.bottom; margins: uiConstants.DefaultMargin }
        source: "icons/Back_button_black_bg.png"
        opacity: 0.5

        MouseArea {
            anchors.fill: parent

            onClicked: {
                camera.stop();
                compass.active = false;
                orientation.active = false;
                rotation.active = false;
                pageStack.pop();

                //! Changing back the Theme to White when returning to the Main Page
                if (pageStack.depth === 1) theme.inverted = false;;
            }
        }
    }
}

//!  End of File
