import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import "qrc:///FluentMail/qml/global/"
import FluentUI

FluScrollablePage{

    // 首页小板块（仅内容）
    ListModel{
        id:model_header
        ListElement{
            icon:"qrc:/FluentMail/res/image/ic_home_github.png"
            title:"FluentUI GitHub"
            desc:"The latest FluentUI controls and styles for your applications."
            url:"qrc:/FluentMail/qml/page/T_MailList.qml"
        }

        ListElement{
            icon:"qrc:/FluentMail/res/image/ic_home_github.png"
            title:"FluentUI GitHub"
            desc:"The latest FluentUI controls and styles for your applications."
            url:"qrc:/FluentMail/qml/page/T_MailList.qml"
        }
    }

    // 首页小板块（布局）
    Item{
        Layout.fillWidth: true
        height: 320
        // 图片
        Image {
            id: bg
            fillMode:Image.PreserveAspectCrop
            anchors.fill: parent
            verticalAlignment: Qt.AlignTop
            source: "qrc:/FluentMail/res/image/bg_home_header.png"
        }
        Rectangle{
            anchors.fill: parent
            gradient: Gradient{
                GradientStop { position: 0.8; color: FluTheme.dark ? Qt.rgba(0,0,0,0) : Qt.rgba(1,1,1,0) }
                GradientStop { position: 1.0; color: FluTheme.dark ? Qt.rgba(0,0,0,1) : Qt.rgba(238, 244, 249, 1) }
            }
            radius: 8
        }
        // 顶部文字
        FluText{
            text: lang.welcome
            font: FluTextStyle.TitleLarge
            anchors{
                top: parent.top
                left: parent.left
                topMargin: 20
                leftMargin: 20
            }
        }

        // 小板块
        ListView{
            id: list
            anchors{
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            orientation: ListView.Horizontal
            height: 240
            model: model_header // 引用之前的数据
            header: Item{height: 10;width: 10}
            footer: Item{height: 10;width: 10}
            ScrollBar.horizontal: FluScrollBar{
                id: scrollbar_header
            }
            clip: false
            delegate:Item{
                id: control
                width: 220
                height: 240
                FluArea{
                    radius: 8
                    width: 200
                    height: 220
                    anchors.centerIn: parent
                    color: 'transparent'
                    FluAcrylic {
                        sourceItem:bg
                        anchors.fill: parent
                        color: FluTheme.dark ? Window.active ?  Qt.rgba(38/255,44/255,54/255,1) : Qt.rgba(39/255,39/255,39/255,1) : Qt.rgba(251/255,251/255,253/255,1)
                        rectX: list.x-list.contentX+10+(control.width)*index
                        rectY: list.y+10
                        acrylicOpacity:0.8
                    }
                    Rectangle{
                        anchors.fill: parent
                        radius: 8
                        color:{
                            if(FluTheme.dark){
                                if(item_mouse.containsMouse){
                                    return Qt.rgba(1,1,1,0.03)
                                }
                                return Qt.rgba(0,0,0,0)
                            }else{
                                if(item_mouse.containsMouse){
                                    return Qt.rgba(0,0,0,0.03)
                                }
                                return Qt.rgba(0,0,0,0)
                            }
                        }
                    }

                    ColumnLayout{
                        Image {
                            Layout.topMargin: 20
                            Layout.leftMargin: 20
                            Layout.preferredWidth: 50
                            Layout.preferredHeight: 50
                            source: model.icon
                        }
                        FluText{
                            text: model.title
                            font: FluTextStyle.Body
                            Layout.topMargin: 20
                            Layout.leftMargin: 20
                        }
                        FluText{
                            text: model.desc
                            Layout.topMargin: 5
                            Layout.preferredWidth: 160
                            Layout.leftMargin: 20
                            color: FluColors.Grey120
                            font.pixelSize: 12
                            wrapMode: Text.WrapAnywhere
                        }
                    }
                    FluIcon{
                        iconSource: FluentIcons.OpenInNewWindow
                        iconSize: 15
                        anchors{
                            bottom: parent.bottom
                            right: parent.right
                            rightMargin: 10
                            bottomMargin: 10
                        }
                    }
                    MouseArea{
                        id:item_mouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onWheel: (wheel)=>{
                            if (wheel.angleDelta.y > 0) scrollbar_header.decrease()
                            else scrollbar_header.increase()
                        }
                        onClicked: {
                            navigationView.push(model.url)
                        }
                    }
                }
            }
        }
    }

    Component{
        id:com_item
        Item{
            width: 320
            height: 120
            FluArea{
                radius: 8
                width: 300
                height: 100
                anchors.centerIn: parent
                Rectangle{
                    anchors.fill: parent
                    radius: 8
                    color:{
                        if(FluTheme.dark){
                            if(item_mouse.containsMouse){
                                return Qt.rgba(1,1,1,0.03)
                            }
                            return Qt.rgba(0,0,0,0)
                        }else{
                            if(item_mouse.containsMouse){
                                return Qt.rgba(0,0,0,0.03)
                            }
                            return Qt.rgba(0,0,0,0)
                        }
                    }
                }
                Image{
                    id:item_icon
                    height: 40
                    width: 40
                    source: modelData.image
                    anchors{
                        left: parent.left
                        leftMargin: 20
                        verticalCenter: parent.verticalCenter
                    }
                }

                FluText{
                    id:item_title
                    text:modelData.title
                    font: FluTextStyle.BodyStrong
                    anchors{
                        left: item_icon.right
                        leftMargin: 20
                        top: item_icon.top
                    }
                }

                FluText{
                    id:item_desc
                    text:modelData.desc
                    color:FluColors.Grey120
                    wrapMode: Text.WrapAnywhere
                    elide: Text.ElideRight
                    font: FluTextStyle.Caption
                    maximumLineCount: 2
                    anchors{
                        left: item_title.left
                        right: parent.right
                        rightMargin: 20
                        top: item_title.bottom
                        topMargin: 5
                    }
                }

                Rectangle{
                    height: 12
                    width: 12
                    radius:  6
                    color: FluTheme.primaryColor.dark
                    anchors{
                        right: parent.right
                        top: parent.top
                        rightMargin: 14
                        topMargin: 14
                    }
                }

                MouseArea{
                    id:item_mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        ItemsOriginal.startPageByItem(modelData)
                    }
                }
            }
        }
    }

    // 第二块板块（功能）
    FluText{
        text: "Recently added samples"
        font: FluTextStyle.Title
        Layout.topMargin: 20
        Layout.leftMargin: 20
    }

    GridView{
        Layout.fillWidth: true
        implicitHeight: contentHeight
        cellHeight: 120
        cellWidth: 320
        model:ItemsOriginal.getRecentlyAddedData()
        interactive: false
        delegate: com_item
    }

    FluText{
        text: "Recently updated samples"
        font: FluTextStyle.Title
        Layout.topMargin: 20
        Layout.leftMargin: 20
    }

    GridView{
        Layout.fillWidth: true
        implicitHeight: contentHeight
        cellHeight: 120
        cellWidth: 320
        interactive: false
        model: ItemsOriginal.getRecentlyUpdatedData()
        delegate: com_item
    }

}
