#include "AppInfo.h"

#include <QQmlContext>
#include <QDebug>

#include "lang/En.h"
#include "lang/Zh.h"

#define STR(x) #x
#define VER_JOIN(a, b, c, d) STR(a.b.c.d)
#define VER_JOIN_(x) VER_JOIN x
#define VER_STR VER_JOIN_((VERSION))

AppInfo::AppInfo(QObject *parent) : QObject{parent}
{
    version(VER_STR);

    // 初始化为英语
    lang(new En());
    // 初始化用户数据
    user(new User());
    // 初始化邮箱服务
    server(new Server(user()->getCurConfig()));
}

void AppInfo::init(QQmlApplicationEngine *engine){
    QQmlContext * context = engine->rootContext();
    Lang* lang = this->lang();
    context->setContextProperty("lang",lang);
    QObject::connect(this,&AppInfo::langChanged,this,[=]{
        context->setContextProperty("lang",this->lang());
    });
    context->setContextProperty("appInfo",this);
}

// 当更改语言时释放语言资源
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

bool AppInfo::isOwnerProcess(IPC *ipc){
    QString activeWindowEvent = "activeWindow";
    if(!ipc->isCurrentOwner()){
        ipc->postEvent(activeWindowEvent,QString().toUtf8(),0);
        return false;
    }
    if(ipc->isAttached()){
        ipc->registerEventHandler(activeWindowEvent,[=](const QByteArray&){
            Q_EMIT this->activeWindow();
            return true;
        });
    }
    return true;
}

void AppInfo::buttonclick(const QString &text)
{
    qDebug() << text;
}
