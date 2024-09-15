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

#ifndef QMSYSTEMSTATEREADER_H
#define QMSYSTEMSTATEREADER_H

/*!
 * @brief INCLUDES
 */
#include <QObject>
#include <qmsystemstate.h>

using namespace MeeGo;

/*!
 * @brief CLASS DECLARATION
 */

/*!
 * @class QmSystemStateReader qmsystemstatereader.h systems/systeminfo/qmsystemstatereader.h
 * @brief Class inherited from QObject allows to get current run state, last boot reason and
 * accumulated value of the power on counter in minutes
 *
 * Declaration of class properties makes it easy to access these data form QML environment.
 *
 * QmSystemState class which is part of QmSystem2 library provides information
 * and actions on device state.
 */
class QmSystemStateReader : public QObject
{
    Q_OBJECT

    /*!
     * @brief Property
     *
     * Property of QString type for current boot reason.
     */
    Q_PROPERTY(QString bootReason READ bootReason)

    /*!
     * @brief Property
     *
     * Property of int type for total time the device has been powered on. Time unit is minutes.
     */
    Q_PROPERTY(int powerOnTime READ powerOnTime)

    /*!
     * @brief Property
     *
     * Property of QString type for current run state.
     */
    Q_PROPERTY(QString runState READ runState)

public:
    /*!
     * @brief A member function
     *
     * Constructor method for the class QmSystemStateReader.
     * In constructor we create instance of QmSystemState class to access its methods.
     * @param *parent A pointer to the parent object.
     */
    explicit QmSystemStateReader(QObject *parent = 0);

    /*!
     * @brief A member function
     *
     * Destructor for the class QmSystemStateReader.
     */
    ~QmSystemStateReader();

    /*!
     * @brief A member function
     *
     * A READ accessor function for bootReason property. Used for reading the property value.
     * @return QString A string of current boot reason.
     */
    QString bootReason() const;

    /*!
     * @brief A member function
     *
     * A READ accessor function for powerOnTime property. Used for reading the property value.
     * @return int Total time in minutes the device has been powered on.
     */
    int powerOnTime() const;

    /*!
     * @brief A member function
     *
     * A READ accessor function for runState property. Used for reading the property value.
     * @return QString A string of current run state.
     */
    QString runState() const;

private:
    /*!
     * @brief Pointer object to the QmSystemState.
     */
    QmSystemState *m_systemState;
};

#endif // QMSYSTEMSTATEREADER_H
