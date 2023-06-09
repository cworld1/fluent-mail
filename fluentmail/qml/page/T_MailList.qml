import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import "../component"

FluScrollablePage {
    property var detailPageRegister: registerForWindowResult("/detail")
    property var dataSource: []
    property var pane_title: ""

    title: pane_title

    Component.onCompleted: {
        const columns = [
            { title: '已读', dataIndex: 'stats', width: 40 },
            { title: '发件人', dataIndex: 'email', width: 150 },
            { title: '标题', dataIndex: 'subject', width: 110 },
            { title: '正文', dataIndex: 'content', width: 190 },
            { title: '时间', dataIndex: 'received_at', width: 90 },
            { title: '操作', dataIndex: 'action', width: 90 }
        ];
        table_view.columns = columns
        loadData(1, 10)
    }

    FluTableView {
        id: table_view
        Layout.fillWidth: true
        Layout.topMargin: 20
        pageCurrent: 1
        pageCount: 10
        itemCount: 1000
        onRequestPage: (page,count)=> {
                loadData(page,count)
            }
    }

    FluIconButton {
        iconSource: FluentIcons.Refresh
        text: "刷新邮件"
        Layout.alignment: Qt.AlignRight
        onClicked: {
            let success = true
            if(!appInfo.server.pop3Init())
            {
                showError("配置失败")
            }
            for(let i = 1; i <= 10; i++)
            {
                if(!appInfo.user.addMail(
                        appInfo.server.pop3Get(i)
                    ))
                {
                    showError("刷新失败")
                    success = false
                }
            }
            if(success)
            {
                showSuccess("刷新成功")
            }
            loadData(table_view.pageCurrent, table_view.pageCount)
            if(!appInfo.server.pop3Quit())
            {
                showError("退出失败")
            }
        }
    }

    Component {
        id: com_readed
        Item {
            Row {
                anchors.centerIn: parent
                spacing: 3
                FluCheckBox {
                    checked: dataModel.is_readed
                    onClicked: {
                        appInfo.user.updateMail(dataObject.id, "is_readed")
                        showSuccess("操作成功")
                        loadData(table_view.pageCurrent, table_view.pageCount)
                    }
                }
            }
        }
    }

    Component {
        id: com_action
        Item {
            Row {
                anchors.centerIn: parent
                spacing: 3
                FluIconButton {
                    iconSource: FluentIcons.FullScreen
                    text: "查看"
                    onClicked: {
                        detailPageRegister.launch({
                            email: dataObject.email,
                            subject: dataObject.subject,
                            content: dataObject.content,
                            received_at: dataObject.received_at
                        })
                    }
                }
                FluIconButton {
                    iconSource: dataModel.is_starred ? FluentIcons.FavoriteStarFill : FluentIcons.FavoriteStar
                    text: "星标"
                    onClicked: {
                        appInfo.user.updateMail(dataObject.id, "is_starred")
                        showSuccess("操作成功")
                        loadData(table_view.pageCurrent, table_view.pageCount)
                    }
                }
                FluIconButton {
                    iconSource: FluentIcons.Delete
                    text: "删除"
                    onClicked: {
                        appInfo.user.updateMail(dataObject.id, "is_deleted")
                        showWarning("删除成功")
                        loadData(table_view.pageCurrent, table_view.pageCount)
                    }
                }
            }
        }
    }

    function loadData(page, count)
    {
        let filter = ""
        if (pane_title === lang.inbox) {
            filter = "is_deleted = 0"
        }
        else if (pane_title === lang.deleted) {
            filter = "is_deleted = 1"
        }
        else if (pane_title === lang.starred) {
            filter = "is_starred = 1 AND is_deleted = 0"
        }
        else {
            filter = ""
        }

        dataSource = appInfo.user.getMails(page, count, filter)
        for (let i = 0; i < dataSource.length; i++) {
            dataSource[i].stats = com_readed;
            dataSource[i].action = com_action;
        }
        table_view.dataSource = dataSource
    }
}
