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
 * @brief Swipe navigation for all system info pages
 */

Page {
    id: viewPage

    //! Property holding height of swiping page
    property int pageHeight: (viewPage.height - pageIndicator.height)

    //! Using common toolbar defined in main/qml/main.qml
    tools: commonTools

    //! Model containing system information pages
    VisualItemModel {
        id: itemModel

        //! Page displaying Battery information
        Item {
            width: viewPage.width; height: pageHeight

            BatteryInfoPage { }
        }

        //! Page displaying Device information
        Item {
            width: viewPage.width; height: pageHeight

            DeviceInfoPage { }
        }

        //! Page displaying Dispaly information
        Item {
            width: viewPage.width; height: pageHeight

            DisplayInfoPage { }
        }

        //! Page displaying General information
        Item {
            width: viewPage.width; height: pageHeight

            GeneralInfoPage { }
        }

        //! Page displaying Network information
        Item {
            width: viewPage.width; height: pageHeight

            NetworkInfoPage { }
        }

        //! Page displaying Storage information
        Item {
            width: viewPage.width; height: pageHeight

            StorageInfoPage { }
        }

        //! Page displaying System states
        Item {
            width: viewPage.width; height: pageHeight

            SystemStatesPage { }
        }


        //! Page displaying System time settings
        Item {
            width: viewPage.width; height: pageHeight

            TimePage { }
        }
    }

    /*!
     * Displaying all available system information pages, they can be swiped to navigate
     * from one page to another.
     * Such functionality implemented with PathView element.
     */
    PathView {
        id: view
        anchors {
            top: parent.top
            bottom: pageIndicator.top
            left: parent.left
            right: parent.right
        }
        model: itemModel
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        highlightRangeMode: PathView.StrictlyEnforceRange
        clip: true

        //! Jump to the page that was clicked
        currentIndex: systemInfoList.pageNumber

        //! Put high number for flickDeceleration to make sure, that swiping only one page at time
        flickDeceleration: 500000

        path: Path {
            startX: - viewPage.width * itemModel.count / 2 + viewPage.width / 2
            startY: pageHeight / 2
            PathLine {
                x: viewPage.width * itemModel.count / 2 + viewPage.width / 2
                y: pageHeight / 2
            }
        }
    }

    //! Page indicator shows total number of pages and highlight icon for selected page
    Item {
        id: pageIndicator

        width: parent.width
        height: 40
        anchors.bottom: parent.bottom

        //! Page indicator icons placed horizontally in a row
        Row {
            anchors.centerIn: parent
            spacing: 5

            Repeater {
                model: itemModel.count
                delegate: Image {
                    source: view.currentIndex === index ? "image://theme/icon-s-current-page"
                                                       : "image://theme/icon-s-unselected-page"
                }
            }
        }
    }
}
//! End of File
