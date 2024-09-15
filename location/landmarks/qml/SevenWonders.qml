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
import QtMobility.location 1.2
import com.nokia.harmattanapishowcase 1.0

Page {
    id: landmarksPage

    tools: locationTools

    property bool pinching: false

    //! Indicates number of landmarks displayed on map
    property int totalLandmarks: 7

    //! Selected landmark's name
    property string selectedLandmark: ""

    //! Property indicating if busy indicator running and visible
    property bool spinnerRunning: true

    //! True if ancient landmarks are displayed
    property bool isAncientDisplayed: false

    //! Initiate loading landmarks
    Component.onCompleted: helper.initSevenWonders()

    //! Function sets landmark information to be displayed, opens information panel, center map to
    //! selected landmark and zooms map to level 16.
    function displayInfo()
    {
        var index = 0;

        for (index = 0; index < sevenWonders.landmarks.length; index++)  {
            if (selectedLandmark === sevenWonders.landmarks[index].name) {
                informationPanel.landmarkName = sevenWonders.landmarks[index].name
                informationPanel.landmarkLatitude = sevenWonders.landmarks[index].coordinate.latitude
                informationPanel.landmarkLongitude = sevenWonders.landmarks[index].coordinate.longitude
                informationPanel.landmarkDescription = sevenWonders.landmarks[index].description
                informationPanel.landmarkCountry = sevenWonders.landmarks[index].address.country
                informationPanel.infoState = "open"
                map.center.latitude = sevenWonders.landmarks[index].coordinate.latitude
                map.center.longitude = sevenWonders.landmarks[index].coordinate.longitude
                break;
            }
        }
        map.zoomLevel = 16
    }

    //! Custom toolbar has menu for selecting ancient or new seven wonders, search icon to browse
    //! between landmarks, about application, back button and spinner.
    ToolBarLayout {
        id: locationTools

        ToolIcon {
            platformIconId: (screen.currentOrientation === Screen.Landscape)
                            ? "toolbar-back-landscape"  + (theme.inverted ? "" : "-white") : "toolbar-back"
            onClicked: {
                helper.cancelActiveRequests()
                pageStack.pop()
            }
        }

        ToolIcon {
            id: searchIcon
            platformIconId: "toolbar-search"
            visible: spinnerRunning ? false : true
            onClicked: landmarkSelectionDialog.open()
        }

        //! Busy indicator running while loading landmarks
        BusyIndicator {
            id: spinner

            platformStyle: BusyIndicatorStyle { size: "medium" }
            x: searchIcon.x; y: searchIcon.y
            visible: spinnerRunning ? true : false
            running: spinnerRunning
        }

        ToolIcon {
            iconSource: "icons/help_icon.png";
            onClicked: rootWindow.openFile("../../main/qml/AboutDialog.qml")
        }

        ToolIcon {
            platformIconId: "toolbar-view-menu"
            onClicked: menuDialog.open()
        }
    }

    //! Dialog for selecting New or Ancient seven wonders
    SelectionDialog {
        id: menuDialog
        titleText: "Select the wonders"
        model: ListModel {
            ListElement { name: "New Seven Wonders of the World" }
            ListElement { name: "Seven Wonders of the Ancient World" }
        }

        onSelectedIndexChanged: {
            landmarkSelectionDialog.selectedIndex = -1
            if (selectedIndex == 0 && isAncientDisplayed) {
                sevenWonders.filter = newLandmarksFilter
                spinnerRunning = true
                informationPanel.clearInfo()
                selectedLandmark = ""
                isAncientDisplayed = false

                //! Map is centered to Colosseum location
                map.center.latitude = 41.8901690
                map.center.longitude = 12.4922690
            } else if (selectedIndex == 1 && !isAncientDisplayed) {
                sevenWonders.filter = ancientLandmarksFilter
                spinnerRunning = true
                informationPanel.clearInfo()
                selectedLandmark = ""
                isAncientDisplayed = true

                //! Map is centered to Colossus of Rhodes location
                map.center.latitude = 36.433333
                map.center.longitude = 28.216667
            }
            map.zoomLevel = 3
        }
    }

    //! Dialog with list of displayed landmarks for fast browsing
    SelectionDialog {
        id: landmarkSelectionDialog
        titleText: "Find the location"

        model: isAncientDisplayed ? ancientList : landmarksList

        onSelectedIndexChanged: {
            if (selectedIndex > -1) {
                selectedLandmark = landmarkSelectionDialog.model.get(landmarkSelectionDialog.selectedIndex).name
                displayInfo()
            }
        }
    }

    //! New seven wonders landmarks
    ListModel {
        id: landmarksList

        ListElement { name: "Chichen Itza" }
        ListElement { name: "Christ the Redeemer" }
        ListElement { name: "Colosseum" }
        ListElement { name: "Great Wall of China" }
        ListElement { name: "Machu Picchu" }
        ListElement { name: "Taj Mahal" }
        ListElement { name: "Petra" }
    }

    //! Ancient seven wonders landmarks
    ListModel {
        id: ancientList

        ListElement { name: "Great Pyramid of Giza" }
        ListElement { name: "Hanging Gardens of Babylon" }
        ListElement { name: "Statue of Zeus at Olympia" }
        ListElement { name: "Temple of Artemis at Ephesus" }
        ListElement { name: "Mausoleum of Maussollos at Halicarnassus" }
        ListElement { name: "Colossus of Rhodes" }
        ListElement { name: "Lighthouse of Alexandria" }
    }

    LandmarksHelper { id: helper }

    //! Container for holding all location information
    InfoPanel {
        id: informationPanel
        z: map.z + 1
    }

    Item {
        id: mapview
        height: parent.height
        width: parent.width

        Map {
            id: map
            z: mapview.z + 1
            size { width: parent.width; height: parent.height }
            center: Coordinate { latitude: 41.8901690; longitude: 12.4922690 }
            mapType: Map.SatelliteMapDay
            zoomLevel: 3

            plugin: Plugin {
                name: "nokia";

                //! Location requires usage of app_id and token parameters.
                //! Values bellow is for testing purpose only, please obtain real values.
                parameters: [
                    PluginParameter { name: "app_id"; value: "APPID" },
                    PluginParameter { name: "token"; value: "TOKEN" }
                ]
            }

            LandmarkUnionFilter {
                id: newLandmarksFilter

                LandmarkNameFilter { name: "Chichen Itza" }
                LandmarkNameFilter { name: "Christ the Redeemer" }
                LandmarkNameFilter { name: "Colosseum" }
                LandmarkNameFilter { name: "Great Wall of China" }
                LandmarkNameFilter { name: "Machu Picchu" }
                LandmarkNameFilter { name: "Taj Mahal" }
                LandmarkNameFilter { name: "Petra" }
            }

            LandmarkUnionFilter {
                id: ancientLandmarksFilter

                LandmarkNameFilter { name: "Great Pyramid of Giza" }
                LandmarkNameFilter { name: "Hanging Gardens of Babylon" }
                LandmarkNameFilter { name: "Statue of Zeus at Olympia" }
                LandmarkNameFilter { name: "Temple of Artemis at Ephesus" }
                LandmarkNameFilter { name: "Mausoleum of Maussollos at Halicarnassus" }
                LandmarkNameFilter { name: "Colossus of Rhodes" }
                LandmarkNameFilter { name: "Lighthouse of Alexandria" }
            }

            LandmarkModel {
                id: sevenWonders
                sortBy: LandmarkModel.NoSort
                autoUpdate: true

                filter: newLandmarksFilter

                onModelChanged: {
                    if (sevenWonders.count == totalLandmarks)
                        spinnerRunning = false
                }
            }

            MapObjectView {
                id: landmarksWonders
                model: sevenWonders
                visible: (sevenWonders.count === totalLandmarks && !spinnerRunning) ? true : false

                delegate: MapImage {
                    id: landmarkImage
                    source: selectedLandmark === landmark.name
                            ? "icons/icon-m-common-location-selected.png"
                            : "icons/icon-m-common-location.png"
                    coordinate: landmark.coordinate
                    offset.x: -24
                    offset.y: -48

                    MapMouseArea {
                        anchors.fill: parent

                        onClicked: {
                            selectedLandmark = landmark.name
                            informationPanel.landmarkName = landmark.name
                            informationPanel.landmarkLatitude = landmark.coordinate.latitude
                            informationPanel.landmarkLongitude = landmark.coordinate.longitude
                            informationPanel.landmarkDescription = landmark.description
                            informationPanel.landmarkCountry = landmark.address.country
                            informationPanel.infoState = "open"
                            map.center.latitude = landmark.coordinate.latitude
                            map.center.longitude = landmark.coordinate.longitude
                            map.zoomLevel = 16
                        }

                    }
                }
            }
        } // map

        //! Panning and pinch implementation on the maps
        PinchArea {
            id: pincharea

            //! Holds previous zoom level value
            property double __oldZoom

            anchors.fill: parent

            //! Calculate zoom lavel
            function calcZoomDelta(zoom, percent) {
                return zoom + Math.log(percent)/Math.log(2)
            }

            //! Save previous zoom level when pinch gesture started
            onPinchStarted: {
                pinching = true
                __oldZoom = map.zoomLevel
            }

            //! Update map's zoom level when pinch is updating
            onPinchUpdated: {
                pinching = true
                map.zoomLevel = calcZoomDelta(__oldZoom, pinch.scale)
            }

            //! Update map's zoom level when pinch is finished
            onPinchFinished: {
                pinching = false
                map.zoomLevel = calcZoomDelta(__oldZoom, pinch.scale)
            }
        }

        //! Map's mouse area for implementation of pin in the map and zoom on double click
        MouseArea {
            id: mousearea

            //! Property used to indicate if pinning the map
            property bool __isPanning: false

            //! Last pressed X and Y position
            property int __lastX: -1
            property int __lastY: -1

            anchors.fill: parent

            //! When pressed, indicate that pinning has been started and update saved X and Y
            onPressed: {
                __isPanning = true
                __lastX = mouse.x
                __lastY = mouse.y
            }

            //! When released, indicate that pinning has finished
            onReleased: {
                __isPanning = false
            }

            //! Move the map when pinning
            onPositionChanged: {
                if (__isPanning) {
                    var dx = mouse.x - __lastX
                    var dy = mouse.y - __lastY
                    map.pan(-dx, -dy)
                    __lastX = mouse.x
                    __lastY = mouse.y
                }
            }

            //! When canceled, indicate that pinning has finished
            onCanceled: {
                __isPanning = false;
            }

            //! Zoom one level when double clicked
            onDoubleClicked: {
                map.center = map.toCoordinate(Qt.point(__lastX,__lastY))
                map.zoomLevel += 1
            }
        }
    }
}
