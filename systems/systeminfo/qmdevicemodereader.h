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

#ifndef QMDEVICEMODEREADER_H
#define QMDEVICEMODEREADER_H

/*!
 * @brief INCLUDES
 */
#include <QObject>
#include <qmdevicemode.h>

using namespace MeeGo;

/*!
 * @brief CLASS DECLARATION
 */

/*!
 * @class QmDeviceModeReader qmdevicemodereader.h systems/systeminfo/qmdevicemodereader.h
 * @brief Class inherited from QObject provides information on device operation mode and
 * powersave mode.
 *
 * Declaration of class properties makes it easy to access these data form QML environment.
 * Both defined properties have a get function for reading the value and NOTIFY signal, which
 * is emitted whenever the value of the property changes.
 *
 * QmDeviceMode class which is part of QmSystem2 library provides methods to get device
 * current operation mode and powersave mode.
 */
class QmDeviceModeReader : public QObject
{
    Q_OBJECT

    /*!
     * @brief Property
     *
     * Class property of QString type for current device operation mode.
     */
    Q_PROPERTY(QString deviceMode READ deviceMode NOTIFY deviceModeChanged)

    /*!
     * @brief Property
     *
     * Class property of QString type for current device powersave mode.
     */
    Q_PROPERTY(QString psmState READ psmState NOTIFY psmStateChanged)

public:
    /*!
     * @brief A member function
     *
     * Constructor method for the class QmDeviceModeReader.
     * In constructor we create instance of QmDeviceMode class to access its methods and also
     * start listening for the signals.
     * @param *parent A pointer to the parent object.
     */
    explicit QmDeviceModeReader(QObject *parent = 0);

    /*!
     * @brief A member function
     *
     * Destructor for the class QmDeviceModeReader.
     */
    ~QmDeviceModeReader();

    /*!
     * @brief A member function
     *
     * A READ accessor function for deviceMode property. Used for reading the property value.
     * @return QString A string of current device operation mode.
     */
    QString deviceMode() const;

    /*!
     * @brief A member function
     *
     * A READ accessor function for psmState property. Used for reading the property value.
     * @return QString A string of current powersave mode.
     */
    QString psmState() const;

signals:
    /*!
     * @brief Signal
     *
     * Signal emitted when device operation mode has changed.
     * @return void
     */
    void deviceModeChanged();

    /*!
     * @brief Signal
     *
     * Signal emitted when device powersave mode has changed.
     * @return void
     */
    void psmStateChanged();

private:
    /*!
     * @brief Pointer object to the QmDeviceMode.
     */
    QmDeviceMode *m_deviceMode;
};

#endif // QMDEVICEMODEREADER_H
