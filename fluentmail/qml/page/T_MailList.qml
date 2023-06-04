import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import "../component"

FluScrollablePage {
    property var dataSource: []

    title: lang.inbox

    Component.onCompleted: {
        const columns = [
            { title: '已读', dataIndex: 'stats', width: 40 },
            { title: '发件人', dataIndex: 'email', width: 150 },
            { title: '标题', dataIndex: 'subject', width: 110 },
            { title: '正文', dataIndex: 'content', width: 220 },
            { title: '操作', dataIndex: 'action', width: 60 },
            { title: '时间', dataIndex: 'recieved_at', width: 90 }
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

    Component {
        id: com_readed
        Item {
            Row {
                anchors.centerIn: parent
                spacing: 3
                FluCheckBox {
                    checked: dataModel.is_readed
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
                    iconSource: dataModel.is_starred ? FluentIcons.FavoriteStarFill : FluentIcons.FavoriteStar
                    text: "星标"
                    onClicked: {
                        showSuccess("星标成功")
                        appInfo.user.updateMail(dataObject.id, "is_starred")
                        loadData(table_view.pageCurrent, table_view.pageCount)
                    }
                }
                FluIconButton {
                    iconSource: FluentIcons.Delete
                    text: "删除"
                    onClicked: {
                        showError(JSON.stringify(dataObject))
                    }
                }
            }
        }
    }

    function loadData(page, count)
    {
        dataSource = appInfo.user.getMails(page, count)
        for (let i = 0; i < dataSource.length; i++) {
            dataSource[i].stats = com_readed;
            dataSource[i].action = com_action;
        }
        table_view.dataSource = dataSource
    }
}
