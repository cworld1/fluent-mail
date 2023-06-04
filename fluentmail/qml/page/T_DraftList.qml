import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import "../component"

FluScrollablePage {
    property var dataSource: []
    property string pane_title: ""

    title: pane_title

    Component.onCompleted: {
        const columns = [
            { title: '收件人', dataIndex: 'email', width: 150 },
            { title: '标题', dataIndex: 'subject', width: 110 },
            { title: '正文', dataIndex: 'content', width: 260 },
            { title: '操作', dataIndex: 'action', width: 60 },
            { title: '时间', dataIndex: 'updated_at', width: 90 }
        ];
        table_view.columns = columns
        loadData(1, 10)
    }

    FluTableView {
        id: table_view
        Layout.fillWidth: true
        Layout.topMargin: 20
        pageCurrent: 1
        pageCount: 5
        itemCount: 50
        onRequestPage: (page,count) => {
                loadData(page,count)
            }
    }

    Component {
        id: com_action_sents
        Item {
            Row {
                anchors.centerIn: parent
                spacing: 3
                FluIconButton {
                    iconSource: FluentIcons.Delete
                    text: "删除"
                    onClicked: {
                        if(appInfo.user.deleteDraft(dataObject.id)) {
                            showWarning("已删除！")
                            loadData(table_view.pageCurrent, table_view.pageCount)
                        }
                        else
                            showError("删除失败！")
                    }
                }
            }
        }
    }

    Component {
        id: com_action_drafts
        Item {
            Row {
                anchors.centerIn: parent
                spacing: 3
                FluIconButton {
                    iconSource: FluentIcons.Edit
                    text: "编辑"
                    onClicked: {
                        showInfo("前往侧栏编辑！")
                        appInfo.user.updateDraft(dataObject.id)
                        loadData(table_view.pageCurrent, table_view.pageCount)
                    }
                }
                FluIconButton {
                    iconSource: FluentIcons.Delete
                    text: "删除"
                    onClicked: {
                        if(appInfo.user.deleteDraft(dataObject.id)) {
                            showWarning("已删除！")
                            loadData(table_view.pageCurrent, table_view.pageCount)
                        }
                        else
                            showError("删除失败！")
                    }
                }
            }
        }
    }

    function loadData(page, count)
    {
        let filter = ""
        if (pane_title === lang.sent)
        {
            filter = "is_sent = 1 AND id IN (SELECT draft_id FROM sent WHERE user_id = " + appInfo.user.getCurUser() + ")"
            dataSource = appInfo.user.getDrafts(page, count, filter)
            for (let i = 0; i < dataSource.length; i++) {
                dataSource[i].action = com_action_sents;
            }
        }
        else if (pane_title === lang.drafts)
        {
            filter = "is_sent = 0"
            dataSource = appInfo.user.getDrafts(page, count, filter)
            for (let i = 0; i < dataSource.length; i++) {
                dataSource[i].action = com_action_drafts;
            }
        }
        table_view.dataSource = dataSource
    }
}
