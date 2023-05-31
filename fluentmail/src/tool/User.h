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
class DataObject : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name)
    Q_PROPERTY(QString email READ email)

public:
    DataObject(const QString &name, const QString &email)
        : m_name(name), m_email(email)
    {
    }
    QString name() const { return m_name; }
    QString email() const { return m_email; }

private:
    QString m_name;
    QString m_email;
};

class User : public QObject
{
    Q_OBJECT
public:
    explicit User(QObject *parent = nullptr);
    Q_INVOKABLE QList<QObject *> getUsers();
    Q_INVOKABLE void getCurrentUser();
    // Q_INVOKABLE void addUser(const QString &name, const QString &email);

private:
    QSqlDatabase db;
    QSqlQuery query;
};

#endif // USER_H
