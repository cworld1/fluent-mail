#ifndef SERVER_H
#define SERVER_H

#include <QObject>
#include <QDebug>
#include <QSslSocket>
#include <QTcpSocket>
#include "User.h"

class Server : public QObject
{
    Q_OBJECT
public:
    Server(UserObject *user);
    ~Server();
    Q_INVOKABLE void update(UserObject *user);
    Q_INVOKABLE bool smtp(const QString to, const QString subject, const QString body);
    Q_INVOKABLE bool pop3Init();
    Q_INVOKABLE int pop3Number();
    Q_INVOKABLE MailObject *pop3Get(int id);
    Q_INVOKABLE bool pop3Quit();

private:
    QSslSocket smtpSocket;
    QSslSocket pop3Socket;
    UserObject *user;
};

#endif // SERVER_H
