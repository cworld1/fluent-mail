import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "qrc:///fluentmail/qml/global/"

FluScrollablePage {

    // 首页小板块（模板）
    Component {
        id: com_header
        Item {
            id: control
            width: 220
            height: 240
            FluArea {
                radius: 8
                width: 200
                height: 220
                anchors.centerIn: parent
                color: 'transparent'
                // 背景板
                FluAcrylic {
                    sourceItem: bg
                    anchors.fill: parent
                    color: FluTheme.dark ? Window.active ? Qt.rgba(38/255, 44/255, 54/255, 1) : Qt.rgba(39/255, 39/255, 39/255, 1) : Qt.rgba(251/255, 251/255, 253/255, 1)
                    rectX: list.x - list.contentX + 10 + (control.width) * index
                    rectY: list.y + 10
                    acrylicOpacity: 0.8
                }
                Rectangle {
                    anchors.fill: parent
                    radius: 8
                    color: {
                        if (item_mouse.containsMouse)
                            return FluTheme.dark ? Qt.rgba(1, 1, 1, 0.03) : Qt.rgba(0, 0, 0, 0.03)
                        else 
                            return Qt.rgba(0, 0, 0, 0)
                    }
                }
                // 内容
                ColumnLayout {
                    Image {
                        Layout.topMargin: 20
                        Layout.leftMargin: 20
                        Layout.preferredWidth: 50
                        Layout.preferredHeight: 50
                        source: modelData.image
                    }
                    FluText {
                        text: modelData.title
                        font: FluTextStyle.Body
                        Layout.topMargin: 20
                        Layout.leftMargin: 20
                    }
                    FluText {
                        text: modelData.desc
                        Layout.topMargin: 5
                        Layout.preferredWidth: 160
                        Layout.leftMargin: 20
                        color: FluColors.Grey120
                        font.pixelSize: 12
                        wrapMode: Text.WrapAnywhere
                    }
                }
                FluIcon {
                    iconSource: FluentIcons.OpenInNewWindow
                    iconSize: 15
                    anchors {
                        bottom: parent.bottom
                        right: parent.right
                        rightMargin: 10
                        bottomMargin: 10
                    }
                }
                MouseArea {
                    id: item_mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onWheel: (wheel) => {
                        if (wheel.angleDelta.y > 0) scrollbar_header.decrease()
                            else scrollbar_header.increase()
                    }
                    onClicked: {
                        ItemsOriginal.startPageByItem(modelData)
                    }
                }
            }
        }
    }

    // 首页小板块（真实功能布局）
    Item {
        Layout.fillWidth: true
        height: 320
        // 背景图片部分
        // 图片本身
        Image {
            id: bg
            fillMode: Image.PreserveAspectCrop
            anchors.fill: parent
            verticalAlignment: Qt.AlignTop
            source: "qrc:/fluentmail/res/image/bg_home_header.png"
        }
        // 图片底部渐变
        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.8; color: FluTheme.dark ? Qt.rgba(0, 0, 0, 0) : Qt.rgba(1, 1, 1, 0) }
                GradientStop {
                    position: 1.0
                    color: FluTheme.dark ? Qt.rgba(26/255, 34/255, 40/255, 1) : Qt.rgba(238/255, 244/255, 249/255, 1)
                }
            }
        }

        // 顶部文字
        FluText {
            text: lang.welcome
            font: FluTextStyle.TitleLarge
            anchors {
                top: parent.top
                left: parent.left
                topMargin: 20
                leftMargin: 20
            }
        }

        // 小板块
        ListView {
            id: list
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            orientation: ListView.Horizontal
            height: 240
            model: ItemsOriginal.getRecentlyUpdatedData() // 引用之前的数据
            header: Item { height: 10; width: 10 }
            footer: Item { height: 10; width: 10 }
            ScrollBar.horizontal: FluScrollBar {
                id: scrollbar_header
            }
            clip: false
            delegate: com_header
        }
    }

    // 次级小组件（模板）
    Component {
        id: com_item
        Item {
            width: 320
            height: 120
            FluArea {
                radius: 8
                width: 300
                height: 100
                anchors.centerIn: parent
                // 背景板
                Rectangle {
                    anchors.fill: parent
                    radius: 8
                    color: {
                        if (item_mouse.containsMouse)
                        {
                            if (FluTheme.dark)
                            {
                                return Qt.rgba(1, 1, 1, 0.03)
                            }
                            else {
                                return Qt.rgba(0, 0, 0, 0.03)
                            }
                        }
                        else {
                            return Qt.rgba(0, 0, 0, 0)
                        }
                    }
                }
                // 图标
                Image {
                    id: item_icon
                    height: 40
                    width: 40
                    source: modelData.image
                    anchors {
                        left: parent.left
                        leftMargin: 20
                        verticalCenter: parent.verticalCenter
                    }
                }
                // 标题
                FluText {
                    id: item_title
                    text: modelData.title
                    font: FluTextStyle.BodyStrong
                    anchors {
                        left: item_icon.right
                        leftMargin: 20
                        top: item_icon.top
                    }
                }
                // 描述
                FluText {
                    id: item_desc
                    text: modelData.desc
                    color: FluColors.Grey120
                    wrapMode: Text.WrapAnywhere
                    elide: Text.ElideRight
                    font: FluTextStyle.Caption
                    maximumLineCount: 2
                    anchors {
                        left: item_title.left
                        right: parent.right
                        rightMargin: 20
                        top: item_title.bottom
                        topMargin: 5
                    }
                }
                // 强迫症提示点
                Rectangle {
                    height: 12
                    width: 12
                    radius: 6
                    color: FluTheme.primaryColor.dark
                    anchors {
                        right: parent.right
                        top: parent.top
                        rightMargin: 14
                        topMargin: 14
                    }
                }
                // 点击事件
                MouseArea {
                    id: item_mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        ItemsOriginal.startPageByItem(modelData)
                    }
                }
            }
        }
    }

    // 次级小组件（真实功能布局）
    FluText {
        text: lang.common_use
        font: FluTextStyle.Title
        Layout.topMargin: 20
        Layout.leftMargin: 20
    }

    GridView {
        Layout.fillWidth: true
        implicitHeight: contentHeight
        cellHeight: 120
        cellWidth: 320
        model: ItemsOriginal.getRecentlyAddedData()
        interactive: false
        delegate: com_item
    }

    FluText {
        text: lang.recommend
        font: FluTextStyle.Title
        Layout.topMargin: 20
        Layout.leftMargin: 20
    }

    GridView {
        Layout.fillWidth: true
        implicitHeight: contentHeight
        cellHeight: 120
        cellWidth: 320
        interactive: false
        model: ItemsOriginal.getRecentlyUpdatedData()
        delegate: com_item
    }
}
