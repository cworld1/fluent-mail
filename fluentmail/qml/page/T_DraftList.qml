import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import "../component"

FluScrollablePage {
    property var dataSource: {}

    title: lang.drafts

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
        pageCount: 10
        itemCount: 200
        onRequestPage: (page,count) => {
                loadData(page,count)
            }
    }

    Component {
        id: com_action
        Item {
            Row {
                anchors.centerIn: parent
                spacing: 3
                FluIconButton {
                    iconSource: FluentIcons.Edit
                    text: "编辑"
                    onClicked: {
                        showSuccess("前往侧栏编辑！")
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
        dataSource = appInfo.user.getDrafts(page, count)
        for (let i = 0; i < dataSource.length; i++) {
            dataSource[i].action = com_action;
        }
        table_view.dataSource = dataSource
    }
}
