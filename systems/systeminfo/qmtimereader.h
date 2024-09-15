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

#ifndef QMTIMEREADER_H
#define QMTIMEREADER_H

/*!
 * @brief INCLUDES
 */
#include <QObject>
#include <qmtime.h>

using namespace MeeGo;

/*!
 * @brief CLASS DECLARATION
 */

/*!
 * @class QmTimeReader qmtimereader.h systems/systeminfo/qmtimereader.h
 * @brief Class inherited from QObject provides methods to get system time information and
 * settings.
 *
 * Declaration of class properties makes it easy to access these data form QML environment.
 *
 * QmTime class which is part of QmSystem2 library is used to get interface for
 * interacting with system clock.
 */
class QmTimeReader : public QObject
{
    Q_OBJECT

    /*!
     * @brief Property
     *
     * Property of QString type for status of the automatic system time setting.
     */
    Q_PROPERTY(QString autoSystemTime READ autoSystemTime NOTIFY autoSystemTimeChanged)

    /*!
     * @brief Property
     *
     * Property of QString type for status of the automatic time zone guessing.
     */
    Q_PROPERTY(QString autoTimeZone READ autoTimeZone NOTIFY autoTimeZoneChanged)

    /*!
     * @brief Property
     *
     * Property of QString type for current time zone.
     */
    Q_PROPERTY(QString timezone READ timezone NOTIFY timezoneChanged)

    /*!
     * @brief Property
     *
     * Property of QString type for automatically guessed time zone.
     */
    Q_PROPERTY(QString timezoneAuto READ timezoneAuto NOTIFY timezoneAutoChanged)

    /*!
     * @brief Property
     *
     * Property of QString type stating if updates from cellular network operator are supported.
     */
    Q_PROPERTY(QString timeFromOperator READ timeFromOperator)

    /*!
     * @brief Property
     *
     * Property of QString type for default time zone defined during device manufacture.
     */
    Q_PROPERTY(QString defaultTimeZone READ defaultTimeZone)

    /*!
     * @brief Property
     *
     * Property of QString type for local time in current timezone.
     */
    Q_PROPERTY(QString localTime READ localTime NOTIFY localTimeChanged)

public:
    /*!
     * @brief A member function
     *
     * Constructor method for the class QmTimeReader.
     * In constructor we create instance of QmTime class to access its methods and also start
     * listening for the signal if time or settings were changed.
     * @param *parent A pointer to the parent object.
     */
    explicit QmTimeReader(QObject *parent = 0);

    /*!
     * @brief A member function
     *
     * Destructor for the class QmTimeReader.
     */
    ~QmTimeReader();

    /*!
     * @brief A member function
     *
     * A READ accessor function for autoSystemTime property. Used for reading the property value.
     * @return QString State of automatic system time setting.
     */
    QString autoSystemTime() const;

    /*!
     * @brief A member function
     *
     * A READ accessor function for autoTimeZone property. Used for reading the property value.
     * @return QString State of automatic time zone guessing.
     */
    QString autoTimeZone() const;

    /*!
     * @brief A member function
     *
     * A READ accessor function for timezone property. Used for reading the property value.
     * @return QString Current time zone.
     */
    QString timezone() const;

    /*!
     * @brief A member function
     *
     * A READ accessor function for timezoneAuto property. Used for reading the property value.
     * @return QString Automatically guessed time zone.
     */
    QString timezoneAuto() const;

    /*!
     * @brief A member function
     *
     * A READ accessor function for timezoneAuto property. Used for reading the property value.
     * @return QString "Supported" or "Not supported" or "N/A" for time updates from cellular
     * network operator.
     */
    QString timeFromOperator() const;

    /*!
     * @brief A member function
     *
     * A READ accessor function for defaultTimeZone property. Used for reading the property value.
     * @return QString Default time zone defined during device manufacture.
     */
    QString defaultTimeZone() const;

    /*!
     * @brief A member function
     *
     * A READ accessor function for localTime property. Used for reading the property value.
     * @return QString Local time in current timezone.
     */
    QString localTime() const;

private slots:
    /*!
     * @brief A member function
     *
     * Slot called when MeeGo::QmTime::timeOrSettingsChanged signal is emitted.
     * @param Holds what was changed as one of enumeration value of MeeGo::QmTime::WhatChanged
     * @return void
     */
    void settingsChanged(MeeGo::QmTime::WhatChanged);

signals:
    /*!
     * @brief Signal
     *
     * Signal emitted from settingsChanged slot when MeeGo::QmTime::timeOrSettingsChanged signal
     * received from QmTime instance.
     * @return void
     */
    void autoSystemTimeChanged();

    /*!
     * @brief Signal
     *
     * Signal emitted from settingsChanged slot.
     * @return void
     */
    void autoTimeZoneChanged();

    /*!
     * @brief Signal
     *
     * Signal emitted from settingsChanged slot.
     * @return void
     */
    void timezoneChanged();

    /*!
     * @brief Signal
     *
     * Signal emitted from settingsChanged slot.
     * @return void
     */
    void timezoneAutoChanged();

    /*!
     * @brief Signal
     *
     * Signal emitted every second when local time changes.
     * @return void
     */
    void localTimeChanged();

private:
    /*!
     * @brief Pointer object to the QmTime.
     */
    QmTime *m_time;
};

#endif // QMTIMEREADER_H
