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
                text: lang.manage_user_add
                font: FluTextStyle.Title
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.fillWidth: true
            }

            // 名称
            FluText {
                text: lang.user_name
                Layout.topMargin: 10
                Layout.bottomMargin: 1
            }
            FluTextBox {
                id: textbox_username
                placeholderText: lang.user_name_placeholder
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
            }

            // 邮箱
            FluText {
                text: lang.user_email
                Layout.topMargin: 10
                Layout.bottomMargin: 1
            }
            FluTextBox {
                id: textbox_email
                placeholderText: lang.user_email_placeholder
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
            }

            // 密码
            FluText {
                text: lang.user_password
                Layout.topMargin: 10
                Layout.bottomMargin: 1
            }
            FluTextBox {
                id: textbox_password
                placeholderText: lang.user_password_placeholder
                echoMode:TextInput.Password
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
            }

            // SMTP
            FluText {
                text: lang.user_smtp
                Layout.topMargin: 10
                Layout.bottomMargin: 1
            }
            RowLayout {
                spacing: 5
                FluTextBox {
                    id: smtp_host
                    placeholderText: lang.user_smtp_placeholder
                    Layout.fillWidth: true
                }
                FluAutoSuggestBox {
                    id: smtp_port
                    items: [ {title: "465"}, {title: "987"} ]
                    placeholderText: lang.user_port_placeholder
                    Layout.preferredWidth: 100
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // POP3
            FluText {
                text: lang.user_pop3
                Layout.topMargin: 10
                Layout.bottomMargin: 1
            }
            RowLayout {
                spacing: 5
                FluTextBox {
                    id: pop3_host
                    placeholderText: lang.user_pop3_placeholder
                    Layout.fillWidth: true
                }
                FluAutoSuggestBox {
                    id: pop3_port
                    items: [ {title: "465"}, {title: "987"} ]
                    placeholderText: lang.user_port_placeholder
                    Layout.preferredWidth: 100
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            FluFilledButton {
                text: lang.user_add_confirm
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
