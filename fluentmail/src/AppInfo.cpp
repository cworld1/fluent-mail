#include "AppInfo.h"

#include <QQmlContext>
#include <QDebug>

#include "lang/En.h"
#include "lang/Zh.h"

#define STR(x) #x
#define VER_JOIN(a, b, c, d) STR(a.b.c.d)
#define VER_JOIN_(x) VER_JOIN x
#define VER_STR VER_JOIN_((VERSION))

/**
 * @brief AppInfo类的构造函数。
 *
 * @param parent 父对象
 */
AppInfo::AppInfo(QObject *parent) : QObject{parent}
{
    version(VER_STR);

    // 初始化为英语
    lang(new En());
    // 初始化账户数据
    user(new User());
    // 初始化邮箱服务
    server(new Server(user()->getCurConfig()));
}

/**
 * @brief 使用给定的 QQmlApplicationEngine 初始化 AppInfo 对象。
 *
 * @param engine 要初始化的 QQmlApplicationEngine。
 */
void AppInfo::init(QQmlApplicationEngine *engine)
{
    QQmlContext *context = engine->rootContext();
    Lang *lang = this->lang();
    context->setContextProperty("lang", lang);
    QObject::connect(this, &AppInfo::langChanged, this, [=]
                     { context->setContextProperty("lang", this->lang()); });
    context->setContextProperty("appInfo", this);
}

/**
 * @brief 更改应用程序的语言。
 * 
 * @param locale 要更改为的语言环境。
 * 
 * @note 更改语言时释放语言资源。
 */
void AppInfo::changeLang(const QString &locale)
{
    if (_lang)
        _lang->deleteLater();

    // 判断语言类型
    if (locale == "Zh")
        lang(new Zh());
    else if (locale == "En")
        lang(new En());
    else
        lang(new En());
}

/**
 * @brief 判断当前进程是否为IPC的所有者
 *
 * @param ipc 一个指向IPC对象的指针
 * @return 如果当前进程是IPC的所有者，则返回true，否则返回false
 *
 * @note 释放资源后，需要重新初始化
 */
bool AppInfo::isOwnerProcess(IPC *ipc)
{
    QString activeWindowEvent = "activeWindow";
    if (!ipc->isCurrentOwner())
    {
        ipc->postEvent(activeWindowEvent, QString().toUtf8(), 0);
        return false;
    }
    if (ipc->isAttached())
    {
        ipc->registerEventHandler(activeWindowEvent, [=](const QByteArray &)
                                  {
            Q_EMIT this->activeWindow();
            return true; });
    }
    return true;
}
