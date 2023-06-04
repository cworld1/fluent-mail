#ifndef SERVER_H
#define SERVER_H

#include <QObject>
#include <QDebug>
#include <QSslSocket>

class UserConfig
{
public:
    QString username = "";
    QString password = "";
};

class Config : public UserConfig
{
public:
    QString smtpServer = "smtp.qq.com";
    int smtpPort = 465;  // 或者您的SMTP服务器的端口号
    QString fromEmail = "";
    QString toEmail = "";
    QString subject = "Test Email";
    QString body = "This is a test email.";
};

class Server : public QObject
{
    Q_OBJECT
public:
    Server();
    ~Server();
    Q_INVOKABLE bool smtp();
private:
    
};

#endif // SERVER_H
