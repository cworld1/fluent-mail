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
    Q_PROPERTY(QString passwd READ passwd NOTIFY changed)
    Q_PROPERTY(QString smtp READ smtp NOTIFY changed)
    Q_PROPERTY(int smtp_port READ smtp_port NOTIFY changed)
    Q_PROPERTY(QString pop3 READ pop3 NOTIFY changed)
    Q_PROPERTY(int pop3_port READ pop3_port NOTIFY changed)
    Q_PROPERTY(bool isCurUser READ isCurUser WRITE isCurUser NOTIFY changed)

public:
    UserObject()
    {
    }
    UserObject(const QString &id, const QString &name, const QString &email, const bool &isCurUser = false)
        : m_id(id), m_name(name), m_email(email), m_isCurUser(isCurUser)
    {
    }
    UserObject(const QString &id, const QString &name, const QString &email, const QString &passwd,
               const QString &smtp, const int smtp_port,
               const QString &pop3, const int pop3_port, const bool &isCurUser = false)
        : m_id(id), m_name(name), m_email(email), m_passwd(passwd), m_smtp(smtp), m_smtp_port(smtp_port),
          m_pop3(pop3), m_pop3_port(pop3_port), m_isCurUser(isCurUser)
    {
    }
    QString id() const { return m_id; }
    QString name() const { return m_name; }
    QString email() const { return m_email; }
    QString passwd() const { return m_passwd; }
    QString smtp() const { return m_smtp; }
    int smtp_port() const { return m_smtp_port; }
    QString pop3() const { return m_pop3; }
    int pop3_port() const { return m_pop3_port; }
    bool isCurUser() const { return m_isCurUser; }
    void isCurUser(bool isCurUser) { m_isCurUser = isCurUser; }

signals:
    void changed();

private:
    QString m_id;
    QString m_name;
    QString m_email;
    QString m_passwd;
    QString m_smtp;
    int m_smtp_port;
    QString m_pop3;
    int m_pop3_port;
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

// 返回邮件列表
class MailObject : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString id READ id NOTIFY changed)
    Q_PROPERTY(QString email READ email NOTIFY changed)
    Q_PROPERTY(QString subject READ subject NOTIFY changed)
    Q_PROPERTY(QString content READ content NOTIFY changed)
    Q_PROPERTY(QString received_at READ received_at NOTIFY changed)
    Q_PROPERTY(bool is_readed READ is_readed NOTIFY changed)
    Q_PROPERTY(bool is_starred READ is_starred NOTIFY changed)
    Q_PROPERTY(bool is_deleted READ is_deleted NOTIFY changed)

public:
    MailObject(const QString &id, const QString &email, QString &subject, QString &content, QString &received_at,
               const bool &is_readed, const bool &is_starred, const bool &is_deleted)
        : m_id(id), m_email(email), m_subject(subject), m_content(content), m_received_at(received_at),
          m_is_readed(is_readed), m_is_starred(is_starred), m_is_deleted(is_deleted)
    {
    }

    QString id() const { return m_id; }
    QString email() const { return m_email; }
    QString subject() const { return m_subject; }
    QString content() const { return m_content; }
    QString received_at() const { return m_received_at.left(10); }
    bool is_readed() const { return m_is_readed; }
    bool is_starred() const { return m_is_starred; }
    bool is_deleted() const { return m_is_deleted; }

signals:
    void changed();

private:
    QString m_id;
    QString m_email;
    QString m_subject;
    QString m_content;
    QString m_received_at;
    bool m_is_readed;
    bool m_is_starred;
    bool m_is_deleted;
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
    Q_INVOKABLE UserObject *getCurConfig();
    Q_INVOKABLE bool setUser(const QString id);
    Q_INVOKABLE bool delUser(const QString id);
    Q_INVOKABLE bool addUser(const QString &name, const QString &email, const QString &passwd,
                             const QString &smtp, const int smtp_port,
                             const QString &pop3, const int pop3_port);

    // 草稿相关
    Q_INVOKABLE QList<QObject *> getDrafts(int page = 1, int page_size = 10, const QString &filter = "is_sent = 0");
    Q_INVOKABLE DraftObject *getLatestDraft(bool is_new = false);
    Q_INVOKABLE bool updateDraft(const QString &id);
    Q_INVOKABLE bool deleteDraft(const QString &id);
    Q_INVOKABLE bool saveDraft(const QString &id, const QString &email, const QString &subject, const QString &content);
    Q_INVOKABLE bool sendDraft(const QString &id);

    // 邮件相关
    Q_INVOKABLE QList<QObject *> getMails(int page = 1, int page_size = 10, const QString &filter = "is_deleted = 0");
    Q_INVOKABLE void updateMail(const QString &id, const QString &field);
    Q_INVOKABLE bool addMail(MailObject *mail);

private:
    QSqlDatabase db;
    QSqlQuery query;
};

#endif // USER_H
