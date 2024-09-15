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

#ifndef QMBATTERYREADER_H
#define QMBATTERYREADER_H

/*!
 * @brief INCLUDES
 */
#include <QObject>
#include <qmbattery.h>

using namespace MeeGo;

/*!
 * @brief CLASS DECLARATION
 */

/*!
 * @class QmBatteryReader qmbatteryreader.h systems/systeminfo/qmbatteryreader.h
 * @brief Class inherited from QObject allows to query
 * battery condition, amount of current flowing out from the battery and
 * remaining talk, active use and idle times.
 *
 * Declaration of properties makes it easy to access these information form QML environment.
 * For each class property there is a get function for reading the value. NOTIFY signal
 * is emitted whenever the value of the property changes.
 *
 * QmBattery class which is part of QmSystem2 library provides information on device battery
 * status.
 */
class QmBatteryReader : public QObject
{
    Q_OBJECT

    /*!
     * @brief Property
     *
     * Read-only class property of type QString representing device battery condition.
     */
    Q_PROPERTY(QString condition READ condition)

    /*!
     * @brief Property
     *
     * Class property of int type for battery remaining talk time in seconds.
     */
    Q_PROPERTY(int remainingTalkTime READ remainingTalkTime NOTIFY remainingTalkTimeChanged)

    /*!
     * @brief Property
     *
     * Class property of int type for battery remaining active use time in seconds.
     */
    Q_PROPERTY(int remainingActiveTime READ remainingActiveTime NOTIFY remainingActiveTimeChanged)

    /*!
     * @brief Property
     *
     * Class property of int type for battery remaining idle time in seconds.
     */
    Q_PROPERTY(int remainingIdleTime READ remainingIdleTime NOTIFY remainingIdleTimeChanged)

    /*!
     * @brief Property
     *
     * Class property of int type for amount of current flowing out from the battery.
     * Positive current means discharging and negative current means charging.
     * Current flow value unit is mA.
     */
    Q_PROPERTY(int currentFlow READ currentFlow NOTIFY currentFlowChanged)

public:
    /*!
     * @brief A member function
     *
     * Constructor method for the class QmBatteryReader.
     * In constructor we initiating start of periodic battery current measurement
     * at given time rate.
     * @param *parent A pointer to the parent object.
     */
    explicit QmBatteryReader(QObject *parent = 0);

    /*!
     * @brief A member function
     *
     * Destructor for the class QmBatteryReader.
     * Stop battery current measurement.
     */
    ~QmBatteryReader();

    /*!
     * @brief A member function
     *
     * A READ accessor function for condition property.
     * Used for reading the property value.
     * @return A string of current battery condition.
     */
    QString condition() const;

    /*!
     * @brief A member function
     *
     * A READ accessor function for remainingTalkTime property.
     * Used for reading the property value.
     * @return QString Battery remaining talk time in seconds.
     */
    int remainingTalkTime() const;

    /*!
     * @brief A member function
     *
     * A READ accessor function for remainingActiveTime property.
     * Used for reading the property value.
     * @return int Battery remaining active use time in seconds.
     */
    int remainingActiveTime() const;

    /*!
     * @brief A member function
     *
     * A READ accessor function for remainingIdleTime property.
     * Used for reading the property value.
     * @return int Battery remaining idle time in seconds.
     */
    int remainingIdleTime() const;

    /*!
     * @brief A member function
     *
     * A READ accessor function for currentFlow property. Used for reading the property value.
     * @return int Amount of current flowing out from the battery in mA.
     */
    int currentFlow() const;

signals:

    /*!
     * @brief Signal
     *
     * Signal emitted when remaining talk time value changes.
     * @return void
     */
    void remainingTalkTimeChanged();

    /*!
     * @brief Signal
     *
     * Signal emitted when remaining active use time value changes.
     * @return void
     */
    void remainingActiveTimeChanged();

    /*!
     * @brief Signal
     *
     * Signal emitted when remaining idle time value changes.
     * @return void
     */
    void remainingIdleTimeChanged();

    /*!
     * @brief Signal
     *
     * Signal emitted when amount of current flowing out from the battery changes.
     * @return void
     */
    void currentFlowChanged();

private:
    /*!
     * @brief Pointer object to the QmBattery.
     */
    QmBattery *m_battery;
};

#endif // QMBATTERYREADER_H
