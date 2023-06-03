#include "Zh.h"

Zh::Zh(QObject *parent) : Lang{parent}
{
    setObjectName("Zh");

    // 侧栏
    search("查找");

    home("主页");
    compose("写邮件");
    inbox("收件箱");

    starred("星标邮件");
    readed("已读");
    drafts("草稿");
    deleted("已删除");

    user("用户");
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
    
    // 其他
    basic_input("基本输入");
    form("表单");
    surface("表面");
    popus("弹窗");
    navigation("导航");
    theming("主题");
    media("媒体");
}
