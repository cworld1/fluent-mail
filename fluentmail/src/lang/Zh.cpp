﻿#include "Zh.h"

Zh::Zh(QObject *parent) : Lang{parent}
{
    setObjectName("Zh");

    // 常用关键词
    tip("提示");
    // 操作
    cancel("取消");
    cancel_info("操作已取消！");
    confirm("确认");
    // 显示 & 退出
    show("显示主界面");
    minimize("最小化");
    exit("退出");
    // 删除
    delete_("删除");
    delete_success("删除成功！");
    delete_failure("删除失败！");
    // 切换
    switch_("切换");
    switch_success("切换成功！");
    switch_failure("切换失败！");

    // 侧栏
    search("查找");

    home("主页");
    compose("写邮件");
    inbox("收件箱");

    starred("星标邮件");
    sent("已发送");
    drafts("草稿");
    deleted("已删除");

    user("账户");
    settings("设置");

    // 首页
    welcome("欢迎使用流畅邮箱");
    common_use("常用功能");
    recommend("推荐");

    // 写邮件
    to("收件人：");
    to_placeholder("收件人邮箱");
    subject("主题：");
    subject_placeholder("邮件主题");
    content_placeholder("书写美好");
    new_draft("新建草稿");
    save_to_drafts("保存到草稿箱");
    send("发送");
    send_success("发送成功！");

    // 账户管理
    manage_user("账户管理");
    manage_user_add("添加账户");
    manage_user_switch("切换");
    manage_user_delete("删除");

    // 新增账户
    user_name("用户名");
    user_name_placeholder("用户名");
    user_email("电子邮件");
    user_email_placeholder("电子邮件地址");
    user_password("密码");
    user_password_placeholder("服务器密码");
    user_smtp("SMTP");
    user_smtp_placeholder("SMTP 服务器地址");
    user_pop3("POP3");
    user_pop3_placeholder("POP3 服务器地址");
    user_port_placeholder("端口");
    user_add_confirm("添加账户");

    // 关于
    about("关于");

    // 邮件详情
    mail_detail("邮件详情");

    // 设置
    theme_color("主题颜色");
    theme_render_native("Native 文本渲染");

    dark_mode("深色模式");
    dark_mode_sys("跟随系统");
    dark_mode_light("浅色");
    dark_mode_dark("深色");
    
    navigation_view("导航视图显示模式");
    navigation_view_open("保持打开");
    navigation_view_compact("紧凑");
    navigation_view_minimal("最小化");
    navigation_view_auto("自动");

    locale("语言环境");
}
