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

// 返回草稿列表
class DraftObject : public QObject  
{
    Q_OBJECT
    Q_PROPERTY(QString id READ id NOTIFY changed)
    Q_PROPERTY(QString email READ email NOTIFY changed)
    Q_PROPERTY(QString subject READ subject NOTIFY changed)
    Q_PROPERTY(QString content READ content NOTIFY changed)
    Q_PROPERTY(QString updated_at READ updated_at NOTIFY changed)

public:
    DraftObject(const QString &id, const QString &email, QString &subject, QString &content, QString &updated_at)
        : m_id(id), m_email(email), m_subject(subject), m_content(content), m_updated_at(updated_at)
    {
    }

    QString id() const { return m_id; }
    QString email() const { return m_email; }
    QString subject() const { return m_subject; }
    QString content() const { return m_content; }
    QString updated_at() const { return m_updated_at.left(10); }

signals:
    void changed();

private:
    QString m_id;
    QString m_email;
    QString m_subject;
    QString m_content;
    QString m_updated_at;
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
    
    // 草稿相关
    Q_INVOKABLE QList<QObject *> getDrafts(int page = 1, int page_size = 10);
    Q_INVOKABLE DraftObject *getLatestDraft();
    Q_INVOKABLE bool updateDraft(const QString &id);
    Q_INVOKABLE bool deleteDraft(const QString &id);
    Q_INVOKABLE bool saveDraft(const QString &id, const QString &email, const QString &subject, const QString &content);

private:
    QSqlDatabase db;
    QSqlQuery query;
};

#endif // USER_H
