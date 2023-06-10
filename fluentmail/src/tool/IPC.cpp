#include "IPC.h"

#include <QCoreApplication>
#include <QDebug>
#include <QThread>
#include <ctime>
#include <random>

/*
    IPC（Inter-Process Communication，进程间通信）是指在不同进程之间进行数据交换和协调
    的机制。它可以让多个进程之间共享信息、资源和状态，从而实现更加复杂的应用程序。
    常见的 IPC 机制包括管道、消息队列、共享内存和套接字等。这些机制提供了不同的方式来传递数据，
    比如有些机制是基于文件描述符的（如管道），有些则是基于命名对象的（如消息队列）。
    选择合适的 IPC 机制取决于具体的应用场景和需求。
*/

// 部分代码参考自 https://github.com/qTox/qTox/blob/master/src/ipc.cpp
/*
    Copyright © 2014-2019 by The qTox Project Contributors

    This file is part of qTox, a Qt-based graphical interface for Tox.

    qTox is libre software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    qTox is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with qTox.  If not, see <http://www.gnu.org/licenses/>.
*/

/**
 * @class IPC
 * @brief 进程间通信
 */
IPC::IPC(uint32_t profileId)
    : // 保存 profileId
      profileId{profileId},
      // 创建 ipc-IPC_PROTOCOL_VERSION 共享内存对象并分配给类成员变量 globalMemory
      globalMemory{"ipc-" IPC_PROTOCOL_VERSION}
{
    qRegisterMetaType<IPCEventHandler>("IPCEventHandler"); // Qt元类型注册
    timer.setInterval(EVENT_TIMER_MS);                     // 设置定时器间隔
    timer.setSingleShot(true);                             // 设置定时器只触发一次
    connect(&timer, &QTimer::timeout, this, &IPC::processEvents);
    // 利用随机数引擎生成一个随机数作为 globalId (uint64_t)
    std::default_random_engine randEngine((std::random_device())());
    std::uniform_int_distribution<uint64_t> distribution;
    globalId = distribution(randEngine);
    qDebug() << "Our global IPC ID is " << globalId;

    if (globalMemory.create(sizeof(IPCMemory))) // 成功创建共享内存对象
    {
        if (globalMemory.lock())
        {
            // 填充IPC内存结构体
            IPCMemory *mem = global();
            memset(mem, 0, sizeof(IPCMemory));
            mem->globalId = globalId;
            mem->lastProcessed = time(nullptr);
            globalMemory.unlock(); // 释放内存锁
        }
        else
        {
            qWarning() << "Couldn't lock to take ownership";
        }
    }
    else if (globalMemory.attach())
    {
        qDebug() << "Attaching to the global shared memory";
    }
    else
    {
        qDebug() << "Failed to attach to the global shared memory, giving up. Error:"
                 << globalMemory.error();
        return;
    }

    // 开始处理IPC事件
    processEvents();
}

/**
 * @brief IPC 析构函数。在摧毁时自动调用。
 */
IPC::~IPC()
{
    if (!globalMemory.lock())
    {
        qWarning() << "Failed to lock in ~IPC";
        return;
    }

    if (isCurrentOwnerNoLock())
    {
        global()->globalId = 0;
    }
    // 释放内存锁
    globalMemory.unlock();
}

/**
 * @brief 发布 IPC 事件。
 * @param name 要在 IPC 事件中设置的名称。
 * @param data 要在 IPC 事件中设置的数据（default QByteArray()）。
 * @param dest Settings::getCurrentProfileId() or 0 (main instance, default)。
 * @return 事件完成的时间 or 错误 0。
 */
time_t IPC::postEvent(const QString &name, const QByteArray &data, uint32_t dest)
{
    // 检查数据长度是否超过限制
    QByteArray binName = name.toUtf8();
    if (binName.length() > (int32_t)sizeof(IPCEvent::name))
    {
        return 0;
    }
    if (data.length() > (int32_t)sizeof(IPCEvent::data))
    {
        return 0;
    }

    // 锁定共享内存
    if (!globalMemory.lock())
    {
        qDebug() << "Failed to lock in postEvent()";
        return 0;
    }

    IPCEvent *evt = nullptr;
    IPCMemory *mem = global();
    time_t result = 0;

    for (uint32_t i = 0; !evt && i < EVENT_QUEUE_SIZE; ++i)
    {
        if (mem->events[i].posted == 0)
        {
            evt = &mem->events[i];
        }
    }

    if (evt)
    {
        memset(evt, 0, sizeof(IPCEvent));
        memcpy(evt->name, binName.constData(), binName.length());
        memcpy(evt->data, data.constData(), data.length());
        mem->lastEvent = evt->posted = result = qMax(mem->lastEvent + 1, time(nullptr));
        evt->dest = dest;
        evt->sender = qApp->applicationPid();
        qDebug() << "postEvent " << name << "to" << dest;
    }
    globalMemory.unlock();
    return result;
}

/**
 * @brief 检查当前进程是否是 IPC 共享内存的所有者。
 * @return 如果当前进程是所有者，则返回 true，否则返回 false。
 */
bool IPC::isCurrentOwner()
{
    if (globalMemory.lock())
    {
        const bool isOwner = isCurrentOwnerNoLock();
        globalMemory.unlock();
        return isOwner;
    }
    else
    {
        qWarning() << "isCurrentOwner failed to lock, returning false";
        return false;
    }
}

/**
 * @brief 注册 IPC 事件的处理程序
 * @param handler 处理程序回调。最坏情况下不应阻塞超过一秒钟
 */
