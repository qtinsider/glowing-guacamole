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

/*!
 * INCLUDES
 */
#include "twitsender.h"
#include <QDebug>
#include <QSystemNetworkInfo>
#include <QFile>
#include <QtXml/QDomElement>
#include <QtXml/QDomDocument>

QTM_USE_NAMESPACE

/*!
 * Member function to get displayable netword id
 */
QString networkId(const QString &mcc, const QString &mnc)
{
    return mcc + ":" + mnc;
}

/*!
 * Function supported networks verifies the mobile network supported by Twitter
 */
NetworksMap supportedNetworks(const QString &networksFilename)
{
    NetworksMap ret;
    QFile xmlFile(networksFilename);

    //! Open text file in read only mode.
    if ( xmlFile.open(QIODevice::ReadOnly | QIODevice::Text )) {
        //! Set xml document name.
        QDomDocument doc( "Networks" );

        //! Set xml document content.
        if (doc.setContent(&xmlFile)) {
            QDomElement root = doc.documentElement();

            //! Set xml root element tag name.
            if (root.tagName() == "networks") {
                //! Get first child node.
                QDomNode node = root.firstChild();

                //! Check for validity of node.
                while( !node.isNull() )
                {
                  //! Convert node to element.
                  QDomElement element = node.toElement();

                  //! Check for validity of the element and tag name.
                  if (!element.isNull()) {
                    if (element.tagName() == "network") {
                      NetworkDescriptor nd;

                      //! Get attributes.
                      nd.m_mcc = element.attribute( "mcc", "" );
                      nd.m_mnc = element.attribute( "mnc", "" );
                      nd.m_country = element.attribute( "country", "" );
                      nd.m_serviceNumber = element.attribute( "number", "" );
                      nd.m_operator = element.attribute( "operator", "" );

                      //! Insert needed attributes.
                      ret.insert(networkId(nd.m_mcc, nd.m_mnc), nd);
                    }
                  }

                  //! Go to next child node.
                  node = node.nextSibling();
                }
            }
        }

        //! Close file.
        xmlFile.close();
    }

    return ret;
}

/*!
 * Function serviceNumber verifies the MNC, MCC code and returns corresponding service number
 */
QString serviceNumber(const QString &mcc, const QString &mnc,
                      const QString &networksFilename, bool &operatorSupport)
{
    QString ret(SERVICE_NUMBER_DEFAULT);    

    //! Initially setting operatorSupport to false
    operatorSupport = false;

    //! Verifies if the network is supported by Twitter
    if (mcc.size() && mnc.size()) {
        NetworksMap networksMap = supportedNetworks(networksFilename);

        //! Check for network map existence.
        if (networksMap.size()) {
            NetworkDescriptor net = networksMap.value(networkId(mcc, mnc));

            //! Validate required values.
            if (mcc == net.m_mcc && mnc == net.m_mnc)
                ret = net.m_serviceNumber;
            else {
                //! Set default value if mnc is not present.
                net = networksMap.value(networkId(mcc, "XXX"));
                if (mcc == net.m_mcc && "XXX" == net.m_mnc)
                    ret = net.m_serviceNumber;
            }

            //! Checking for the mcc/mnc codes
            if (net.m_mcc == "" || net.m_mnc == "")
                operatorSupport = false;
            else
                operatorSupport = true;
        }
    }

    return ret;
}

/*!
 * Constructor method for the class Messenger
 */
TwitSender::TwitSender(QObject *parent) :
    QObject(parent)
{

}

/*!
 * Destructor
 */
TwitSender::~TwitSender()
{

}

/*!
 * A member function serviceNumber
 * It verifies the MNC, MCC code
 * Returns QString
 */
QString TwitSender::localServiceNumber()
{
    //! Object of QSystemNetworkInfo
    QSystemNetworkInfo nInfo;

    //! Assign the current Mobile CountryCode
    QString mcc = nInfo.currentMobileCountryCode();

    //! Assign the current Mobile NetworkCode
    QString mnc = nInfo.currentMobileNetworkCode();
    QString ret = serviceNumber(mcc, mnc, NETWORKS_FILENAME, m_operatorSupport);

    return ret;
}

/*!
 * A member function operatorSupportInfo
 */
bool TwitSender::operatorSupportInfo()
{
    return m_operatorSupport;
}

//!  End of File
