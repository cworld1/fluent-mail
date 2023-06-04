#ifndef APPINFO_H
#define APPINFO_H

#include <QObject>
#include <QQmlApplicationEngine>

#include "tool/IPC.h"
#include "lang/Lang.h"
#include "tool/User.h"
#include "tool/Server.h"
#include "stdafx.h"

class AppInfo : public QObject
{
    Q_OBJECT
    Q_PROPERTY_AUTO(QString, version)
    Q_PROPERTY_AUTO(Lang *, lang)
    Q_PROPERTY_AUTO(User *, user)
    Q_PROPERTY_AUTO(Server *, server)
public:
    explicit AppInfo(QObject *parent = nullptr);
    void init(QQmlApplicationEngine *engine);
    // 检查是否已经有一个实例在运行
    bool isOwnerProcess(IPC *ipc);
    // 更改语言
    Q_INVOKABLE void changeLang(const QString &locale);
    // 获得用户信息
    Q_INVOKABLE void buttonclick(const QString &text);
    // 激活窗口
    Q_SIGNAL void activeWindow();
};

#endif // APPINFO_H
