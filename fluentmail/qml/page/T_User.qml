import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import "../component"

FluScrollablePage {
    title: "User"

    FluArea {
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 50
        paddings: 10

        FluText {
            text: "管理账户"
            font: FluTextStyle.BodyStrong
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            Layout.leftMargin: 5
        }

        Row {
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
            }
            FluFilledButton {
                text: "新增账号"
                onClicked: {
                    showSuccess("新增！")
                }
                Layout.alignment: Qt.AlignRight
            }
        }
    }

    // 自定义组件
    Component {
        id: com_item
        Item {
            width: 250
            height: 140
            FluArea {
                radius: 8
                width: 250
                height: 120
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
                // 标题
                FluText {
                    id: item_title
                    text: modelData.title
                    font: FluTextStyle.BodyStrong
                    anchors {
                        left: parent.left
                        leftMargin: 20
                        top: parent.top
                        topMargin: 15
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
                // 鼠标区域
                MouseArea {
                    id: item_mouse
                    anchors.fill: parent
                    hoverEnabled: true
                }
                // 按钮
                FluIconButton {
                    text: "删除"
                    iconSource: FluentIcons.Delete
                    onClicked: {
                        showWarning("已删除！")
                    }
                    anchors {
                        left: parent.left
                        leftMargin: 20
                        bottom: parent.bottom
                        bottomMargin: 15
                    }
                }
                FluFilledButton {
                    text: "切换"
                    onClicked: {
                        showSuccess("已切换！")
                    }
                    anchors {
                        right: parent.right
                        rightMargin: 20
                        bottom: parent.bottom
                        bottomMargin: 15
                    }
                }
            }
        }
    }

    // 切换账号
    GridView {
        Layout.topMargin: 10
        Layout.fillWidth: true
        implicitHeight: contentHeight
        cellHeight: 140
        cellWidth: 270
        model: [
            {
                title: "CWorld QQ Mail",
                desc: "cworld0@qq.com"
            },
            {
                title: "CWorld GMail",
                desc: "wolf0813cy@gmail.com"
            },
            {
                title: "CWorld Outlook",
                desc: "cworld0@outlook.com"
            },
        ]
        interactive: false
        delegate: com_item
    }
}
