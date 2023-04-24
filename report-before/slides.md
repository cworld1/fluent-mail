---
# try also 'default' to start simple
theme: seriph
# random image from a curated Unsplash collection by Anthony
# like them? see https://unsplash.com/collections/94734566/slidev
background: https://source.unsplash.com/collection/94734566/1920x1080
# apply any windi css classes to the current slide
class: "text-center"
# https://sli.dev/custom/highlighters.html
highlighter: shiki
# show line numbers in code blocks
lineNumbers: false
# some information about the slides, markdown enabled
info: |
  ## Slidev Starter Template
  Presentation slides for developers.

  Learn more at [Sli.dev](https://sli.dev)
# persist drawings in exports and build
drawings:
  persist: false
# page transition
transition: slide-left
# use UnoCSS
css: unocss
---

# 电子邮件系统开题报告

Presentation slides for developers

<div class="pt-12">
  <span @click="$slidev.nav.next" class="px-2 py-1 rounded cursor-pointer" hover="bg-white bg-opacity-10">
    Press Space for next page <carbon:arrow-right class="inline"/>
  </span>
</div>

<div class="abs-br m-6 flex gap-2">
  <button @click="$slidev.nav.openInEditor()" title="Open in Editor" class="text-xl slidev-icon-btn opacity-50 !border-none !hover:text-white">
    <carbon:edit />
  </button>
</div>

---
layout: image-left
image: https://source.unsplash.com/collection/94734566/1920x1080
---

# Table of contents

<Toc></Toc>

<style>
h1 {
  background-color: #2B90B6;
  background-image: linear-gradient(45deg, #4EC5D4 10%, #146b8c 20%);
  background-size: 100%;
  -webkit-background-clip: text;
  -moz-background-clip: text;
  -webkit-text-fill-color: transparent;
  -moz-text-fill-color: transparent;
}
</style>

---
transition: fade-out
---

# 研究背景和意义

### <carbon-recently-viewed /> 电子邮件的历史背景

电子邮件（E-mail）又称电子信箱、电子邮政，它是一种用现代网络技术提供信息交换的通信方式。它是因特网上使用最普遍的一项服务。这种非交互式的通信方式，加速了信息的交流及数据传送，它是一个简易、快速的方法。通过连接全世界的 Internet，实现各类信息的传送、接收、存贮等处理，将邮件送到世界的各个角落。电子邮件是 Internet 资源使用最多的一种服务，E-mail 不只局限于信件的传递，还可用来传递文件、声音及图片等不同类型的信息。

### <carbon-hybrid-networking-alt /> 电子邮件的工作

电子邮件是一种荐储转发式的服务，这正是电子信箱素统的核心：利用荐储转发可以实现非实时通信，属异步通信方式。即邮件发送者可以随时随地发送邮件，不需要接收者同时在场。即使対方现在不在，仍可将邮件立刻送到对方的信箱内，且存储在对方的电子邮箱中。收信人可以在他认为方便的时候收取信件，不受时问、地点的限制。在这里，“发送”邮件意味着将邮件放到收件人的信箱中，而“接收”邮件则是收信人从自已的信箱中读取信件，信箱实际上是由文件管理系统支持的一个实体。

---
layout: image-right
image: https://source.unsplash.com/collection/94734566/1920x1080
---

# 问题描述

对电子邮件系统进行添加账号、修改、查询、删除、发送、接收等管理。

<carbon-list /> 基本要求：

1. 考虑到课程设计特点，数据管理以文件加工形式，不考虑数据库后台管理和多用户并发操作。
2. 提供基本的邮件扫描搜索功能。
3. 可能需要提供：邮件模板功能、常用联系人存储功能、批量发送或转发功能。

---
layout: two-cols
transition: fade-out
---

# 系统设计

### <carbon-user-admin /> 用户身份与服务配置

在该系统中，用户可以通过配置 SMTP、IMAP。一旦用户配置成功后，他们可以访问收件箱和发件箱，以发送和接收电子邮件。

### <carbon-mail-all /> 邮件传输

该系统使用 SMTP 协议来进行电子邮件传输。当用户发送电子邮件时，该系统将连接到 SMTP 服务器并使用合适的身份验证来发送邮件。

::right::

<br />
<br />

### <carbon-db2-database /> 数据库设计

1. 认证表
2. 邮件表
3. 文件表
4. 联系人表
5. 日志表
6. 安全表
7. 统计表

---
layout: quote
---

# 数据结构图

展示系统的数据结构图。

<style>
h1 {
  background-color: #2B90B6;
  background-image: linear-gradient(45deg, #4EC5D4 10%, #146b8c 20%);
  background-size: 100%;
  -webkit-background-clip: text;
  -moz-background-clip: text;
  -webkit-text-fill-color: transparent;
  -moz-text-fill-color: transparent;
}
</style>

---
level: 2
---

# 功能模块结构图

<img src="/Drawing.png" class="h-100" />

---
level: 2
---

# 三层数据流图 - 顶层图

<img src="/Drawing2.png" class="m-15 h-60" />

---
level: 2
---

# 三层数据流图 - 0层图

<img src="/Drawing3.png" class="m-15 h-90" />

---
level: 2
---

# 三层数据流图 - 1层图

<img src="/Drawing4.png" class="m-15 h-90" />

---
transition: fade-out
---

# 系统实现

在该项目中，我们将使用C++和Qt库来实现电子邮件系统。

<carbon-roadmap /> 项目将使用以下技术：

- SMTP协议
- HTTPS协议
- 数据库管理系统
- LTS加密通讯技术
- Qt框架

---

# 研究方法

在该项目中，我们将采用如下步骤：

1. 设计系统架构和流程图。
2. 编写用户身份认证、邮件传输、数据库管理和加密等程序。
3. 实现开题报告编辑器和PDF输出程序。
4. 进行系统测试和优化，确保其性能和安全性。
5. 撰写课程设计报告并进行答辩。

---

# 参考文献

参考文献列表：

- Qt 官方文档：https://doc.qt.io/qt-5/index.html
- Qt 的邮件库类：https://doc.qt.io/qt-5/qmailtools-module.html
- PyQt 邮箱客户端示例代码：https://github.com/ma-ji/pyqt-mail-client
- 一个基于 Qt 的邮件客户端的教程：http://www.bogotobogo.com/Qt/Qt5_QtQuick2_MailClient_Tutorial_Part1.php
- C++ 的 SMTP 库：https://github.com/cutelyst/cutelyst/tree/master/examples/smtp
- 一个使用 C++ 和 Qt 编写的邮件客户端项目：https://github.com/silveiralexf/qt-mail-client

---
layout: fact
---

# Thank You

for your attention!
