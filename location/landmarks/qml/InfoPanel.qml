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
 * @brief Information panel element for displaying
 * landmark name, description, Country and coordinate.
 */
Item {
    id: infoContainer

    property string landmarkName: ""
    property string landmarkLatitude: ""
    property string landmarkLongitude: ""
    property string landmarkDescription: ""
    property string landmarkCountry: ""

    property alias infoState: infoContainer.state

    width: parent.width
    height: 300
    anchors.top: parent.top
    state: "close"

    function clearInfo() {
        landmarkName = ""
        landmarkLatitude = ""
        landmarkLongitude = ""
        landmarkDescription = ""
        landmarkCountry = ""
        infoState = "close"
    }

    //! Background image for information panel
    Image {
        id: infoRect

        height: parent.height; width: parent.width
        source: "image://theme/meegotouch-applicationpage-background"
        anchors.top: parent.top
        opacity: 0.6
        clip: true

        Item {
            anchors { fill: parent; margins: uiConstants.DefaultMargin }

            //! Scroll decorator for the flickable area
            ScrollDecorator {
                flickableItem: infoFlick
            }

            Flickable {
                id: infoFlick
                width: parent.width; height: parent.height
                contentHeight: infoColumn.height
                clip: true

                Column {
                    id: infoColumn
                    spacing: 5
                    width: parent.width

                    Label {
                        text: landmarkName
                        font: uiConstants.HeaderFont
                        width: parent.width
                        wrapMode: Text.WordWrap
                    }
                    Label {
                        text: "<b>Latitude:</b> " + landmarkLatitude
                        width: parent.width
                        wrapMode: Text.WordWrap
                    }
                    Label {
                        text: "<b>Longitude:</b> " + landmarkLongitude
                        width: parent.width
                        wrapMode: Text.WordWrap
                    }
                    Label {
                        id: countryInfo
                        text: "<b>Country: </b> " + landmarkCountry
                        width: parent.width
                        wrapMode: Text.WordWrap
                    }
                    Label {
                        text: "<b>Description:</b> " + landmarkDescription
                        width: parent.width
                        wrapMode: Text.WordWrap
                    }
                    Label {
                        textFormat: Text.RichText
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: "<b>Website:</b> <a href=\"http://www.wikipedia.org\">http://www.wikipedia.org</a>"
                        onLinkActivated: Qt.openUrlExternally("http://www.wikipedia.org")
                    }
                }
            }
        }

        //! Image for shadow at the bottom of information panel
        Image {
            id: shadowSource
            source: "image://theme/meegotouch-menu-shadow-bottom"
            width: parent.width
            height: 10
            y: infoRect.height - 10
            anchors.top: infoRect.bottom
        }
    }

    //! Dropdown button image changing depending on state
    Image {
        id: dropDownButton

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: -12
        }

        source: "image://theme/meegotouch-editor-expand-button-background"
                + (expandButtonArea.pressed ? "-pressed" : "")

        Image {
            id: triangleImg
            source: "image://theme/icon-s-common-collapse"
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
            scale: 0.8
        }

        //! Mouse area for handling when we need to open and close the info panel
        MouseArea {
            id: expandButtonArea
            anchors.fill: parent

            //! When clicked, we need to change state
            onClicked: {
                if (infoContainer.state ==  "open")
                    infoContainer.state= "close"
                else
                    infoContainer.state = "open"

            }
        }
    }

    //! Drop down and up of rectangle implementation with states and transitions.
    states: [
        State {
            //! Defining "open" state
            name: "open"
            PropertyChanges {
                target: infoContainer
                height: 300
            }
            PropertyChanges {
                target: triangleImg
                source:"image://theme/icon-s-common-collapse"
            }
        },

        State {
            //! Defining "close" state
            name: "close"
            PropertyChanges {
                target: infoContainer
                height: 20
            }
            PropertyChanges {
                target: triangleImg
                source:"image://theme/icon-s-common-expand"
            }
        }
    ]

    //! Animating transitions between states
    transitions: Transition {
        PropertyAnimation {
            target: infoContainer
            properties: "height"; duration: 300
            easing.type: Easing.OutQuad
        }
    }
}
