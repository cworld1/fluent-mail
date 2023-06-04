#ifndef LANG_H
#define LANG_H

#include <QObject>
#include "../stdafx.h"

class Lang : public QObject
{
    Q_OBJECT

    // 常用关键词
    Q_PROPERTY_AUTO(QString, tip);
    // 操作
    Q_PROPERTY_AUTO(QString, cancel);
    Q_PROPERTY_AUTO(QString, cancel_info);
    Q_PROPERTY_AUTO(QString, confirm);
    // 显示 & 退出
    Q_PROPERTY_AUTO(QString, show);
    Q_PROPERTY_AUTO(QString, minimize);
    Q_PROPERTY_AUTO(QString, exit);
    // 删除
    Q_PROPERTY_AUTO(QString, delete_);
    Q_PROPERTY_AUTO(QString, delete_success);
    Q_PROPERTY_AUTO(QString, delete_failure);
    // 切换
    Q_PROPERTY_AUTO(QString, switch_);
    Q_PROPERTY_AUTO(QString, switch_success);
    Q_PROPERTY_AUTO(QString, switch_failure);

    // 侧栏
    Q_PROPERTY_AUTO(QString, search);

    Q_PROPERTY_AUTO(QString, home);
    Q_PROPERTY_AUTO(QString, compose);
    Q_PROPERTY_AUTO(QString, inbox);

    Q_PROPERTY_AUTO(QString, starred);
    Q_PROPERTY_AUTO(QString, sent);
    Q_PROPERTY_AUTO(QString, drafts);
    Q_PROPERTY_AUTO(QString, deleted);

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
    Q_PROPERTY_AUTO(QString, new_draft);
    Q_PROPERTY_AUTO(QString, save_to_drafts);
    Q_PROPERTY_AUTO(QString, send);

    // 用户管理
    Q_PROPERTY_AUTO(QString, manage_user);
    Q_PROPERTY_AUTO(QString, manage_user_add);
    Q_PROPERTY_AUTO(QString, manage_user_switch);
    Q_PROPERTY_AUTO(QString, manage_user_delete);

    // 关于
    Q_PROPERTY_AUTO(QString, about);

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
