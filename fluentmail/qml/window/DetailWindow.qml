import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import FluentUI
import "../component"

CustomWindow {

    id: window
    title: lang.mail_detail
    width: 750
    height: 580
    fixSize: true

    onInitArgument: (argument) => {
        subject.text = argument.subject
        email.text = argument.email
        content.text = argument.content
        received_at.text = argument.received_at
    }

    ColumnLayout {
        anchors{
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        // 标题
        FluText {
            id: subject
            text: ""
            font: FluTextStyle.Title
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 600
        }

        // 邮箱
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 600
            Layout.topMargin: 10
            Layout.bottomMargin: 1
            spacing: 10
            FluText {
                text: "From: "
                Layout.preferredWidth: 100
            }
            FluText {
                id: email
                text: ""
                Layout.alignment: Qt.AlignLeft
                Layout.preferredWidth: 200
            }
        }

        // 时间
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 600
            Layout.topMargin: 10
            Layout.bottomMargin: 1
            spacing: 10
            FluText {
                text: "Received at:"
                Layout.preferredWidth: 100
            }
            FluText {
                id: received_at
                text: ""
                Layout.alignment: Qt.AlignLeft
                Layout.preferredWidth: 200
            }
        }

        // 内容
        FluText {
            text: "Content:"
            Layout.topMargin: 10
            Layout.bottomMargin: 1
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 600
        }
        FluText {
            id: content
            text: ""
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 600
        }
    }
}
