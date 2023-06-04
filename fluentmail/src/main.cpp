#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>
#include <QQuickWindow>
#include <QProcess>
#include <FramelessHelper/Quick/framelessquickmodule.h>
#include <FramelessHelper/Core/private/framelessconfig_p.h>
#include "AppInfo.h"

FRAMELESSHELPER_USE_NAMESPACE

int main(int argc, char *argv[])
{
    // 将样式设置为Basic，不然会导致组件显示异常
    qputenv("QT_QUICK_CONTROLS_STYLE","Basic");
    // 6.4及以下监听系统深色模式变化
#ifdef Q_OS_WIN
    qputenv("QT_QPA_PLATFORM", "windows:darkmode=2");
#endif
    FramelessHelper::Quick::initialize();
    // 设置应用程序信息
    QGuiApplication::setOrganizationName("CWorld");
    QGuiApplication::setOrganizationDomain("https://cworld.top/");
    QGuiApplication::setApplicationName("FluentMail");
    QGuiApplication app(argc, argv);

#ifdef Q_OS_WIN // 此设置仅在Windows下生效
    FramelessConfig::instance()->set(Global::Option::ForceHideWindowFrameBorder);
#endif
    FramelessConfig::instance()->set(Global::Option::DisableLazyInitializationForMicaMaterial);
    FramelessConfig::instance()->set(Global::Option::CenterWindowBeforeShow);
    FramelessConfig::instance()->set(Global::Option::ForceNonNativeBackgroundBlur);
    FramelessConfig::instance()->set(Global::Option::EnableBlurBehindWindow);
#ifdef Q_OS_MACOS
    FramelessConfig::instance()->set(Global::Option::ForceNonNativeBackgroundBlur,false);
#endif

    AppInfo *appInfo = new AppInfo();
    IPC ipc(0);

    // 检查是否已经有一个实例在运行
    if(!appInfo->isOwnerProcess(&ipc)){
        return 0;
    }
    app.setQuitOnLastWindowClosed(false);
    QQmlApplicationEngine engine;
    FramelessHelper::Quick::registerTypes(&engine);
    appInfo->init(&engine);
    // 设置初始启动窗口的 qml
    const QUrl url(QStringLiteral("qrc:/fluentmail/qml/App.qml"));
    // const QUrl url(QStringLiteral("qrc:/fluentmail/qml/TestWindow.qml"));
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl)
        {
            // obj 不为空；objUrl 为加载的 qml 文件
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);
    return app.exec();
}
