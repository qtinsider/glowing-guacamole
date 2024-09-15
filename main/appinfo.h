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

#ifndef APPINFO_H
#define APPINFO_H

/*!
 * INCLUDES
 */

#include <QObject>
#include <QApplication>

/*!
 * CLASS DECLARATION
 */

/*!
 *  @class AppInfo appinfo.h main/appinfo.h
 *  @brief Class inherited from QObject provides methods to
 *  ApplicationName, ApplicationVersion and OrganizationName
 */

class AppInfo : public QObject {
    Q_OBJECT

public slots:
    /*!
     * @brief Slot
     *
     * Function to return the name of the application
     * @return QString Application name
     */
    Q_INVOKABLE QString getApplicationName() { return QApplication::applicationName(); }

    /*!
     * @brief Slot
     *
     * Function to return the version number of the application
     * @return QString Version of the application
     */
    Q_INVOKABLE QString getApplicationVersion() { return QApplication::applicationVersion(); }

    /*!
     * @brief Slot
     *
     * Function to return the name of the Organization
     * @return QString Name of the organization
     */
    Q_INVOKABLE QString getOrganizationName() { return QApplication::organizationName(); }
};

#endif

//! APPINFO_H
