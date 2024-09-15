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
import com.nokia.harmattanapishowcase 1.0
import QtMobility.systeminfo 1.2

/*!
 * Main PageStackWindow element for the application
 */
PageStackWindow {
    id: rootWindow

    //! Holds the Sound Indicator ON/OFF value for Orientation Example
    property bool soundControl: false

    //! Propert holding secondary text color for application
    property string secondaryForeground: theme.inverted ? "#C8C8C8" : "#505050"

    property variant uiConstants : ""

    //! New component and pushing created page to the stack
    function openFile(file) {
        var component = Qt.createComponent(file)

        if (component.status === Component.Ready) {
            pageStack.push(component);

            //! Activating Black theme for all pages accept SMS, Tweet,
            //! NFC and Location
            if (file !== "../../communications/qml/SMSSender.qml"
                    && file !== "../../communications/qml/AddressBookforNFC.qml"
                    && file !== "../../communications/qml/EmailSender.qml"
                    && file !== "../../communications/qml/TwitSender.qml"
                    && file !== "../../location/geocoding/qml/Location.qml"
					&& file !== "../../location/landmarks/qml/SevenWonders.qml"
					&& file !== "SendingVCardPage.qml")
                        theme.inverted = true;
        } else {
            console.log("Error loading component:", component.errorString());
        }
    }

    function extendJavaScript() {
        String.prototype.startsWith = function(str) { var matched = this.match("^"+str+".*"); if (matched===null) { return false; }; return (matched.toString().localeCompare(this)===0); }
    }

    function initializeFont(fontname,fontsize,fontbold) {
        var fontLoader = Qt.createQmlObject("import QtQuick 1.0; Text { font.family: \""+ fontname +"\"; font.pixelSize: "+fontsize+"; font.bold: "+fontbold+" }",rootWindow,"fontLoader");
        var loadedFont = fontLoader.font; fontLoader.destroy();
        return loadedFont;
    }

    Component.onCompleted: {
        extendJavaScript();

        if (!generalInfo.firmwareVersion.startsWith("DFL61\_HARMATTAN\_1")) {
            //! Starting from PR1.1 UiConstants available from Qt Components
            uiConstants = UiConstants;
        } else {
            uiConstants = {
                "DefaultMargin" : 16,
                "ButtonSpacing" : 6,
                "HeaderDefaultHeightPortrait" : 72,
                "HeaderDefaultHeightLandscape" : 46,
                "HeaderDefaultTopSpacingPortrait" : 20,
                "HeaderDefaultBottomSpacingPortrait" : 20,
                "HeaderDefaultTopSpacingLandscape" : 16,
                "HeaderDefaultBottomSpacingLandscape" : 14,
                "ListItemHeightSmall" : 64,
                "ListItemHeightDefault" : 80,
                "IndentDefault" : 16,
                "GroupHeaderHeight" : 40,
                "BodyTextFont" : initializeFont("Nokia Pure Text Light", 24, false),
                "GroupHeaderFont" : initializeFont("Nokia Pure Text", 18, true),
                "HeaderFont": initializeFont("Nokia Pure Text Light", 32, false),
                "TitleFont" : initializeFont("Nokia Pure Text", 26, true),
                "SmallTitleFont" : initializeFont("Nokia Pure Text", 24, true),
                "FieldLabelFont" : initializeFont("Nokia Pure Text Light", 22, false),
                "FieldLabelColor" : "#505050",
                "SubtitleFont" : initializeFont("Nokia Pure Text Light", 22, false),
                "InfoFont" : initializeFont("Nokia Pure Text Light", 18, false)
            };
        }

        var comp = Qt.createComponent("MainWindow.qml");
        if (comp.status === Component.Ready) {
            var page = comp.createObject(pageStack);
            pageStack.pop();
            pageStack.push(page);
        }
    }

    GeneralInfo { id: generalInfo }

    //! These tools are shared by most sub-pages by assigning the id to a page's tools property
    ToolBarLayout {
        id: commonTools

        ToolIcon {
            iconId: (screen.currentOrientation === Screen.Landscape)
                    ? "toolbar-back-landscape"  + (theme.inverted ? "" : "-white") : "toolbar-back"
            visible: (pageStack.depth !== 1)

            onClicked: {
                pageStack.pop();

                //! Changing back the Theme to White when returning to the Main Page
                if (pageStack.depth === 1) theme.inverted = false;
            }
        }

        ToolIcon {
            anchors.right: parent.right
            iconSource:"icons/help_icon.png"

            onClicked: openFile("../../main/qml/AboutDialog.qml")
        }
    }

    AppInfo {
        id: appInfo
    }
}

//! End of file
