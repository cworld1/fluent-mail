#ifndef APPINFO_H
#define APPINFO_H

#include <QObject>
#include "lang/Lang.h"
#include "tool/User.h"
#include "stdafx.h"

class AppInfo : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QString, version)
    Q_PROPERTY_AUTO(Lang *, lang)
    Q_PROPERTY_AUTO(User *, user)
public:
    explicit AppInfo(QObject *parent = nullptr);
    Q_SIGNAL void activeWindow();
    // 更改语言
    Q_INVOKABLE void changeLang(const QString &locale);
    // 获得用户信息
    Q_INVOKABLE void buttonclick(const QString &text);
};

#endif // APPINFO_H
