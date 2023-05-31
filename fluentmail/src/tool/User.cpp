#include "User.h"

QString projectRoot = "../../";
QString settingsFile = "settings.ini";

User::User(QObject *parent) : QObject{parent}
{
    QSettings settings(projectRoot + settingsFile, QSettings::IniFormat);
    // 初始化数据库
    // QStringList drivers = QSqlDatabase::drivers();
    // foreach (QString driver, drivers)
    //     qDebug() << driver;
    QString dbType = settings.value("database/type").toString();
    qDebug() << "数据库类型：" << dbType;
    db = QSqlDatabase::addDatabase(dbType);
    // 创建/打开数据库
    if (dbType == "QSQLITE")
    {
        QString dbLocation = settings.value("database/location").toString();
        QString dbFilename = settings.value("database/filename").toString();
        db.setDatabaseName(projectRoot + dbLocation + "/" + dbFilename);
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
            QDir().mkpath(projectRoot + dbLocation);
            if (db.open())
                qDebug() << "创建数据库成功";
            else
                qDebug() << "数据文件被占用或无权访问，请检查：\n"
                         << db.lastError().text();
        }
    }
    else if (dbType == "QMYSQL")
    {
        db.setHostName(settings.value("database/host").toString());
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
    query = QSqlQuery(db);
    if (dbType == "QMYSQL")
    {
        QString dbName = settings.value("database/dbname").toString();
        if (query.exec("CREATE DATABASE IF NOT EXISTS " + dbName + ";"))
        {
            qDebug() << "成功创建数据库";
            query.exec("USE " + dbName + ";");
        }
        else
            qDebug() << "创建数据库失败：" << query.lastError().text();
    }
    QString incrementCmd = dbType == "QMYSQL" ? "AUTO_INCREMENT" : "AUTOINCREMENT";
    // 创建表格
    QString cmd = "CREATE TABLE IF NOT EXISTS user (id INTEGER" +
                  incrementCmd + "PRIMARY KEY, " +
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

QList<QObject *> User::getUsers()
{
    QList<QObject *> dataList;

    QString cmd = "SELECT name, email FROM user;";
    if (query.exec(cmd))
    {
        while (query.next())
        {
            QString name = query.value(0).toString();
            QString email = query.value(1).toString();

            DataObject *dataObject = new DataObject(name, email);
            dataList.append(dataObject);
        }
    }
    else
    {
        qDebug() << "查询失败：" << query.lastError().text();
    }

    return dataList;
}
