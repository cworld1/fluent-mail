pragma Singleton

import QtQuick
import FluentUI

FluObject {
    property var navigationView

    // 主页
    FluPaneItem {
        title: lang.home
        icon: FluentIcons.Home
        // cusIcon: Image {
        //     anchors.centerIn: parent
        //     source: FluTheme.dark ? "qrc:/fluentmail/res/svg/home_dark.svg" : "qrc:/fluentmail/res/svg/home.svg"
        //     sourceSize: Qt.size(30, 30)
        //     width: 18
        //     height: 18
        // }
        onTap: {
            navigationView.push("qrc:/fluentmail/qml/page/T_Home.qml")
        }
    }

    // 写邮件
    FluPaneItem {
        title: lang.compose
        icon: FluentIcons.Edit
        recentlyUpdated: true
        image: "qrc:/fluentmail/res/image/control/AutoSuggestBox.png"
        desc: "1982年，第一张电脑笑脸 : -) 诞生。今天，人们已经习惯用它来表达心情。尝试使用它吧！"
        onTap: {
            navigationView.push("qrc:/fluentmail/qml/page/T_Compose.qml")
        }
    }

    // 收件箱
    FluPaneItem {
        title: lang.inbox
        icon: FluentIcons.Mail
        recentlyUpdated: true
        image: "qrc:/fluentmail/res/image/control/CommandBarFlyout.png"
        desc: "1987年9月14日21时07分，中国第一封电子邮件从北京发往德国。“越过长城，走向世界。”"
        onTap: {
            navigationView.push("qrc:/fluentmail/qml/page/T_MailList.qml", {pane_title: lang.inbox})
        }
    }

    FluPaneItemSeparator {}

    // 星标邮件
    FluPaneItem {
        title: lang.starred
        icon: FluentIcons.FavoriteStar
        recentlyAdded: true
        order: 0
        image: "qrc:/fluentmail/res/image/control/StandardUICommand.png"
        desc: "点亮你的收件箱，点亮行迹与感动。"
        onTap: navigationView.push("qrc:/fluentmail/qml/page/T_MailList.qml", {pane_title: lang.starred})
    }

    // 已发送
    FluPaneItem {
        title: lang.sent
        icon: FluentIcons.Completed
        recentlyAdded: true
        order: 1
        image: "qrc:/fluentmail/res/image/control/Checkbox.png"
        desc: "信息已传递，等待远方回音。"
        onTap: navigationView.push("qrc:/fluentmail/qml/page/T_DraftList.qml", {pane_title: lang.sent})
    }

    // 草稿
    FluPaneItem {
        title: lang.drafts
        icon: FluentIcons.KnowledgeArticle
        recentlyAdded: true
        order: 2
        image: "qrc:/fluentmail/res/image/control/InkCanvas.png"
        desc: "你创造的创意沉淀之地，思绪的保留室。"
        onTap: navigationView.push("qrc:/fluentmail/qml/page/T_DraftList.qml", {pane_title: lang.drafts})
    }

    // 垃圾箱
    FluPaneItem {
        title: lang.deleted
        icon: FluentIcons.Delete
        recentlyAdded: true
        order: 3
        image: "qrc:/fluentmail/res/image/control/ParallaxView.png"
        desc: "垃圾箱，是一个不可逆的过程。"
        onTap: navigationView.push("qrc:/fluentmail/qml/page/T_MailList.qml", {pane_title: lang.deleted})
    }

    function getRecentlyAddedData()
    {
        var arr = []
        for (var i = 0; i < children.length; i++) {
            var item = children[i]
            if (item instanceof FluPaneItem && item.recentlyAdded)
            {
                arr.push(item)
            }
            if (item instanceof FluPaneItemExpander)
            {
                for (var j = 0; j < item.children.length; j++) {
                    var itemChild = item.children[j]
                    if (itemChild instanceof FluPaneItem && itemChild.recentlyAdded)
                    {
                        arr.push(itemChild)
                    }
                }
            }
        }
        arr.sort(function(o1, o2){ return o1.order - o2.order })
        return arr
    }

    function getRecentlyUpdatedData()
    {
        var arr = []
        var items = navigationView.getItems();
        for (var i = 0; i < items.length; i++) {
            var item = items[i]
            if (item instanceof FluPaneItem && item.recentlyUpdated)
            {
                arr.push(item)
            }
        }
        return arr
    }

    function getSearchData()
    {
        var arr = []
        var items = navigationView.getItems();
        for (var i = 0; i < items.length; i++) {
            var item = items[i]
            if (item instanceof FluPaneItem)
            {
                arr.push({title: item.title, key: item.key})
            }
        }
        return arr
    }

    function startPageByItem(data)
    {
        navigationView.startPageByItem(data)
    }

}