void IPC::registerEventHandler(const QString &name, IPCEventHandler handler)
{
    eventHandlers[name] = handler;
}

bool IPC::isEventAccepted(time_t time)
{
    bool result = false;
    if (!globalMemory.lock())
    {
        return result;
    }

    if (difftime(global()->lastProcessed, time) > 0)
    {
        IPCMemory *mem = global();
        for (uint32_t i = 0; i < EVENT_QUEUE_SIZE; ++i)
        {
            if (mem->events[i].posted == time && mem->events[i].processed)
            {
                result = mem->events[i].accepted;
                break;
            }
        }
    }
    globalMemory.unlock();

    return result;
}

bool IPC::waitUntilAccepted(time_t postTime, int32_t timeout /*=-1*/)
{
    bool result = false;
    time_t start = time(nullptr);
    forever
    {
        result = isEventAccepted(postTime);
        if (result || (timeout > 0 && difftime(time(nullptr), start) >= timeout))
        {
            break;
        }

        qApp->processEvents();
        QThread::msleep(0);
    }
    return result;
}

bool IPC::isAttached() const
{
    return globalMemory.isAttached();
}

void IPC::setProfileId(uint32_t profileId)
{
    this->profileId = profileId;
}

/**
 * @brief 仅在**全局内存锁定**时调用。
 * @return 如果不存在任何事件，则为空指针，否则为 IPC 事件
 */
IPC::IPCEvent *IPC::fetchEvent()
{
    IPCMemory *mem = global();
    for (uint32_t i = 0; i < EVENT_QUEUE_SIZE; ++i)
    {
        IPCEvent *evt = &mem->events[i];
        // 如果事件已经处理或者事件已经过期（检查是否需要进行垃圾回收（GC））
        if ((evt->processed && difftime(time(nullptr), evt->processed) > EVENT_GC_TIMEOUT) || (!evt->processed && difftime(time(nullptr), evt->posted) > EVENT_GC_TIMEOUT))
        {
            memset(evt, 0, sizeof(IPCEvent));
        }

        /* 要求：
          - 已经发布（posted）
          - 尚未被处理（!processed）
          - 发送者不是当前应用程序的PID（即不是自己发给自己）
          - 目的地是当前进程 / 目的地为0且当前没有其他进程持有锁定（isCurrentOwnerNoLock()）
        */
        if (evt->posted && !evt->processed && evt->sender != qApp->applicationPid() && (evt->dest == profileId || (evt->dest == 0 && isCurrentOwnerNoLock())))
        {
            return evt;
        }
    }

    return nullptr;
}

// 运行事件处理程序
bool IPC::runEventHandler(IPCEventHandler handler, const QByteArray &arg)
{
    bool result = false;
    if (QThread::currentThread() == qApp->thread())
    {
        result = handler(arg);
    }
    else
    {
        QMetaObject::invokeMethod(this, "runEventHandler", Qt::BlockingQueuedConnection,
                                  Q_RETURN_ARG(bool, result), Q_ARG(IPCEventHandler, handler),
                                  Q_ARG(const QByteArray &, arg));
    }
    return result;
}

// 处理事件
void IPC::processEvents()
{
    if (!globalMemory.lock())
    {
        timer.start();
        return;
    }

    IPCMemory *mem = global();

    if (mem->globalId == globalId)
    {
        // We're the owner, let's process those events
        mem->lastProcessed = time(nullptr);
    }
    else
    {
        // Only the owner processes events. But if the previous owner's dead, we can take
        // ownership now
        if (difftime(time(nullptr), mem->lastProcessed) >= OWNERSHIP_TIMEOUT_S)
        {
            qDebug() << "Previous owner timed out, taking ownership" << mem->globalId << "->"
                     << globalId;
            // Ignore events that were not meant for this instance
            memset(mem, 0, sizeof(IPCMemory));
            mem->globalId = globalId;
            mem->lastProcessed = time(nullptr);
        }
        // Non-main instance is limited to events destined for specific profile it runs
    }

    while (IPCEvent *evt = fetchEvent())
    {
        QString name = QString::fromUtf8(evt->name);
        auto it = eventHandlers.find(name);
        if (it != eventHandlers.end())
        {
            evt->accepted = runEventHandler(it.value(), evt->data);
            qDebug() << "Processed event:" << name << "posted:" << evt->posted
                     << "accepted:" << evt->accepted;
            if (evt->dest == 0)
            {
                // Global events should be processed only by instance that accepted event.
                // Otherwise global
                // event would be consumed by very first instance that gets to check it.
                if (evt->accepted)
                {
                    evt->processed = time(nullptr);
                }
            }
            else
            {
                evt->processed = time(nullptr);
            }
        }
        else
        {
            qDebug() << "Received event:" << name << "without handler";
            qDebug() << "Available handlers:" << eventHandlers.keys();
        }
    }

    globalMemory.unlock();
    timer.start();
}

/**
 * @brief 仅在**全局内存锁定**时调用。
 * @return 如果所有者 true，不是所有者或错误 false
 */
bool IPC::isCurrentOwnerNoLock()
{
    const void *const data = globalMemory.data();
    if (!data)
    {
        qWarning() << "isCurrentOwnerNoLock failed to access the memory, returning false";
        return false;
    }
    return (*static_cast<const uint64_t *>(data) == globalId);
}

IPC::IPCMemory *IPC::global()
{
    return static_cast<IPCMemory *>(globalMemory.data());
}
