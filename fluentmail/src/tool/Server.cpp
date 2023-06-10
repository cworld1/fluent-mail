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
}

bool Server::pop3Init()
{
    qDebug() << "Waiting for connect...";
    qDebug() << user->pop3() << user->pop3_port();
    qDebug() << user->email() << user->passwd();
    pop3Socket.connectToHostEncrypted(user->pop3(), user->pop3_port());
    if (!pop3Socket.waitForConnected())
    {
        qDebug() << "Failed to connect to POP3 server.";
        return false;
    }
    // 读取连接响应
    if (pop3Socket.waitForReadyRead())
        qDebug() << pop3Socket.readAll().trimmed();
    else
    {
        qDebug() << "Failed to read server response: " << pop3Socket.errorString();
        return false;
    }

    // 登录认证
    qDebug() << "Sending authentication information...";
    // 发送账户名
    pop3Socket.write("USER " + user->email().toUtf8() + "\r\n");
    pop3Socket.waitForBytesWritten();
    if (pop3Socket.waitForReadyRead())
        qDebug() << pop3Socket.readAll().trimmed();
    else
    {
        qDebug() << "Failed to read server response: " << pop3Socket.errorString();
        return false;
    }
    // 发送密码
    pop3Socket.write("PASS " + user->passwd().toUtf8() + "\r\n");
    pop3Socket.waitForBytesWritten();
    if (pop3Socket.waitForReadyRead())
        qDebug() << pop3Socket.readAll().trimmed();
    else
    {
        qDebug() << "Failed to read server response: " << pop3Socket.errorString();
        return false;
    }
    return true;
}

int Server::pop3Number()
{
    // 发送获取邮件数量命令
    qDebug() << "Getting stats...";
    pop3Socket.write("STAT\r\n");
    pop3Socket.waitForBytesWritten();
    // 读取获取邮件数量响应
    if (pop3Socket.waitForReadyRead())
    {
        QString response = pop3Socket.readAll().trimmed();
        QStringList parts = response.split(' ');
        if (parts.count() >= 2)
        {
            bool ok;
            int number = parts[1].toInt(&ok);
            if (ok)
            {
                return number;
            }
        }
    }
    else
    {
        qDebug() << "Failed to read server response: " << pop3Socket.errorString();
        return false;
    }
    return true;
}

MailObject *Server::pop3Get(int id)
{
    QString received_content;
    QString subject = "", received_at = "",
            email = "", message_id = "", content = "";
    // 发送获取指定条邮件命令
    qDebug() << "Getting latest mail...";
    pop3Socket.write("RETR " + QByteArray::number(id) + "\r\n");
    pop3Socket.waitForBytesWritten();
    if (pop3Socket.waitForReadyRead())
    {
        received_content = pop3Socket.readAll().trimmed();
        // qDebug() << received_content;
        // 解析邮件内容
        QStringList lines = received_content.split("\r\n");
        bool is_content = false;
        for (const QString &line : lines)
        {
            if (!is_content && line == "")
            {
                qDebug() << "Content: ";
                is_content = true;
            }
            else if (line == ".")
            {
                qDebug() << "End of mail.";
                break;
            }
            else if (line.startsWith("Subject:"))
            {
                subject = line.mid(9).trimmed(); // 提取标题
                qDebug() << "Subject: " << subject;
            }
            else if (line.startsWith("Date:"))
            {
                received_at = line.mid(6).trimmed(); // 提取收到时间
                qDebug() << "Date: " << received_at;
            }
            else if (line.startsWith("From:"))
            {
                email = line.mid(6).trimmed(); // 提取发件人邮箱
                qDebug() << "From: " << email;
            }
            else if (line.startsWith("Message-ID:"))
            {
                message_id = line.mid(12).trimmed(); // 提取邮件ID
                qDebug() << "Message-ID: " << message_id;
            }

            if (is_content)
            {
                qDebug() << line;
                content += line + "\r\n";
            }
        }
    }
    else
    {
        qDebug() << "Failed to read server response: " << pop3Socket.errorString();
    }
    MailObject *mailObject = new MailObject(
        message_id, email, subject, content, received_at,
        false, false, false
    );

    return mailObject;
}

bool Server::pop3Quit()
{
    // 断开与服务器的连接
    qDebug() << "Disconnecting...";
    pop3Socket.write("QUIT\r\n");
    pop3Socket.waitForBytesWritten();
    if (pop3Socket.waitForReadyRead())
        qDebug() << pop3Socket.readAll().trimmed();
    else
    {
        qDebug() << "Failed to read server response: " << pop3Socket.errorString();
        return false;
    }

    pop3Socket.disconnectFromHost();
    qDebug() << "POP3 operations completed.";

    return true;
}
