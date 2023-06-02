#ifndef LANG_H
#define LANG_H

#include <QObject>
#include "../stdafx.h"

class Lang : public QObject
{
    Q_OBJECT

    // 侧栏
    Q_PROPERTY_AUTO(QString, search);

    Q_PROPERTY_AUTO(QString, home);
    Q_PROPERTY_AUTO(QString, compose);
    Q_PROPERTY_AUTO(QString, inbox);

    Q_PROPERTY_AUTO(QString, starred);
    Q_PROPERTY_AUTO(QString, readed);
    Q_PROPERTY_AUTO(QString, drafts);
    Q_PROPERTY_AUTO(QString, trash);

    Q_PROPERTY_AUTO(QString, user);
    Q_PROPERTY_AUTO(QString, settings);

    // 首页
    Q_PROPERTY_AUTO(QString, welcome);
    Q_PROPERTY_AUTO(QString, common_use);
    Q_PROPERTY_AUTO(QString, recommend);

    // 写邮件
    Q_PROPERTY_AUTO(QString, to);
    Q_PROPERTY_AUTO(QString, to_placeholder);
    Q_PROPERTY_AUTO(QString, subject);
    Q_PROPERTY_AUTO(QString, subject_placeholder);
    Q_PROPERTY_AUTO(QString, content_placeholder);
    Q_PROPERTY_AUTO(QString, save_to_drafts);
    Q_PROPERTY_AUTO(QString, send);

    // 设置
    Q_PROPERTY_AUTO(QString, theme_color);
    Q_PROPERTY_AUTO(QString, theme_render_native);

    Q_PROPERTY_AUTO(QString, dark_mode);
    Q_PROPERTY_AUTO(QString, dark_mode_sys);
    Q_PROPERTY_AUTO(QString, dark_mode_light);
    Q_PROPERTY_AUTO(QString, dark_mode_dark);

    Q_PROPERTY_AUTO(QString, navigation_view);
    Q_PROPERTY_AUTO(QString, navigation_view_open);
    Q_PROPERTY_AUTO(QString, navigation_view_compact);
    Q_PROPERTY_AUTO(QString, navigation_view_minimal);
    Q_PROPERTY_AUTO(QString, navigation_view_auto);
    
    Q_PROPERTY_AUTO(QString, basic_input);
    Q_PROPERTY_AUTO(QString, form);
    Q_PROPERTY_AUTO(QString, surface);
    Q_PROPERTY_AUTO(QString, popus);
    Q_PROPERTY_AUTO(QString, navigation);
    Q_PROPERTY_AUTO(QString, theming);
    Q_PROPERTY_AUTO(QString, media);
    Q_PROPERTY_AUTO(QString, locale);

public:
    explicit Lang(QObject *parent = nullptr);
};

#endif // LANG_H
