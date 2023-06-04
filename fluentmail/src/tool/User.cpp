#include "User.h"

QString projectRoot = "../../";
QString settingsFile = "settings.ini";

/**
 * @class User
 * @brief 初始化数据库
 */
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
            qDebug() << "成功创建 Database";
            query.exec("USE " + dbName + ";");
        }
        else
            qDebug() << "创建数据库失败：" << query.lastError().text();
    }

    // 创建表
    bool tableIsCreate = createTables(dbType);
}

/**
 * @brief 创建数据库表
 * @return bool 是否成功
 */
bool User::createTables(QString dbType)
{
    QStringList debugList;
    QString incrementCmd = dbType == "QSQLITE" ? "AUTOINCREMENT" : "AUTO_INCREMENT";

    // 创建 users 表
    QString cmd = "CREATE TABLE IF NOT EXISTS users ("
                  "id INTEGER PRIMARY KEY " +
                  incrementCmd +
                  " NOT NULL, "
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
        debugList.append("users");
    else
    {
        qDebug() << "创建 users 表失败：" << query.lastError().text();
        return false;
    }

    // 创建 cur_user 表
    cmd = "CREATE TABLE IF NOT EXISTS cur_user ("
          "user_id INT NOT NULL"
          ");";
    if (query.exec(cmd))
        debugList.append("cur_user");
    else
    {
        qDebug() << "创建 cur_user 表失败：" << query.lastError().text();
        return false;
    }

    // 创建 drafts 表
    cmd = "CREATE TABLE IF NOT EXISTS drafts ("
          "id INTEGER PRIMARY KEY " +
          incrementCmd +
          " NOT NULL, "
          "email VARCHAR(255) NOT NULL, "
          "subject VARCHAR(255) NOT NULL, "
          "content TEXT NOT NULL, "
          "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
          ");";
    if (query.exec(cmd))
        debugList.append("drafts");
    else
    {
        qDebug() << "创建 drafts 表失败：" << query.lastError().text();
        return false;
    }

    // 创建 mails 表
    cmd = "CREATE TABLE IF NOT EXISTS mails ("
          "id INTEGER PRIMARY KEY " +
          incrementCmd +
          " NOT NULL, "
          "user_id INT NOT NULL, "
          "email VARCHAR(255) NOT NULL, "
          "subject VARCHAR(255) NOT NULL, "
          "content TEXT NOT NULL, "
          "recieved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "
          "is_readed TINYINT DEFAULT 0, "
          "is_starred TINYINT DEFAULT 0, "
          "is_deleted TINYINT DEFAULT 0"
          ");";
    if (query.exec(cmd))
        debugList.append("mails");
    else
    {
        qDebug() << "创建 mails 表失败：" << query.lastError().text();
        return false;
    }

    qDebug() << "成功创建表：" << debugList.join(", ");

    return true;
}

/**
 * @brief 获取所有用户信息（简短）
 * @return QList<QObject *> 用户信息列表
 */
QList<QObject *> User::getUsers()
{
    QList<QObject *> dataList;
    QString curUser = getCurUser();

    QString cmd = "SELECT id, name, email FROM users;";
    if (query.exec(cmd))
    {
        while (query.next())
        {
            QString id = query.value(0).toString();
            QString name = query.value(1).toString();
            QString email = query.value(2).toString();

            UserObject *userObject = new UserObject(
                id, name, email,
                id == curUser ? true : false);
            dataList.append(userObject);
        }
    }
    else
    {
        qDebug() << "查询失败：" << query.lastError().text();
    }

    return dataList;
}

/**
 * @brief 获取当前用户信息
 * @return QString 用户名
 */
QString User::getCurUser()
{
    QString cmd = "SELECT user_id FROM cur_user;";

    QString result;
    if (query.exec(cmd))
    {
        query.next();
        result = query.value(0).toString();
    }
    else
        qDebug() << "查询失败：" << query.lastError().text();
    return result;
}

/**
 * @brief 设置当前用户
 * @param id 用户 id
 */
