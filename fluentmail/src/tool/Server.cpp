#include "Server.h"

Server::Server()
{
    qDebug() << "Server::Server()";
}

Server::~Server()
{
}

bool Server::smtp()
{
    // 电子邮件信息
    Config config;

    // 构建邮件内容
    QString emailContent = "From: " + config.fromEmail + "\r\n";
    emailContent += "To: " + config.toEmail + "\r\n";
    emailContent += "Subject: " + config.subject + "\r\n";
    emailContent += "Content-Type: text/plain\r\n";
    emailContent += "\r\n";
    emailContent += config.body;

    // 连接到SMTP服务器
    QSslSocket socket;
    socket.connectToHostEncrypted(config.smtpServer, config.smtpPort);
    qDebug() << "Waiting for connect...";
    if (!socket.waitForConnected()) {
        qDebug() << "Failed to connect to SMTP server.";
        return -1;
    }
    // 读取连接响应
    if (!socket.waitForReadyRead()) {
        qDebug() << "Failed to read server response.";
        return -1;
    }
    qDebug() << socket.readAll().trimmed();

    // 发送SMTP命令和数据
    socket.write("EHLO localhost\r\n");
    socket.waitForBytesWritten();

    socket.write("AUTH LOGIN\r\n");
    socket.waitForBytesWritten();

    socket.write(QByteArray().append(config.username.toUtf8()).toBase64() + "\r\n");
    socket.waitForBytesWritten();

    socket.write(QByteArray().append(config.password.toUtf8()).toBase64() + "\r\n");
    socket.waitForBytesWritten();

    socket.write("MAIL FROM: <" + config.fromEmail.toUtf8() + ">\r\n");
    socket.waitForBytesWritten();

    socket.write("RCPT TO: <" + config.toEmail.toUtf8() + ">\r\n");
    socket.waitForBytesWritten();

    socket.write("DATA\r\n");
    socket.waitForBytesWritten();

    socket.write(emailContent.toUtf8());
    socket.write("\r\n.\r\n");
    socket.waitForBytesWritten();

    socket.write("QUIT\r\n");
    socket.waitForBytesWritten();

    // 读取服务器响应并断开连接
    qDebug() << "Waiting for receiption response...";
    if (!socket.waitForReadyRead()) {
        qDebug() << "Failed to read server response.";
        return -1;
    }
    // 读取服务器响应并输出
    qDebug() << socket.readAll().trimmed();

    // 查看错误
    qDebug() << "Error:";
    qDebug() << socket.errorString();

    socket.disconnectFromHost();

    qDebug() << "Email sent successfully.";

    return 0;
}