#ifndef USER_H
#define USER_H

#include "../stdafx.h"
#include <QObject>
#include <QDebug>

// 读取配置文件
#include <QSettings>
#include <QDir>
// SQL 相关
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>

// 返回用户信息
class UserObject : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString id READ id NOTIFY changed)
    Q_PROPERTY(QString name READ name NOTIFY changed)
    Q_PROPERTY(QString email READ email NOTIFY changed)
    Q_PROPERTY(bool isCurUser READ isCurUser WRITE isCurUser NOTIFY changed)

public:
    UserObject(const QString &id, const QString &name, const QString &email, const bool &isCurUser = false)
        : m_id(id), m_name(name), m_email(email), m_isCurUser(isCurUser)
    {
    }
    QString id() const { return m_id; }
    QString name() const { return m_name; }
    QString email() const { return m_email; }
    bool isCurUser() const { return m_isCurUser; }
    void isCurUser(bool isCurUser) { m_isCurUser = isCurUser; }

signals:
    void changed();

private:
    QString m_id;
    QString m_name;
    QString m_email;
    bool m_isCurUser;
};

class User : public QObject
{
    Q_OBJECT
public:
    // 初始化
    explicit User(QObject *parent = nullptr);
    Q_INVOKABLE bool createTables(QString dbType);

    // 用户相关
    Q_INVOKABLE QList<QObject *> getUsers();
    Q_INVOKABLE QString getCurUser();
    Q_INVOKABLE bool setUser(const QString id);
    Q_INVOKABLE bool delUser(const QString id);
    Q_INVOKABLE bool addUser(const QString &name, const QString &email, const QString &passwd,
                             const QString &smtp, const int smtp_port,
                             const QString &pop3, const int pop3_port);

private:
    QSqlDatabase db;
    QSqlQuery query;
};

#endif // USER_H