bool User::setUser(const QString id)
{
    QString cmd = "UPDATE cur_user SET user_id = " + id + ";";
    if (query.exec(cmd))
        qDebug() << "设置当前用户成功！id：" << id;
    else
    {
        qDebug() << "设置当前用户失败：" << query.lastError().text();
        return false;
    }
    return true;
}

/**
 * @brief 删除用户
 * @param id 用户 id
 */
bool User::delUser(const QString id)
{
    QString cmd = "DELETE FROM users WHERE id = " + id + ";";
    if (query.exec(cmd))
        qDebug() << "删除用户成功！id：" << id;
    else
    {
        qDebug() << "删除用户失败：" << query.lastError().text();
        return false;
    }
    return true;
}

/**
 * @brief 添加用户
 * @param name 用户名
 * @param email 邮箱
 * @param passwd 密码
 * @param smtp SMTP 服务器
 * @param smtp_port SMTP 端口
 * @param pop3 POP3 服务器
 * @param pop3_port POP3 端口
 */
bool User::addUser(const QString &name, const QString &email, const QString &passwd,
                   const QString &smtp, const int smtp_port,
                   const QString &pop3, const int pop3_port)
{
    QString cmd = "INSERT INTO users (name, email, passwd, "
                  "smtp, smtp_port, pop3, pop3_port) "
                  "VALUES ('" +
                  name + "', '" + email + "', '" + passwd + "', '" +
                  smtp + "', " + QString::number(smtp_port) + ", '" +
                  pop3 + "', " + QString::number(pop3_port) + ");";
    if (query.exec(cmd))
        qDebug() << "添加用户成功";
    else
    {
        qDebug() << "添加用户失败：" << query.lastError().text();
        return false;
    }

    // 设置当前用户
    query.exec("select count(*) from cur_user;");
    if (query.next() && query.value(0).toInt() == 0)
        query.exec("INSERT INTO cur_user (user_id) VALUES (SELECT LAST_INSERT_ID());");
    else
        query.exec("UPDATE cur_user SET user_id = (SELECT LAST_INSERT_ID());");
    if (query.exec("SELECT user_id FROM cur_user;") && query.next())
        qDebug() << "设置当前用户成功";
    else
        qDebug() << "设置当前用户失败：" << query.lastError().text();
    return true;
}

/**
 * @brief 获取草稿列表
 * @return QList<QObject *> 草稿列表
 */
QList<QObject *> User::getDrafts(int page, int page_size)
{
    QList<QObject *> dataList;
    QString cmd = "SELECT id, email, subject, content, updated_at FROM drafts "
                  "ORDER BY updated_at DESC "
                  "LIMIT " +
                  QString::number(page_size) + " OFFSET " + QString::number((page - 1) * page_size) + ";";
    if (query.exec(cmd))
    {
        while (query.next())
        {
            QString id = query.value(0).toString();
            QString email = query.value(1).toString();
            QString subject = query.value(2).toString();
            QString content = query.value(3).toString();
            QString updated_at = query.value(4).toString();

            DraftObject *draftObject = new DraftObject(
                id, email, subject, content, updated_at);
            dataList.append(draftObject);
        }
    }
    else
    {
        qDebug() << "查询失败：" << query.lastError().text();
    }
    return dataList;
}

/**
 * @brief 获取草稿
 * @return QString 草稿 id
 * @note 如果没有草稿，则创建一个空草稿
 */
DraftObject *User::getLatestDraft(bool is_new)
{
    QString id, email, subject, content, updated_at;
    // 检查是否有草稿
    query.exec("SELECT COUNT(*) FROM drafts;");
    query.next();
    if (query.value(0).toInt() == 0 || is_new)
    {
        // 创建空草稿
        QString cmd = "INSERT INTO drafts (email, subject, content) "
                      "VALUES ('', '', '');";
        if (query.exec(cmd))
        {
            id = query.lastInsertId().toString();
            qDebug() << "新增草稿成功！id：" << id;
        }
        else
            qDebug() << "新增草稿失败：" << query.lastError().text();
        email = subject = content = updated_at = "";
    }
    else
    {
        // 获取最新草稿
        QString cmd = "SELECT id, email, subject, content, updated_at "
                      "FROM drafts ORDER BY updated_at DESC LIMIT 1;";
        if (query.exec(cmd))
        {
            query.next();
            id = query.value(0).toString();
            email = query.value(1).toString();
            subject = query.value(2).toString();
            content = query.value(3).toString();
            updated_at = query.value(4).toString();
        }
        else
            qDebug() << "查询最新草稿失败：" << query.lastError().text();
    }
    // qDebug() << id << email << subject << content << updated_at;

    DraftObject *draftObject = new DraftObject(id, email, subject, content, updated_at);
    return draftObject;
}

