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
import com.nokia.harmattanapishowcase 1.0
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import QtMobility.sensors 1.2

Page {
    id: mainPage
    tools: accelTools

    //! Locking the page orientation in Landscape
    orientationLock: PageOrientation.LockLandscape

    // Information banner
    InfoBanner {
        id: infobanner
        z:100
    }

    ToolBarLayout {
        id: accelTools

        ToolIcon {
           iconId: "toolbar-back-landscape"

           onClicked: {
                pageStack.pop();
                theme.inverted = false
           }
        }

        Button {
            id: recordButton
            text: "Record"
            anchors.centerIn: parent
            width: 200

            onClicked: {
                if (text === "Record") {
                    // Start recording sensor readings
                    fileIO.record = true;

                    // Set button text
                    text = "Stop";
                } else {
                  // Stop recording
                  fileIO.record = false;

                  // Reset record button text
                  text = "Record"

                // Close file
                fileIO.filename = fileIO.closeFile();

                // Set banner text
                if (fileIO.filename != "")
                    infobanner.text = "Recording saved to file:\n" + fileIO.filename;
                else
                    infobanner.text = "File save error.";

                // Show banner
                infobanner.show()

                // Reset time
                elapsedTimer.seconds = 0;
                elapsedTimer.minutes = 0;
                elapsedTimer.hours = 0;
                recordTime.text = "00:00";
            }
          }
       }

       ToolIcon {
            id: recordIcon
            iconId:  "icon-m-camera-ongoing-recording"
            enabled: false;
            visible: (recordTime.visible) ? true: false
            anchors.right: recordTime.left
        }

        Label {
          id: recordTime
          text: "00:00"
          width: 150
          font.family: "Nokia Pure Text Light"
          font.pixelSize: 30
          color: "Red"
          visible: (fileIO.record) ? true: false
          anchors.right: helpIcon.left
          }

          ToolIcon {
           id: helpIcon
               iconSource:"../../../../main/qml/icons/help_icon.png"
               onClicked: rootWindow.openFile("../../main/qml/AboutDialog.qml")
           anchors.right: accelTools.right
          }
    }

    // Timer for elapsed recording duration
    Timer {
        id: elapsedTimer
        interval: 1000
        running: (fileIO.record) ? true: false
        repeat: (fileIO.record) ? true: false

        // Properties to hold elapsed time.
        property int seconds: 0
        property int minutes: 0
        property int hours: 0

        onTriggered: {
          // Increment recording duration
          if (++seconds > 59 ) {
            seconds = 0;

            if (++minutes > 59) {
              minutes = 0;

              if (++hours > 59) {
                  hours = 0

                  // Stop recording
                  fileIO.record = false;

                  // Reset record button text
                  recordButton.text = "Record"

                  // Close file
                  fileIO.filename = fileIO.closeFile();

                  if (fileIO.filename === "") {
                    infobanner.text = "Maximum time limit reached.\nError saving file.\n";
                  } else {
                    infobanner.text = "Maximum time limit reached.\nRecording saved to file:\n" + fileIO.filename;
                  }

                  // Show banner
                  infobanner.show()
               }
           }
        }

        // Update recording time
        recordTime.text = ((hours < 1)  ? "" : ((hours < 10) ? ("0" + hours) : hours) + ":")  +
                        ((minutes < 10)  ? ("0" + minutes) : minutes) + ":" +
                        ((seconds < 10)  ? ("0" + seconds) : seconds)
        }
    }

    FileIO {
        id: fileIO
        property bool record: false;
    property string filename: "";
    }

    // Background image
    Image {
          id: pixmap
          source: "background.png"
    }

    // Area to display accelerometer readings
    Label {
        id: label
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        visible: true
        text: qsTr("    Accelerometer Reading X: 0 Y:0 Z:0")
    }

    // Rolling ball image
    Image {
        id: ball
        height: 100
        width: 100
        smooth : true
        source: "ball.png"

        // Property to hold state
        property bool walled: false
    }

    // Stop sensor when the applicaion is closed
    Component.onDestruction: { RotationSensor.active = false; TapSensor.active = false;}

    /*!
     * Instance of TapSensor
     * The TapSensor element reports tap readings on device screen
     */
    TapSensor {
        id: tapSensor
        active: true

        onReadingChanged: {
            if (ball.walled === true) {
                // Set walled to false
                ball.walled = false;

                // Move ball a bit from corner to release
                ball.x === 0 ? ball.x += 4 : ball.x -= 4;
                ball.y === 0 ? ball.y += 4 : ball.y -= 4;

                // Activate rotation sensor
                rotationSensor.active = true;
            }
        }
    }

    /*!
     * Instance of RotationSensor
     * The RotationSensor element reports device rotation.
     */
    RotationSensor {
        id: rotationSensor
        active: true

        onReadingChanged: {
            // Show current accelerometer readings on screen
            label.text = "Accelerometer Reading X: " + reading.x + " Y: " + reading.y + " Z: " + reading.z

            // Move ball on screen on X changes
            if (reading.x > 4 &&  ball.walled != true) {
                if ((ball.x + reading.x) < 750)
                    ball.x += reading.x;
                else
                    ball.x = 750;
            }
            else if (reading.x < -4) {
                if ((ball.x + reading.x) > 0)
                    ball.x += reading.x;
                else
                    ball.x = 0;
            }

            // Move ball on screen on Y changes
            if (reading.y > 4 && ball.walled != true) {
                if ((ball.y - reading.y) > 0)
                    ball.y -= reading.y
                else
                    ball.y = 0;
            }
            else if (reading.y < -4) {
                if ((ball.y - reading.y) < 290)
                    ball.y -= reading.y;
                else
                    ball.y = 290;
            }

            // If ball touches screen corners, make it to stick there
            if (ball.x === 750 || ball.x === 0 || ball.y === 290 || ball.y === 0) {
                // Set walled property to true
                ball.walled = true

                // Stop rotation sensor until double tapped
                active = false

                // Display message to user
                label.text = "Please double tap on screen to release ball"
            }

            // Write to file if recording in progress
            if (fileIO.record === true && !fileIO.writeLine(label.text)) {
                // Show recording error message
                infobanner.text = "Recording error.";
                infobanner.show();

                // Close file
                fileIO.closeFile();

                // Reset record
                fileIO.record = false;

                // Reset record button text
                recordButton.text = "Record";

                // Reset time
                elapsedTimer.seconds = 0;
                elapsedTimer.minutes = 0;
                elapsedTimer.hours = 0;
                recordTime.text = "00:00";
            }
        }
    }

    // Animation states for moving the ball on screen
    states: [
         State {
             name: "on"
             PropertyChanges { target: ball; on: x}
             PropertyChanges { target: ball; on: y}
         }
    ]

    transitions: Transition {
    PropertyAnimation { target: ball; properties: "x,y"; easing.type: Easing.Linear; easing.period:10; duration: 1000* (x>y)? x : y  }
    }
}
