import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import "../component"

FluScrollablePage {
    title: "Compose Email"

    FluArea {
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 450
        paddings: 10

        ColumnLayout {
            spacing: 10
            anchors.fill: parent

            RowLayout {
                FluText {
                    Layout.preferredWidth: 70
                    Layout.topMargin: 2
                    text: "To: "
                }
                FluTextBox {
                    placeholderText: "Email address"
                    Layout.fillWidth: true
                }
            }
            RowLayout {
                FluText {
                    Layout.preferredWidth: 70
                    Layout.topMargin: 2
                    text: "Subject: "
                }
                FluTextBox {
                    placeholderText: "Subject"
                    Layout.fillWidth: true
                }
            }
            FluMultilineTextBox {
                placeholderText: "Enter content"
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    FluArea {
        Layout.fillWidth: true
        Layout.topMargin: 10
        height: 50
        paddings: 10

        FluButton {
            text: "存到草稿箱"
            onClicked: {
                showWarning("草稿箱")
            }
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
        }

        Row {
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
            }
            FluFilledButton {
                text: "发送"
                onClicked: {
                    showSuccess("点击发送")
                }
                Layout.alignment: Qt.AlignRight
            }
        }
    }
}
