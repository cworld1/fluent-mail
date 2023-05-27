import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import "../component"

FluScrollablePage{

    title:"Mail List"

    Component.onCompleted: {
        const columns = [
                          {
                              title: '状态',
                              dataIndex: 'stats',
                              width:50
                          },
                          {
                              title: '标题',
                              dataIndex: 'title',
                              width:150
                          },
                          {
                              title: '正文',
                              dataIndex: 'detail',
                              width:280
                          },
                          {
                              title: '操作',
                              dataIndex: 'action',
                              width:100
                          },
                          {
                              title: '时间',
                              dataIndex: 'time',
                              width:80
                          },
                      ];
        table_view.columns = columns
        loadData(1,10)
    }

    FluTableView{
        id:table_view
        Layout.fillWidth: true
        Layout.topMargin: 20
        pageCurrent:1
        pageCount:10
        itemCount: 1000
        onRequestPage:
            (page,count)=> {
                loadData(page,count)
            }
    }

    Component{
        id:com_action
        Item{
            Row{
                anchors.centerIn: parent
                spacing: 10
                FluFilledButton{
                    text:"编辑"
                    horizontalPadding: 6
                    onClicked:{
                        showSuccess(JSON.stringify(dataObject))
                    }
                }
                FluFilledButton{
                    text:"删除"
                    horizontalPadding: 6
                    onClicked:{
                        showError(JSON.stringify(dataObject))
                    }
                }
            }
        }
    }

    function loadData(page,count){
        const dataSource = []
        for(var i=0;i<count;i++){
            dataSource.push({
                                stats: "已读",
                                title: "第%1封信件".arg((page-1)*count+i+1),
                                detail: "这是一封新邮件",
                                action: com_action,
                                time: "05/22"
                            })
        }
        table_view.dataSource = dataSource
    }
}
