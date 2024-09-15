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

#ifndef CHANNELITEM_H
#define CHANNELITEM_H

#include <QtCore>
#include "listmodel.h"

class ChannelItem : public ListItem
{
  Q_OBJECT

public:
  enum Roles {
    NameRole = Qt::UserRole+1,
    UriRole,
    FavoriteRole
  };

public:
  ChannelItem(QObject *parent = 0): ListItem(parent) {}
  explicit ChannelItem(const QString &name, const QString &uri, const bool &favorite, QObject *parent = 0);
  QVariant data(int role) const;
  QHash<int, QByteArray> roleNames() const;
  inline QString id() const { return m_name; }
  inline QString name() const { return m_name; }
  inline QString uri() const { return m_uri; }
  inline bool favorite() const { return m_favorite; }

private:
  QString m_name;
  QString m_uri;
  bool m_favorite;
};

#endif // CHANNELITEM_H
