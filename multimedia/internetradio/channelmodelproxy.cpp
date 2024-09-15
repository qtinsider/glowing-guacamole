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

#include "channelmodelproxy.h"

ChannelModelProxy::ChannelModelProxy(ListModel* model,QObject *parent) :
    QObject(parent), m_model(model), m_channelfile("/home/user/MyDocs/harmattanshowcase.channellist")
{
    load();
}

void ChannelModelProxy::save() {
    if (m_channelfile.open(QIODevice::WriteOnly)) {
        int numRows = m_model->rowCount();
        for (int row = 0; row < numRows; ++row) {
            QModelIndex index = m_model->index(row, 0);
            QString name = m_model->data(index, ChannelItem::NameRole).toString();
            QString uri = m_model->data(index, ChannelItem::UriRole).toString();
            bool favorite = m_model->data(index, ChannelItem::FavoriteRole).toBool();
            QString dataline = QString("%0 = %1 = %2\n").arg(name).arg(uri).arg(favorite);
            m_channelfile.write(dataline.toAscii());
        }
        m_channelfile.close();
    }
}

void ChannelModelProxy::remove(int index) {
    m_model->removeRow(index);
}

void ChannelModelProxy::load() {
    m_model->clear();

    QString data;
    if (m_channelfile.open(QIODevice::ReadOnly)) {
        data = m_channelfile.readAll();
        m_channelfile.close();
    }
    QStringList lines = data.split("\n");
    foreach(QString line, lines) {
        QStringList values = line.split(" = ");
        if (values.length()==3) {
            QString name = values.takeFirst();
            QString uri = values.takeFirst();
            bool favorite = (values.takeFirst().toInt()==1);
            append(name,uri,favorite);
        }
    }
}
