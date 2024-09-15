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

/*!
 * @brief Includes sample code for QtMobility Location and Map demo
 * Show map with current position and information panel displaying coordinate, last update time,
 * positionong method and street address.
 */
Page {
    id: locationPage

    //! Using common toolbar defined in main/qml/main.qml
    tools: commonTools

    //! We stop retrieving position information when component is to be destroyed
    Component.onDestruction: positionSource.stop()

    property string latitude: ""
    property string longitude: ""

    //! Check if application is active, stop position updates if not
    Connections {
        target: Qt.application

        onActiveChanged: {
            if (Qt.application.active && appSettings.accepted) {
                positionSource.start()
                informationPanel.spinnerRunning = true
            } else {
                positionSource.stop()
            }
        }
    }

    /*!
     * Function to return the string of the positioning method currently used
     *
     * Function returns string representation of current positioning method or "Source error"
     * if method of the position source undefined.
     */
    function positioningMethodType(method) {
        if (method === PositionSource.SatellitePositioningMethod)
            return "Satellite"
        else if (method === PositionSource.NoPositioningMethod)
            return "Not available"
        else if (method === PositionSource.NonSatellitePositioningMethod)
            return "Non-satellite"
        else if (method === PositionSource.AllPositioningMethods)
            return "All/multiple"
        return "Source error"
    }

    /*!
     * Function to update positioning information displayed in information panel
     *
     * Function used to set values of string properties for updating coordinates, timestamp
     * and positioning method.
     * It is called every time when a position update has been received from the location source.
     */
    function updateGeoInfo() {
        informationPanel.latitude = locationPage.latitude
        informationPanel.longitude = locationPage.longitude
        informationPanel.updateTime =
                Qt.formatDateTime(positionSource.position.timestamp, "yyyy-MM-dd hh:mm:ss")
        informationPanel.positioningMethod =
                positioningMethodType(positionSource.positioningMethod)
    }

    /*!
     * Function to street address information in information panel
     *
     * Function used to set values of string properties for updating street,
     * postal code and city name.
     * It is called every time reverse geocoding information received.
     */
    function updateStreetInfo(postal, street, city, country) {
        informationPanel.spinnerRunning = false
        informationPanel.postal = postal
        informationPanel.street = street
        informationPanel.city = city
        informationPanel.country = country
    }

    //! Container for map element
    Rectangle {
        id : mapview
        height: parent.height
        width: parent.width
        visible: appSettings.accepted

        //! Map element centered with current position
        Map {
            id: map
            plugin : Plugin {
                name : "nokia";

                //! Location requires usage of app_id and token parameters.
                //! Values below are for testing purposes only, please obtain real values.
                parameters: [
                    PluginParameter { name: "app_id"; value: "APPID" },
                    PluginParameter { name: "token"; value: "TOKEN" }
                ]
            }

            anchors.fill: parent
            size { width: parent.width; height: parent.height }
            center: positionSource.position.coordinate
            mapType: Map.StreetMap
            zoomLevel: maximumZoomLevel - 1

            //! Icon to display the tapped position
            MapImage {
                id: mapPlacer
                source: "icons/icon-m-gallery-location-selected.png"
                visible: false

                /*!
                 * We want that bottom middle edge of icon points to the location,
                 * so using offset parameter to change the on-screen position from coordinate.
                 * Values are calculated based on icon size, in our case icon is 48x48.
                 */
                offset.x: -24
                offset.y: -48
            }

            MapCircle {
                id: positionMarker
                center: positionSource.position.coordinate
                radius: 3
                color: "green"
                border { width: 10; color: "green" }
            }
        }

        //! Panning and pinch implementation on the maps
        PinchArea {
            id: pincharea

            //! Holds previous zoom level value
            property double __oldZoom

            anchors.fill: parent

            //! Calculate zoom level
            function calcZoomDelta(zoom, percent) {
                return zoom + Math.log(percent)/Math.log(2)
            }

            //! Save previous zoom level when pinch gesture started
            onPinchStarted: {
                __oldZoom = map.zoomLevel
            }

            //! Update map's zoom level when pinch is updating
            onPinchUpdated: {
                map.zoomLevel = calcZoomDelta(__oldZoom, pinch.scale)
            }

            //! Update map's zoom level when pinch is finished
            onPinchFinished: {
                map.zoomLevel = calcZoomDelta(__oldZoom, pinch.scale)
            }
        }

        //! Map's mouse area for implementation of panning in the map and zoom on double click
        MouseArea {
            id: mousearea

            //! Property used to indicate if panning the map
            property bool __isPanning: false

            //! Last pressed X and Y position
            property int __lastX: -1
            property int __lastY: -1

            anchors.fill: parent

            //! When pressed, indicate that panning has been started and update saved X and Y
            onPressed: {
                __isPanning = true
                __lastX = mouse.x
                __lastY = mouse.y
            }

            //! When released, indicate that panning has finished
            onReleased: {
                __isPanning = false
            }

            //! Move the map when panning
            onPositionChanged: {
                if (__isPanning) {
                    var dx = mouse.x - __lastX
                    var dy = mouse.y - __lastY
                    map.pan(-dx, -dy)
                    __lastX = mouse.x
                    __lastY = mouse.y
                }
            }

            //! When canceled, indicate that panning has finished
            onCanceled: {
                __isPanning = false;
            }

            //! Zoom one level when double clicked
            onDoubleClicked: {
                map.center = map.toCoordinate(Qt.point(__lastX,__lastY))
                if (map.zoomLevel < map.maximumZoomLevel ) map.zoomLevel += 1
            }

            onPressAndHold: {
                informationPanel.spinnerRunning = true
                mapPlacer.coordinate = map.toCoordinate(Qt.point(__lastX,__lastY))
                mapPlacer.visible = true
                locationPage.latitude = mapPlacer.coordinate.latitude
                locationPage.longitude = mapPlacer.coordinate.longitude
                reverseGeoCode.coordToAddress(mapPlacer.coordinate.latitude,
                                              mapPlacer.coordinate.longitude)
                updateGeoInfo()
            }
        }
    }

    //! Container for holding all location information
    InfoPanel {
        id: informationPanel
    }

    //! Used to access GConf values for the application
    AppSettings { id: appSettings }

    //! Source for retrieving the positioning information
    PositionSource {
        id: positionSource

        //! Desired interval between updates in milliseconds
        updateInterval: 10000
        active: appSettings.accepted

        //! When position changed, request getting of new street address and
        //! update geo info in information panel
        onPositionChanged: {
            if (!mapPlacer.visible) {
                locationPage.latitude = position.coordinate.latitude
                locationPage.longitude = position.coordinate.longitude
                reverseGeoCode.coordToAddress(position.coordinate.latitude,
                                              position.coordinate.longitude)
                updateGeoInfo()
            }
        }
    }

    /*!
     * Custom defined class to access reverse geocoding information
     * Check location/reversegeocode.h for details
     */
    GeoCoder {
        id:reverseGeoCode

        //! When reverse geocoding info received, update street address in information panel
        onReverseGeocodeInfoRetrieved: updateStreetInfo(postCode, streetadd, cityname, countryName)
    }
}

//! End of File
