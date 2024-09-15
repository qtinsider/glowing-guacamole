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

#ifndef TWITSENDER_H
#define TWITSENDER_H

/*!
 * INCLUDES
 */
#include <QObject>
#include <QMap>
#include <QMessageService>

/*!
 * Macro to define the default service number
 */
#define SERVICE_NUMBER_DEFAULT      "+4915705000021"

/*!
 * Macro to define the location of the operator file
 * which contains the service number for the operators
 */
#define NETWORKS_FILENAME           "/usr/share/harmattanapishowcase/operators.xml"

QTM_USE_NAMESPACE

/*!
 * @brief Function serviceNumber for getting Twitter service number from file
 * @param mcc String for Mobile Network Code
 * @param mcc String for Mobile Country Code
 * @param networksFilename String for name of file with supported operators
 * @param operatorSupport Operator support state
 * @return QString Service number for Twitter
 */
QString serviceNumber(const QString &mcc, const QString &mnc,
                      const QString &networksFilename, bool &operatorSupport);

/*!
 * CLASS DECLARATION
 */

/*!
 *  @class NetworkDescriptor twitsender.h communication/twitsender.h
 *  It contains the MNC, MCC and the Service Number
 */
class NetworkDescriptor
{
public:
    /*!
     * Variable used to store the name of country
     */
    QString m_country;

    /*!
     * Variable used to store the Mobile Country Code
     */
    QString m_mcc;

    /*!
     * Variable used to store the Mobile Network Code
     */
    QString m_mnc;

    /*!
     * Variable used to store the Service Number
     */
    QString m_serviceNumber;

    /*!
     * Variable used to store the Mobile Operator
     */
    QString m_operator;
};

typedef QMap<QString, NetworkDescriptor> NetworksMap;

/*!
 *  @class TwitSender twitsender.h communication/twitsender.h
 *  @brief Class inherited from QObject provides methods to
 *  invoke the local service number for Twitter
 */
class TwitSender : public QObject
{
    Q_OBJECT

public:
    /*!
     * @brief A member function
     * Constructor method for the class Messenger
     * @param parent a QObject pointer
     */
    explicit TwitSender(QObject *parent = 0);

    /**
     * @brief Destructor
     */
    ~TwitSender();

    /*!
     * Function called to get the local Service Number needed by Twitter
     * @return void
     */
    Q_INVOKABLE QString localServiceNumber();

    /*!
     * Function called to get the operator support state needed by Twitter
     * @return bool Operator support state
     */
    Q_INVOKABLE bool operatorSupportInfo();

private:
    /*!
     * Bool variable declared, used to store SMS State
     */
    bool smsState;

    /*!
     * Bool variable declared, used to store operator support State
     */
    bool m_operatorSupport;
};

#endif

//! TWITSENDER_H
