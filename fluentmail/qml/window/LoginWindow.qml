import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI
import "../component"

CustomWindow {

    id: window
    title: lang.user
    width: 950
    height: 580
    fixSize: true
    launchMode: FluWindow.SingleTask

    onInitArgument: (argument) => {
        smtp_port.updateText(argument.smtp_port)
        pop3_port.updateText(argument.pop3_port)
        textbox_username.focus = true
    }
    RowLayout {
        anchors.fill: parent
        spacing: 50

        // 轮播图
        FluCarousel {
            width: 400
            height: 480
            loopTime: 3000
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: 70
            Layout.horizontalStretchFactor: 2
            Layout.fillWidth: true
            Component.onCompleted: {
                setData([
                    { url: "qrc:/fluentmail/res/image/banner_1.jpg" },
                    { url: "qrc:/fluentmail/res/image/banner_2.jpg" },
                    { url: "qrc:/fluentmail/res/image/banner_3.jpg" }
                ])
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignRight
            Layout.rightMargin: 70
            Layout.horizontalStretchFactor: 3
            Layout.fillWidth: true

            // 标题
            FluText {
                text: "Add user"
                font: FluTextStyle.Title
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.fillWidth: true
            }

            // 名称
            FluText {
                Layout.topMargin: 10
                Layout.bottomMargin: 1
                text: "Name"
            }
            FluTextBox {
                id: textbox_username
                placeholderText: "Name"
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
            }

            // 邮箱
            FluText {
                text: "Email"
                Layout.topMargin: 10
                Layout.bottomMargin: 1
            }
            FluTextBox {
                id: textbox_email
                placeholderText: "Email"
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
            }

            // 密码
            FluText {
                text: "Password"
                Layout.topMargin: 10
                Layout.bottomMargin: 1
            }
            FluTextBox {
                id: textbox_password
                placeholderText: "请输入密码"
                echoMode:TextInput.Password
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
            }

            // SMTP
            FluText {
                text: "SMTP"
                Layout.topMargin: 10
                Layout.bottomMargin: 1
            }
            RowLayout {
                spacing: 5
                FluTextBox {
                    id: smtp_host
                    placeholderText: "SMTP Site"
                    Layout.fillWidth: true
                }
                FluAutoSuggestBox {
                    id: smtp_port
                    items: [ {title: "465"}, {title: "987"} ]
                    placeholderText: "Port"
                    Layout.preferredWidth: 100
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // POP3
            FluText {
                text: "POP3"
                Layout.topMargin: 10
                Layout.bottomMargin: 1
            }
            RowLayout {
                spacing: 5
                FluTextBox {
                    id: pop3_host
                    placeholderText: "POP3 Site"
                    Layout.fillWidth: true
                }
                FluAutoSuggestBox {
                    id: pop3_port
                    items: [ {title: "465"}, {title: "987"} ]
                    placeholderText: "Port"
                    Layout.preferredWidth: 100
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            FluFilledButton {
                text: "登录"
                Layout.alignment: Qt.AlignRight
                Layout.topMargin: 20
                onClicked: {
                    if(textbox_username.text === ""
                        || textbox_email.text === ""
                        || textbox_password.text === ""
                        || smtp_host.text === ""
                        || smtp_port.text === ""
                        || pop3_host.text === ""
                        || pop3_port.text === "") {
                        showError("请完整输入信息")
                        return
                    }
                    onResult({
                        name: textbox_username.text,
                        email: textbox_email.text,
                        passwd: textbox_password.text,
                        smtp: smtp_host.text,
                        smtp_port: smtp_port.text,
                        pop3: pop3_host.text,
                        pop3_port: pop3_port.text
                    })
                    window.close()
                }
            }
        }
    }
}
