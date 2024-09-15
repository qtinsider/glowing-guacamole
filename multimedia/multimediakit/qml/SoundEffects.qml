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
import QtMultimediaKit 1.1

/*!
 * @brief Produce sound effects supported in QtMultimediaKit.
 * Currently playing sound in loops is implemented.
 */
Page {
    id: soundeffectspage
    orientationLock: PageOrientation.LockPortrait
    tools: commonTools

    //! Integer variable for holding the number of loops to play
    property int loopcounter: 1;

    //! Function to return the count of loopcounter variable.
    function getloopvalue() {
        return loopcounter;
    }

    //!  Timer for updating the loop count display.
    Timer {
        id: timer
        running: true
        interval: 500
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            loopcount.text = getloopvalue();
            playeffect.loops = getloopvalue();
        }
    }

    //! Visual item to display the play button, loops increase
    //! and decrease buttons and the loop count display.
    Item {
        Image {
            id: effectimage
            height: 60
            width: 60
            anchors { top: parent.top; left: parent.left; topMargin: 175; leftMargin:200 }
            source: "image://theme/icon-m-toolbar-mediacontrol-play-white"

            //! Using QML sound effect component to play audio in loops
            SoundEffect {
                id: playeffect
                source: "media/busy.wav"
                loops: getloopvalue()
            }

            MouseArea {
                anchors.fill: effectimage

                onPressed: {
                    playeffect.play();
                }
            }
        }

        //! Row formation of controls and display to increase and decrease the loop count
        Row {
            id: loopcountarray
            anchors { left: parent.left; top: parent.top; topMargin: 600; leftMargin: 125 }
            spacing: 60

            Image {
                id: minus
                source: "image://theme/icon-m-toolbar-down-white"

                MouseArea {
                    anchors.fill: minus

                    onPressed: {
                        if (getloopvalue() > 1) {
                            loopcounter = (getloopvalue()) - 1;
                        }
                    }
                }
            }

            Text {
                id: loopcount
                text: getloopvalue()
                font.bold: true
                color: "darkgray"
                font.pixelSize: 40
            }

            Image {
                id: plus
                source: "image://theme/icon-m-toolbar-up-white"

                MouseArea {
                    anchors.fill: plus

                    onPressed: {
                        loopcounter = (getloopvalue()) + 1;
                    }
                }
            }
        }

        Text {
            id: looplabel
            text: "Number of Loops"
            color: "darkgray"
            font.pixelSize: 30

            anchors {
                bottom: loopcountarray.top
                bottomMargin: 20
                left: parent.left
                leftMargin: 125
            }
        }
    }
}

//! End of File
