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

/*!
 * @brief Includes sample code for Ambient light, Proximity and Orientation demo
 */
Page {
    id: mainPage

    //! Property holds height of rectangle for ambient light sensor part
    property int rectHeight: (screen.currentOrientation === Screen.Landscape)
                             ? (mainPage.height - 5) / 5 : 51

    //! Used to indicate if device is in portrait mode
    property bool isPortrait: (screen.currentOrientation === Screen.Landscape) ? false : true

    //! Holds value of sound indicator off/on
    property bool soundOn: false

    //! Holds value of sound indicator before app entering to inactive state
    property bool soundInactive: false

    //! Used to indicated if file need to be played
    property bool forcePlay: false

    //! Property holds text for orientation
    property string orientationText: ""

    //! Property holds filename for orientation speaking
    property string orientationValue: ""

    //! Property holds ambient light level, -1 equals to Undefined
    property int ambientLight: -1

    //! Property holds proximity value
    property bool proximityValue: false

    //! Using common toolbar defined in main/qml/main.qml
    tools: commonTools

    //! Check if application is active, mute sound and stop sensors if not
    Connections {
        target: Qt.application

        onActiveChanged: {
            if (Qt.application.active) {
                soundOn = soundInactive;
                orientationSensor.active = true;
                ambientSensor.active = true;
                proximitySensor.active = true;
            }
            else {
                soundInactive = soundOn;
                soundOn = false;
                orientationSensor.active = false;
                ambientSensor.active = false;
                proximitySensor.active = false;
                orientSound.stop();
            }
        }
    }

    //! Hide the statusbar and retrieve soundControl value when component startup has completed.
    Component.onCompleted:  {
        rootWindow.showStatusBar = false;
        soundOn = rootWindow.soundControl;
    }

    /*!
     * Revert the status of the status bar, stop sensors and save value of sound control
     * when component begins destruction
     */
    Component.onDestruction: {
        orientationSensor.active = false;
        ambientSensor.active = false;
        proximitySensor.active = false;

        rootWindow.showStatusBar = true;
        rootWindow.soundControl = soundOn;
        orientSound.stop();
    }

    /*!
     * Instance of QtMobility AmbientLightSensor
     * The AmbientLightSensor element reports on ambient lighting conditions.
     */
    AmbientLightSensor {
        id: ambientSensor
        active: true
        onReadingChanged: ambientLight = reading.lightLevel
    }

    /*!
     * Instance of QtMobility ProximitySensor
     * The ProximitySensor element reports on object proximity.
     */
    ProximitySensor {
        id: proximitySensor
        active: true
        onReadingChanged: proximityValue = reading.close
    }

    /*!
     * Instance of QtMobility OrientationSensor
     * The OrientationSensor element reports device orientation.
     */
    OrientationSensor {
        id: orientationSensor
        active: true
        onReadingChanged: {
            if (reading.orientation === OrientationReading.TopUp) {
                orientationText = "Orientation: Top Up";
                orientationValue = "topup";
            } else if (reading.orientation === OrientationReading.TopDown) {
                orientationText = "Orientation: Top Down";
                orientationValue = "topdown";
            } else if (reading.orientation === OrientationReading.LeftUp) {
                orientationText = "Orientation: Left Up";
                orientationValue = "leftup";
            } else if (reading.orientation === OrientationReading.RightUp) {
                orientationText = "Orientation: Right Up";
                orientationValue = "rightup";
            } else if (reading.orientation === OrientationReading.FaceUp) {
                orientationText = "Orientation: Face Up"
                orientationValue = "faceup"
            } else if (reading.orientation === OrientationReading.FaceDown) {
                orientationText = "Orientation: Face Down"
                orientationValue = "facedown"
            } else {
                orientationText = "Orientation: Undefined"
                orientationValue = "undefined"
            }
        }
    }

    onSoundOnChanged:  {
        //! When sound for the orientation is on, the device should speak the current orientation
        if (soundOn) {
            orientSound.autoLoad = true;
            orientSound.position = 0;
            orientSound.play();
        }
        else {
            orientSound.autoLoad = false;
        }
    }

    /*!
     * UI contains a three parts. One is visually representing ambient light
     * sensor data, another one displaying proximity sensor data and there is also
     * orientation sensor functionality.
     *
     * Ambient light displayed as rectangles column, where rectangles have
     * different colors and text. There are separate rectangles for values:
     * Sunny, Bright, Light, Twilight, Dark.
     *
     * Proximity sensor data visualised with image of rounded rectangle changing
     * size and text.
     *
     * For orientation sensor demonstration there is sound control. When sound
     * is on, the device speak the current orientation. When the device
     * orientation changes, the device also tell the new orientation.
     */
    Item {
        anchors.fill: parent
        visible: ( rootWindow.pageStack.depth !== 1) ? true : false

        //! Ambient light column
        Column {
            id: ambientColumn
            width: isPortrait? mainPage.width : 277
            anchors { right: parent.right; bottom: parent.bottom }

            //! Separator above Sunny
            Rectangle {
                id: topSeparator
                width:  parent.width; height: 1
                color: "#EA650A"
            }

            //! Rectangle for Sunny value from sensor
            Rectangle {
                id: sunnyRect
                width:  parent.width; height: rectHeight
                color: ambientLight === 5 ? "#EA650A" : "black"

                //! Sunny text label
                Label {
                    text: "Sunny"
                    font: uiConstants.HeaderFont
                    visible: ambientLight === 5 ? true : false
                    anchors { fill: parent; margins: 10 }
                }
            }

            //! Separator between Sunny and Bright
            Rectangle {
                id: sunnySeparator
                width:  parent.width; height: 1
                color: "#EA650A"
            }

            //! Rectangle for Bright value from sensor
            Rectangle {
                id: brightRect
                width:  parent.width
                height: rectHeight
                color: ambientLight >= 4 ? "#F77219" : "black"

                //!Bright text label
                Label {
                    text: "Bright"
                    font: uiConstants.HeaderFont
                    visible: ambientLight  === 4 ? true : false
                    anchors { fill: parent; margins: 10 }
                }
            }

            //! Separator between Bright and Light
            Rectangle {
                id: brightSeparator
                width:  parent.width; height: 1
                color: "#F77219"
            }

            //! Rectangle for Light value from sensor
            Rectangle {
                id: lightRect
                width:  parent.width; height: rectHeight
                color: ambientLight >= 3 ? "#FF8500" : "black"

                //! Light/Undefined text label
                Label {
                    text: ambientLight < 1 ? "Undefined" : "Light"
                    font: uiConstants.HeaderFont
                    anchors { fill: parent; margins: 10 }
                    visible: ( ambientLight === 3 || ambientLight < 1 ) ? true : false
                }
            }

            //! Separator between Light and Twilight
            Rectangle {
                id: lightSeparator
                width:  parent.width; height: 1
                color: "#FF8500"
            }

            //! Rectangle for Twilight value from sensor
            Rectangle {
                id: twilightRect
                width:  parent.width; height: rectHeight
                color: ambientLight >= 2 ? "#ED9507" : "black"

                //! Twilight text label
                Label {
                    text: "Twilight"
                    font: uiConstants.HeaderFont
                    visible: ambientLight === 2 ? true : false
                    anchors { fill: parent; margins: 10 }
                }
            }

            //! Separator between Twilight and Dark
            Rectangle {
                id: twilightSeparator
                width:  parent.width; height: 1
                color: "#ED9507"
            }

            //! Rectangle for Dark value from sensor
            Rectangle {
                id: darkRect
                width:  parent.width; height: rectHeight
                color: ambientLight >= 1 ? "#F2B111" : "black"

                //! Dark text label
                Label {
                    text: "Dark"
                    font: uiConstants.HeaderFont
                    visible: ambientLight === 1 ? true : false
                    anchors { fill: parent; margins: 10 }
                }
            }
        }

        //! Proximity sensor column
        Column {
            id: proximityColumn
            anchors { left: parent.left; right: isPortrait ? parent.right : ambientColumn.left;
                top:  parent.top ; topMargin: isPortrait ? 0 : 35;
                bottom: isPortrait ? ambientColumn.top : parent.bottom }

            //! Display text information pointing position of sensor. This row visible in landscape
            Row {
                id: ambientSensorText
                spacing: 5

                //! Visible only in landscape
                visible: isPortrait ? false : true

                Image {
                    source: "image://theme/icon-m-common-drilldown-arrow-inverse"
                    mirror: true
                }
                Label {
                    text: "Sensors are here."
                    anchors.verticalCenter: parent.verticalCenter
                    font: uiConstants.BodyTextFont
                }
            }

            //! Display text information pointing position of sensor. This column visible in portrait
            Column {
                id: ambientTextColumn
                anchors { right: parent.right; rightMargin: 35 }

                //! Visible only in portrait
                visible: isPortrait ? true : false

                Image {
                    source: "image://theme/icon-m-common-drilldown-arrow-inverse"
                    mirror: true
                    transformOrigin: Item.BottomRight
                    rotation: 90
                    anchors { right: parent.right; rightMargin: 35 }
                }
                Label {
                    text: "Sensors are here."
                    font: uiConstants.BodyTextFont
                }
            }

            Item {
                //! Image changing when value from proximity sensor changes
                id: rectContainer
                width: parent.width
                height: isPortrait ? (mainPage.height - 4 - rectHeight * 5
                                      - ambientTextColumn.height - orientContainer.height)
                                   : (mainPage.height - 35 - ambientSensorText.height
                                      - orientContainer.height)

                Image {
                    id: proximityImage
                    source: proximityValue ? "icons/proximity_close.png"
                                           : "icons/proximity_distant.png"
                    anchors.centerIn: parent
                    width: proximityValue ? 200 : 120
                    height: proximityValue ? 200 : 120
                    smooth: true

                    //! Text label for Close/Distant
                    Label {
                        id: proximityText
                        anchors.centerIn: parent
                        font: uiConstants.HeaderFont
                        text: proximityValue ? "Close" : "Distant"
                    }
                }
            }

             //! Container for Orientation
            Item {
                id: orientContainer

                //! Defining marging for orientation container
                property int iconMarging: isPortrait ? uiConstants.DefaultMargin : 5

                height: volumeIcon.height + iconMarging
                anchors {
                    left: parent.left
                    leftMargin: uiConstants.DefaultMargin
                    right: parent.right
                    rightMargin: uiConstants.DefaultMargin
                }

                //! Using QML audio element to play file
                Audio {
                    id: orientSound

                    //! Source changing when value from orientation sensor changes
                    source: "media/" + orientationValue + ".wav"
                    autoLoad: false

                    onSourceChanged:  {
                        /*!
                         * If source changed while previous file still playing, we need to
                         * stop playback of playing file and wait when new file is loaded.
                         */
                        if (soundOn) {
                            if (playing) {
                                stop();
                                forcePlay = true;
                            } else {
                                //! If nothing playing, just play needed media
                                play();
                            }
                        }
                    }
                    onStatusChanged: {
                        //! Check if loaded file need to be played
                        if (status === Audio.Loaded && forcePlay) {
                            forcePlay = false;
                            play();
                        }
                    }
                }

                //! Volume control icon and orientation value text
                Row {
                    spacing: 10
                    anchors.top: parent.top
                    width: parent.width
                    layoutDirection: isPortrait ? Qt.RightToLeft : Qt.LeftToRight

                    Image {
                        id: volumeIcon
                        source: soundOn ? "image://theme/icon-m-telephony-volume-button"
                                        : "image://theme/icon-m-telephony-volume-button-dimmed"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: soundOn = !soundOn;
                        }
                    }

                    //! Displaying orientation value
                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        text: orientationText
                    }
                }

            }
        }
    }

    //! States and transitions
    states: [ State {
            name: "close"; when: proximityValue
            PropertyChanges {
                target: proximityImage
                width: 200
                height: 200
                source: "icons/proximity_close.png"
            }
        },

        State {
            name: "distant"; when: !proximityValue
            PropertyChanges {
                target: proximityImage
                width: 120
                height: 120
                source: "icons/proximity_distant.png"
            }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "width,height,source"; duration: 100 }
    }
}

//!  End of File
