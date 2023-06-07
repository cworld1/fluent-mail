#include "Server.h"

Server::Server(UserObject *user)
{
    this->user = user;
}

Server::~Server()
{
}

void Server::update(UserObject *user)
{
    this->user = user;
}

bool Server::smtp(const QString toemail, const QString subject, const QString content)
{
    // 构建邮件内容
    QString emailContent = "From: " + user->email() + "\r\n";
    emailContent += "To: " + toemail + "\r\n";
    emailContent += "Subject: " + subject + "\r\n";
    emailContent += "MIME-Version: 1.0\r\n";
    emailContent += "Content-Type: text/plain\r\n";
    emailContent += "\r\n";
    emailContent += content;
    emailContent += "\r\n.\r\n";

    // 连接到SMTP服务器
    qDebug() << "Waiting for connect...";
    smtpSocket.connectToHostEncrypted(user->smtp(), user->smtp_port());
    if (!smtpSocket.waitForConnected())
    {
        qDebug() << "Failed to connect to SMTP server.";
        return false;
    }
    // 读取连接响应
    if (smtpSocket.waitForReadyRead())
        qDebug() << smtpSocket.readAll().trimmed();
    else
    {
        qDebug() << "Failed to read server response: " << smtpSocket.errorString();
        return false;
    }

    // 发送SMTP命令和数据
    smtpSocket.write("EHLO " + user->smtp().toUtf8() + "\r\n");
    smtpSocket.waitForBytesWritten();
    if (smtpSocket.waitForReadyRead())
        qDebug() << smtpSocket.readAll().trimmed();
    else
    {
        qDebug() << "Failed to read server response: " << smtpSocket.errorString();
        return false;
    }
    smtpSocket.write("STARTTLS \r\n");
    smtpSocket.waitForBytesWritten();
    if (smtpSocket.waitForReadyRead())
        qDebug() << smtpSocket.readAll().trimmed();
    else
    {
        qDebug() << "Failed to read server response: " << smtpSocket.errorString();
        return false;
    }

    // 登录认证
    qDebug() << "Sending authentication information...";
    smtpSocket.write("AUTH LOGIN\r\n");
    smtpSocket.waitForBytesWritten();
    // 注意 Base64 编码加密
    smtpSocket.write(QByteArray().append(user->email().toUtf8()).toBase64() + "\r\n");
    smtpSocket.waitForBytesWritten();
    if (smtpSocket.waitForReadyRead())
        qDebug() << smtpSocket.readAll().trimmed();
    else
    {
        qDebug() << "Failed to read server response: " << smtpSocket.errorString();
        return false;
    }
    smtpSocket.write(QByteArray().append(user->passwd().toUtf8()).toBase64() + "\r\n");
    smtpSocket.waitForBytesWritten();
    if (smtpSocket.waitForReadyRead())
        qDebug() << smtpSocket.readAll().trimmed();
    else
    {
        qDebug() << "Failed to read server response: " << smtpSocket.errorString();
        return false;
    }

    // 发送邮件
    qDebug() << "Sending email...";
    smtpSocket.write("MAIL FROM: <" + user->email().toUtf8() + ">\r\n");
    smtpSocket.waitForBytesWritten();
    smtpSocket.write("RCPT TO: <" + toemail.toUtf8() + ">\r\n");
    smtpSocket.waitForBytesWritten();
    smtpSocket.write("DATA \r\n");
    smtpSocket.waitForBytesWritten();
    smtpSocket.write(emailContent.toUtf8());
    smtpSocket.waitForBytesWritten();
    smtpSocket.write("\r\n.\r\n");
    smtpSocket.waitForBytesWritten();
    smtpSocket.write("QUIT\r\n");
    smtpSocket.waitForBytesWritten();
    if (smtpSocket.waitForReadyRead())
        qDebug() << smtpSocket.readAll().trimmed();
    else
    {
        qDebug() << "Failed to read server response: " << smtpSocket.errorString();
        return false;
    }

    smtpSocket.disconnectFromHost();
    qDebug() << "Email sent successfully.";
    return true;

    return 0;
}