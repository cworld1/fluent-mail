#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>
#include <QQuickWindow>
#include <QProcess>
#include "lang/Lang.h"
#include "AppInfo.h"
#include "tool/IPC.h"

int main(int argc, char *argv[])
{
    // 将样式设置为Basic，不然会导致组件显示异常
    qputenv("QT_QUICK_CONTROLS_STYLE", "Basic");
    // 6.4及以下监听系统深色模式变化
#ifdef Q_OS_WIN
    qputenv("QT_QPA_PLATFORM", "windows:darkmode=2");
#endif
    QGuiApplication::setOrganizationName("CWorld");
    QGuiApplication::setOrganizationDomain("https://cworld.top/");
    QGuiApplication::setApplicationName("FluentMail");
    //    QQuickWindow::setGraphicsApi(QSGRendererInterface::Software);
    QGuiApplication app(argc, argv);

    AppInfo *appInfo = new AppInfo();
    IPC ipc(0); // 0表示不使用共享内存

    QString activeWindowEvent = "activeWindow";

    // 如果不是当前所有者，则发布事件并退出
    if (!ipc.isCurrentOwner())
    {
        ipc.postEvent(activeWindowEvent, QString().toUtf8(), 0);
        delete appInfo;
        return 0;
    }

    // 如果是当前所有者，则注册事件处理程序
    if (ipc.isAttached())
    {
        ipc.registerEventHandler(
            activeWindowEvent,
            [&appInfo](const QByteArray &)
            {
                // 打开主窗口
                Q_EMIT appInfo->activeWindow();
                return true;
            });
    }

    app.setQuitOnLastWindowClosed(false);

    // 初始化 qml 引擎
    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();

    // 设置语言
    Lang *lang = appInfo->lang();
    context->setContextProperty("lang", lang);
    QObject::connect(appInfo, &AppInfo::langChanged, &app, [context, appInfo]
                     { context->setContextProperty("lang", appInfo->lang()); });
    context->setContextProperty("appInfo", appInfo);

    // 设置初始启动窗口的 qml
    const QUrl url(QStringLiteral("qrc:/FluentMail/qml/App.qml"));
    // const QUrl url(QStringLiteral("qrc:/FluentMail/qml/TestWindow.qml"));

    // 加载 qml
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl)
        {
            // obj 不为空；objUrl 为加载的 qml 文件
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
