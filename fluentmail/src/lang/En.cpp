#include "En.h"

En::En(QObject *parent) : Lang{parent}
{
    setObjectName("En");

    // 侧栏
    search("Search");

    home("Home");
    compose("Compose");
    inbox("Inbox");

    starred("Starred");
    readed("Readed");
    drafts("Drafts");
    trash("Trash");

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
    save_to_drafts("Save to drafts");
    send("Send");

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
    basic_input("Basic Input");
    form("Form");
    surface("Surfaces");
    popus("Popus");
    navigation("Navigation");
    theming("Theming");
    media("Media");
}
