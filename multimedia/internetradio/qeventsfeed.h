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

#ifndef QEVENTSFEED_H
#define QEVENTSFEED_H

#include <QtGui>
#include <meventfeed.h>

/*!
 * @class QEventsFeed
 * @brief QEventsFeed is a wrapper class around the libmeegotouchevents
 */
class QEventsFeed : public QObject {
    Q_OBJECT

public:
    /*!
     * Add new item to the event feed
     * @param titleText the title for the feed item
     * @param bodyText the body text for the feed item
     * @return unique id for the event feed item or -1 if values for the mandatory keys are not provided
     */
    Q_INVOKABLE qlonglong addItem(const QString &titleText, const QString &bodyText) {
        return addItem("/usr/share/icons/hicolor/80x80/apps/harmattanapishowcase80.png",titleText,bodyText);
    }

    /*!
     * Remove all items which has been added using the addItem(QString,QString) function.
     */
    Q_INVOKABLE void removeAll() {
        MEventFeed::instance()->removeItemsBySourceName(QApplication::applicationName());
    }

protected:
    /*!
     * Adds an item to the event feed.
     *
     * @param iconName the icon id for the feed item or absolute path to an image file. The icon must exist when addItem() is called. If the icon image is unique its path must be unique (same path should not be reused for different images).
     * @param titleText the title for the feed item
     * @param bodyText the body text for the feed item
     * @param imageList the image list for the feed item. If the images in list start with /, they're interpreted as absolute paths, otherwise as image IDs from the theme. The images must exist when addItem() is called. If an image is unique its path must be unique (same path should not be reused for different images).
     * @param timestamp timestamp for the feed item
     * @param footerText the footer text for the feed item. If there is no visible text to be shown in the footer the footer should be empty.
     * @param video if true, marks that the event item contains video content. The video content is limited to one thumbnail in the image list. The thumbnail will have a play button overlay rendered on top of it.
     * @param url the url to be executed when item is clicked. Executed action for URL is the default action provided by libcontentaction for the URL's scheme.
     * @param applicationId identifier for the event source e.g. application name, which should be persistent.
     * @param applicationIdName the source description in localized form which will be displayed in the UI in event feed item's object menu.
     * @return unique id for the event feed item or -1 if values for the mandatory keys are not provided
     */
    qlonglong addItem(const QString &iconName, const QString &titleText, const QString &bodyText, const QStringList &imageList=QStringList(), const QDateTime &timestamp=QDateTime::currentDateTime(), const QString &footerText=QString(), const bool &video=false, const QUrl &url=QUrl(), const QString &applicationId="EventsFeed-HarmattanAPIShowcase", const QString &applicationIdName=QApplication::applicationName()) {
        return MEventFeed::instance()->addItem(iconName,
                               titleText,
                               bodyText,
                               imageList,
                               timestamp,
                               footerText,
                               video,
                               url,
                               applicationId,
                               applicationIdName);
    }
};

#endif // QEVENTSFEED_H
