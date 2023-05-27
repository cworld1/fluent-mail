#ifndef IPC_H
#define IPC_H

#include <QMap>
#include <QObject>
#include <QSharedMemory>
#include <QTimer>
#include <ctime>
#include <functional>

// 回调函数
using IPCEventHandler = std::function<bool(const QByteArray &)>;

#define IPC_PROTOCOL_VERSION "1"

class IPC : public QObject
{
    Q_OBJECT

protected:
    static const int EVENT_TIMER_MS = 1000;
    static const int EVENT_GC_TIMEOUT = 5;
    static const int EVENT_QUEUE_SIZE = 32; // 事件队列大小
    static const int OWNERSHIP_TIMEOUT_S = 5;

public:
    IPC(uint32_t profileId);
    ~IPC();

    struct IPCEvent
    {
        uint32_t dest;  // 目标
        int32_t sender; // 发送者
        char name[16];
        char data[128];
        time_t posted;    // 发布时间
        time_t processed; // 处理时间
        uint32_t flags;
        bool accepted;
        bool global;
    };

    struct IPCMemory
    {
        uint64_t globalId; // 全局ID
        time_t lastEvent;
        time_t lastProcessed;
        IPCEvent events[IPC::EVENT_QUEUE_SIZE]; // 事件队列
    };

    // 将一个事件发送给指定的进程
    time_t postEvent(const QString &name,                   // 事件名称
                     const QByteArray &data = QByteArray(), // 事件数据
                     uint32_t dest = 0);                    // 目标进程ID
    // 检查当前进程是否拥有 IPC 的所有权
    bool isCurrentOwner();
    // 注册事件处理函数
    void registerEventHandler(const QString &name, IPCEventHandler handler);
    bool isEventAccepted(time_t time);
    // 等待指定时间戳的事件被处理
    bool waitUntilAccepted(time_t time, int32_t timeout = -1);
    bool isAttached() const;

public slots:
    void setProfileId(uint32_t profileId);

private:
    // 获取全局 IPC 内存对象
    IPCMemory *global();
    bool runEventHandler(IPCEventHandler handler, const QByteArray &arg);
    IPCEvent *fetchEvent();
    // 处理事件队列中的所有事件
    void processEvents();
    bool isCurrentOwnerNoLock();

private:
    QTimer timer;
    uint64_t globalId;
    uint32_t profileId;         // 与该 IPC 实例相关联的进程 ID
    QSharedMemory globalMemory; // 全局内存
    QMap<QString, IPCEventHandler> eventHandlers;
};

#endif // IPC_H
