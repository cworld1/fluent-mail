﻿#ifndef LANG_H
#define LANG_H

#include <QObject>
#include "../stdafx.h"

class Lang : public QObject
{
    Q_OBJECT

    // 侧栏
    Q_PROPERTY_AUTO(QString, home);
    Q_PROPERTY_AUTO(QString, compose);
    Q_PROPERTY_AUTO(QString, inbox);

    Q_PROPERTY_AUTO(QString, starred);
    Q_PROPERTY_AUTO(QString, readed);
    Q_PROPERTY_AUTO(QString, drafts);
    Q_PROPERTY_AUTO(QString, trash);

    // 首页
    Q_PROPERTY_AUTO(QString, welcome);

    Q_PROPERTY_AUTO(QString, basic_input);
    Q_PROPERTY_AUTO(QString, form);
    Q_PROPERTY_AUTO(QString, surface);
    Q_PROPERTY_AUTO(QString, popus);
    Q_PROPERTY_AUTO(QString, navigation);
    Q_PROPERTY_AUTO(QString, theming);
    Q_PROPERTY_AUTO(QString, media);
    Q_PROPERTY_AUTO(QString, dark_mode);
    Q_PROPERTY_AUTO(QString, sys_dark_mode);
    Q_PROPERTY_AUTO(QString, search);
    Q_PROPERTY_AUTO(QString, about);
    Q_PROPERTY_AUTO(QString, settings);
    Q_PROPERTY_AUTO(QString, navigation_view_display_mode);
    Q_PROPERTY_AUTO(QString, locale);

public:
    explicit Lang(QObject *parent = nullptr);
};

#endif // LANG_H