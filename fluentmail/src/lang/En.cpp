#include "En.h"

En::En(QObject *parent) : Lang{parent}
{
    setObjectName("En");

    // 常用关键词
    tip("Tip");
    // 操作
    cancel("Cancel");
    cancel_info("Operation canceled!");
    confirm("Confirm");
    // 显示 & 退出
    show("Show main window");
    minimize("Minimize");
    exit("Exit");
    // 删除
    delete_("Delete");
    delete_success("Delete successful!");
    delete_failure("Delete failed!");
    // 切换
    switch_("Switch");
    switch_success("Switch successful!");
    switch_failure("Switch failed!");

    // 侧栏
    search("Search");

    home("Home");
    compose("Compose");
    inbox("Inbox");

    starred("Starred");
    sent("Sent");
    drafts("Drafts");
    deleted("Deleted");

    user("User");
    settings("Settings");

    // 首页
    welcome("Welcome with FluentMail");
    common_use("Commonly used functions");
    recommend("Recommend");

    // 写邮件
    to("To:");
    to_placeholder("Recipient's email");
    subject("Subject:");
    subject_placeholder("Subject of email");
    content_placeholder("Write something");
    new_draft("New draft");
    save_to_drafts("Save to drafts");
    send("Send");
    send_success("Send successful!");

    // 用户管理
    manage_user("Manage user");
    manage_user_add("Add user");
    manage_user_switch("Switch");
    manage_user_delete("Delete");

    // 关于
    about("About");

    // 设置
    theme_color("Theme color");
    theme_render_native("Native text rendering");
    
    dark_mode("Dark Mode");
    dark_mode_sys("Follow system");
    dark_mode_light("Light");
    dark_mode_dark("Dark");

    navigation_view("NavigationView Display Mode");
    navigation_view_open("Keep open");
    navigation_view_compact("Compact");
    navigation_view_minimal("Minimal");
    navigation_view_auto("Auto");

    locale("Locale");
    
    // 其他
    // basic_input("Basic Input");
    form("Form");
    surface("Surfaces");
    popus("Popus");
    navigation("Navigation");
    theming("Theming");
    media("Media");
}
