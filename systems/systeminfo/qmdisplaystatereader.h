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

#ifndef QMDISPLAYSTATEREADER_H
#define QMDISPLAYSTATEREADER_H

/*!
 * @brief INCLUDES
 */
#include <QObject>
#include <qmdisplaystate.h>

using namespace MeeGo;

/*!
 * @brief CLASS DECLARATION
 */

/*!
 * @class QmDisplayStateReader qmdisplaystatereader.h systems/systeminfo/qmdisplaystatereader.h
 * @brief Class inherited from QObject allows to get current display state, display dim
 * timeout in seconds and current display blanking timeout in seconds.
 *
 * Declaration of class properties makes it easy to access these data form QML environment.
 *
 * QmDisplayState class which is part of QmSystem2 library provides information
 * and actions on device display state.
 */
class QmDisplayStateReader : public QObject
{
    Q_OBJECT

    /*!
     * @brief Property
     *
     * Property of QString type for current display state.
     */
    Q_PROPERTY(QString displayState READ displayState NOTIFY displayStateChanged)

    /*!
     * @brief Property
     *
     * Property of int type for current display dimming timeout value.
     */
    Q_PROPERTY(int dimTimeout READ dimTimeout)

    /*!
     * @brief Property
     *
     * Property of int type for current display blank timeout value.
     */
    Q_PROPERTY(int blankTimeout READ blankTimeout)

public:
    /*!
     * @brief A member function
     *
     * Constructor method for the class QmDisplayStateReader.
     * In constructor we create instance of QmDisplayState class to access its methods and also
     * start listening for displayStateChanged signal.
     * @param *parent A pointer to the parent object.
     */
    explicit QmDisplayStateReader(QObject *parent = 0);

    /*!
     * @brief A member function
     *
     * Destructor for the class QmDisplayStateReader.
     */
    ~QmDisplayStateReader();

    /*!
     * @brief A member function
     *
     * A READ accessor function for displayState property. Used for reading the property value.
     * @return QString A string of current display state, e.g. Off, Dimmed or On.
     */
    QString displayState() const;

    /*!
     * @brief A member function
     *
     * A READ accessor function for dimTimeout property. Used for reading the property value.
     * @return int Value of display dimming timeout in seconds.
     */
    int dimTimeout() const;

    /*!
     * @brief A member function
     *
     * A READ accessor function for blankTimeout property. Used for reading the property value.
     * @return int Value of display blanking timeout in seconds.
     */
    int blankTimeout() const;

signals:
    /*!
     * @brief Signal
     *
     * Signal emitted when display state has changed.
     * @return void
     */
    void displayStateChanged();

private:
    /*!
     * @brief Pointer object to the QmDisplayState.
     */
    QmDisplayState *m_displayState;
};

#endif // QMDISPLAYSTATEREADER_H
