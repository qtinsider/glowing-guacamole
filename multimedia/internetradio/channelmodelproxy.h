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

#ifndef CHANNELMODELPROXY_H
#define CHANNELMODELPROXY_H

#include <QObject>
#include "listmodel.h"
#include "channelitem.h"

class ChannelModelProxy : public QObject
{
    Q_OBJECT
public:
    explicit ChannelModelProxy(ListModel* model, QObject *parent = 0);
    Q_INVOKABLE void append(QString name, QString uri, bool favorite) {
        ChannelItem* newItem = new ChannelItem(name,uri,favorite,m_model);
        if (!m_model->indexFromItem(newItem).isValid()) {
            m_model->appendRow(newItem);
        } else {
            newItem->deleteLater();
        }
        m_model->sort(0);
    }

    Q_INVOKABLE void save();
    Q_INVOKABLE void load();
    Q_INVOKABLE void remove(int index);

signals:

public slots:

protected:
    ListModel* m_model;
    QFile m_channelfile;
};

#endif // CHANNELMODELPROXY_H
