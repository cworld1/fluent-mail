import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import "../component"

FluScrollablePage {
    property var loginPageRegister: registerForWindowResult("/login")
    property var users_model: {}

    title: lang.user

    Connections {
        target: loginPageRegister
        function onResult(data)
        {
            if(appInfo.user.addUser(
                data.name, data.email, data.passwd, 
                data.smtp, data.smtp_port,
                data.pop3, data.pop3_port
            ))
            {
                showSuccess("添加成功！")
            }
            else {
                showError("添加失败！")
            }
        }
    }

    Component.onCompleted: {
        users_model = appInfo.user.getUsers()
    }

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
                    loginPageRegister.launch({
                        smtp_port: 465,
                        pop3_port: 995,
                    })
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
                            if (FluTheme.dark) return Qt.rgba(1, 1, 1, 0.03)
                                else return Qt.rgba(0, 0, 0, 0.03)
                        }
                        else {
                            return Qt.rgba(0, 0, 0, 0)
                        }
                    }
                }
                // 标题
                FluText {
                    id: item_name
                    text: modelData.name
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
                    id: item_email
                    text: modelData.email
                    color: FluColors.Grey120
                    wrapMode: Text.WrapAnywhere
                    elide: Text.ElideRight
                    font: FluTextStyle.Caption
                    maximumLineCount: 2
                    anchors {
                        left: item_name.left
                        right: parent.right
                        rightMargin: 20
                        top: item_name.bottom
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
                        double_btn_dialog.open()
                    }
                    anchors {
                        left: parent.left
                        leftMargin: 20
                        bottom: parent.bottom
                        bottomMargin: 15
                    }
                }
                // 二次确认
                FluContentDialog{
                    id: double_btn_dialog
                    title: "Tip"
                    message:"Are you sure to delete this user?"
                    buttonFlags: FluContentDialog.NegativeButton | FluContentDialog.PositiveButton
                    negativeText: "Cancel"
                    onNegativeClicked: {
                        showError("取消删除！")
                    }
                    positiveText: "Delete"
                    onPositiveClicked:{
                        if (appInfo.user.delUser(modelData.id) === false) {
                            showError("删除失败！")
                        }
                        else
                        {
                            showWarning("已删除！")
                            users_model = appInfo.user.getUsers()
                        }
                    }
                }
                FluFilledButton {
                    id: btn_switch
                    text: "切换"
                    disabled: modelData.isCurUser
                    onClicked: {
                        if (appInfo.user.setUser(modelData.id) === false) {
                            showError("切换失败！")
                        }
                        else {
                            showSuccess("已切换！")
                            users_model = appInfo.user.getUsers()
                        }
                    }
                    anchors {
                        right: parent.right
                        rightMargin: 20
                        bottom: parent.bottom
                        bottomMargin: 15
                    }
                }
            }

            // 绑定按钮
            property var switchButton: btn_switch
        }
    }

    // 切换账号
    GridView {
        id: users_grid
        Layout.topMargin: 10
        Layout.fillWidth: true
        implicitHeight: contentHeight
        cellHeight: 140
        cellWidth: 270
        model: users_model
        interactive: false
        delegate: com_item
    }
}
