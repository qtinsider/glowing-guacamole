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

#include "channelitem.h"

ChannelItem::ChannelItem(const QString &name, const QString &uri,const bool &favorite, QObject *parent) :
    ListItem(parent), m_name(name), m_uri(uri), m_favorite(favorite)
  {
  }


  QHash<int, QByteArray> ChannelItem::roleNames() const
  {
    QHash<int, QByteArray> names;
    names[NameRole] = "title";
    names[UriRole] = "uri";
    names[FavoriteRole] = "favorite";
    return names;
  }

  QVariant ChannelItem::data(int role) const
  {
    switch(role) {
    case NameRole:
      return name();
    case UriRole:
      return uri();
    case FavoriteRole:
        return favorite();
    default:
      return QVariant();
    }
  }