/**
 * @brief 更新草稿
 * @param id 草稿 id
 * @return bool 是否成功
 */
bool User::updateDraft(const QString &id)
{
    QString cmd = "UPDATE drafts SET updated_at = CURRENT_TIMESTAMP "
                  "WHERE id = " +
                  id + ";";
    if (query.exec(cmd))
        qDebug() << "更新草稿成功！id：" << id;
    else
    {
        qDebug() << "更新草稿失败：" << query.lastError().text();
        return false;
    }
    return true;
}

/**
 * @brief 删除草稿
 * @param id 草稿 id
 */
bool User::deleteDraft(const QString &id)
{
    QString cmd = "DELETE FROM drafts WHERE id = " + id + ";";
    if (query.exec(cmd))
        qDebug() << "删除草稿成功！id：" << id;
    else
    {
        qDebug() << "删除草稿失败：" << query.lastError().text();
        return false;
    }
    return true;
}

/**
 * @brief 保存草稿
 * @param id 草稿 id
 * @param email 邮箱
 * @param subject 主题
 * @param content 内容
 * @return bool 是否成功
 */
bool User::saveDraft(const QString &id, const QString &email, const QString &subject, const QString &content)
{
    QString cmd = "UPDATE drafts SET email = '" + email +
                  "', subject = '" + subject +
                  "', content = '" + content +
                  "', updated_at = CURRENT_TIMESTAMP "
                  "WHERE id = " +
                  id + ";";
    if (query.exec(cmd))
        qDebug() << "保存草稿成功！id：" << id;
    else
    {
        qDebug() << "保存草稿失败：" << query.lastError().text();
        return false;
    }
    return true;
}

/**
 * @brief 获取邮件列表
 * @param page 页码
 * @param page_size 每页数量
 * @param filter 过滤条件
 */
QList<QObject *> User::getMails(int page, int page_size, const QString &filter)
{
    QList<QObject *> dataList;
    QString cmd = "SELECT id, email, subject, content, recieved_at, is_readed, is_starred, is_deleted "
                  "FROM mails WHERE " +
                  filter +
                  " AND user_id = (SELECT user_id FROM cur_user) "
                  "ORDER BY recieved_at DESC "
                  "LIMIT " +
                  QString::number(page_size) + " OFFSET " +
                  QString::number((page - 1) * page_size) + ";";
    if (query.exec(cmd))
    {
        while (query.next())
        {
            QString id = query.value(0).toString();
            QString email = query.value(1).toString();
            QString subject = query.value(2).toString();
            QString content = query.value(3).toString();
            QString recieved_at = query.value(4).toString();
            bool is_readed = query.value(5).toBool();
            bool is_starred = query.value(6).toBool();
            bool is_deleted = query.value(7).toBool();
            // qDebug() << id << email << subject << content << recieved_at << is_readed << is_starred << is_deleted;

            MailObject *mailObject = new MailObject(
                id, email, subject, content, recieved_at,
                is_readed, is_starred, is_deleted);
            dataList.append(mailObject);
        }
    }
    else
    {
        qDebug() << "查询失败：" << query.lastError().text();
    }
    return dataList;
}

/**
 * @brief 更新邮件
 * @param id 邮件 id
 * @param field 字段
 * @return bool 是否成功
 */
void User::updateMail(const QString &id, const QString &field)
{
    QString cmd = "UPDATE mails SET " + field + " = NOT " + field + " "
                  "WHERE id = " +
                  id + ";";
    if (query.exec(cmd))
        qDebug() << "更新邮件成功！id：" << id;
    else
        qDebug() << "更新邮件失败：" << query.lastError().text();
}
