#include "AppInfo.h"
#include "lang/En.h"
#include "lang/Zh.h"
#include <QDebug>
// 读取配置文件
#include <QSettings>
#include <QDir>
// SQL 相关
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>

#define STR(x) #x
#define VER_JOIN(a, b, c, d) STR(a.b.c.d)
#define VER_JOIN_(x) VER_JOIN x
#define VER_STR VER_JOIN_((VERSION))
QString settingsFile = "../../settings.ini";

AppInfo::AppInfo(QObject *parent) : QObject{parent}
{
    version(VER_STR);
    QSettings settings(settingsFile, QSettings::IniFormat);

    // 初始化为英语
    lang(new En());

    // 初始化数据库
    // 创建/打开数据库
    QString dbType = settings.value("database/type").toString();
    qDebug() << "数据库类型：" << dbType;
    QSqlDatabase db = QSqlDatabase::addDatabase(dbType);
    if (dbType == "QSQLITE")
    {
        QString dbLocation = settings.value("database/location").toString();
        QString dbFilename = settings.value("database/filename").toString();
        db.setDatabaseName("../../" + dbLocation + "/" + dbFilename);
        // 打开
        try
        {
            if (db.open())
                qDebug() << "打开数据库成功";
            else
                throw QSqlError(db.lastError());
        }
        catch (const QSqlError &error)
        {
            QDir().mkpath("../../" + dbLocation);
            if (db.open())
                qDebug() << "创建数据库成功";
            else
                qDebug() << "数据文件被占用或无权访问，请检查：\n"
                         << db.lastError().text();
        }
    }
    else if (dbType == "QMYSQL")
    {
        db.setHostName(settings.value("database/hostname").toString());
        db.setPort(settings.value("database/port").toInt());
        db.setUserName(settings.value("database/username").toString());
        db.setPassword(settings.value("database/password").toString());
        if (db.open())
            qDebug() << "打开数据库成功";
        else
            qDebug() << "打开数据库失败：" << db.lastError().text();
    }
    else
    {
        qDebug() << "数据库类型错误";
    }
    // 创建 database
    QSqlQuery query(db);
    if (dbType == "QMYSQL")
    {
        QString dbName = settings.value("database/dbname").toString();
        if (query.exec("CREATE DATABASE IF NOT EXISTS " + dbName + ";"))
            qDebug() << "成功创建数据库";
        else
            qDebug() << "创建数据库失败：" << query.lastError().text();
    }
    // 创建表格
    QString cmd = "CREATE TABLE IF NOT EXISTS user ("
                  "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                  "name VARCHAR(255) NOT NULL, "
                  "email VARCHAR(255) NOT NULL, "
                  "passwd VARCHAR(255) NOT NULL, "
                  "smtp VARCHAR(255) NOT NULL, "
                  "smtp_port INT NOT NULL, "
                  "pop3 VARCHAR(255) NOT NULL, "
                  "pop3_port INT NOT NULL, "
                  "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
                  ");";
    if (query.exec(cmd))
        qDebug() << "成功创建表格";
    else
        qDebug() << "创建表格失败：" << query.lastError().text();
}

// 当更改语言时释放语言资源
void AppInfo::changeLang(const QString &locale)
{
    if (_lang)
    {
        _lang->deleteLater();
    }

    // 判断语言类型
    if (locale == "Zh")
    {
        lang(new Zh());
    }
    else if (locale == "En")
    {
        lang(new En());
    }
    else
    {
        lang(new En());
    }
}

void AppInfo::buttonclick(const QString &text)
{
    qDebug() << text;
}