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

#include <QFile>
#include <QTextStream>
#include <QDebug>
#include <QStringList>
#include <QtXml/QDomElement>
#include <QtXml/QDomDocument>


class MobileNetwork : QObject
{
public:
    QString m_country;
    QString m_mcc;
    QString m_mnc;
    QString m_serviceNumber;
    QString m_operator;
};

QDomElement NetworkToNode( QDomDocument &d, const MobileNetwork &mn )
{
   QDomElement nn = d.createElement("network");

   nn.setAttribute( "mcc", mn.m_mcc );
   nn.setAttribute( "mnc", mn.m_mnc );
   nn.setAttribute( "number", mn.m_serviceNumber );
   nn.setAttribute( "country", mn.m_country );
   nn.setAttribute( "operator", mn.m_operator );

   return nn;
}

int main(int argc, char *argv[])
{
    QString sourceFileName(argv[1]);
    QFile txtFile(sourceFileName);

    if (!txtFile.open(QIODevice::ReadOnly | QIODevice::Text))
        return -1;

    QFile xmlFile(argv[2]);

    if( !xmlFile.open( QIODevice::WriteOnly ) )
      return -1;

    QDomDocument doc( "Networks" );
    QDomElement root = doc.createElement( "networks" );
    doc.appendChild( root );

    QTextStream in(&txtFile);

    while (!in.atEnd()) {
        QString line = in.readLine();

        if (!line.size())
            continue;

        MobileNetwork mn;
        mn.m_country = line.section(':', 0, 0).trimmed();
        mn.m_mcc = line.section(':', 1, 1).trimmed();
        mn.m_mnc = line.section(':', 2, 2).trimmed();                        
        mn.m_serviceNumber = line.section(':', 3, 3).trimmed();
        mn.m_operator = line.section(':', 4, 4).trimmed();

        if (mn.m_mnc.contains(" ")) {
            QStringList listMNC = mn.m_mnc.split(" ", QString::SkipEmptyParts);
            foreach(QString l_mnc, listMNC) {
                mn.m_mnc = l_mnc;
                root.appendChild( NetworkToNode( doc, mn ) );
            }
        } else
            root.appendChild( NetworkToNode( doc, mn ) );

        //qDebug() << "Country" << country << "MCC" << mcc << "MNC" << mnc
        //         << "Short number" << number << "operator" << mobileOperator;
    }

    QTextStream os( &xmlFile );
    os << doc.toString();

    xmlFile.close();
    txtFile.close();

    //return a.exec();
}
