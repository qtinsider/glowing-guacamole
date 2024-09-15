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

#ifndef QMCABCREADER_H
#define QMCABCREADER_H

/*!
 * @brief INCLUDES
 */
#include <QObject>
#include <qmcabc.h>

using namespace MeeGo;

/*!
 * @brief CLASS DECLARATION
 */

/*!
 * @class QmCABCReader qmcabcreader.h systems/systeminfo/qmcabcreader.h
 * @brief Class inherited from QObject provides method to indicate the
 * Content Adaptive Backlight Control (CABC) mode.
 *
 * Declaration of class property makes it easy to access this information form QML environment.
 *
 * QmCABC class which is part of QmSystem2 library provides methods to set and get
 * Content Adaptive Display Control settings.
 */
class QmCABCReader : public QObject
{
    Q_OBJECT

    /*!
     * @brief Property
     *
     * Read-only class property of type QString representing current CABC mode.
     */
    Q_PROPERTY(QString mode READ mode)

public:
    /*!
     * @brief A member function
     *
     * Constructor method for the class QmCABCReader.
     * @param *parent A pointer to the parent object.
     */
    explicit QmCABCReader(QObject *parent = 0);

    /*!
     * @brief A member function
     *
     * Destructor for the class QmCABCReader.
     */
    ~QmCABCReader();

    /*!
     * @brief A member function
     *
     * A READ accessor function for mode property. Used for reading the property value.
     * @return QString Content Adaptive Display Control mode in string format.
     */
    QString mode() const;

private:
    /*!
     * @brief Pointer object to the QmCABC.
     */
    QmCABC *m_cabc;
};

#endif // QMCABCREADER_H
