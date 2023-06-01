import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import "../component"

FluScrollablePage {
    title: lang.compose

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
                    text: lang.to
                }
                FluTextBox {
                    placeholderText: lang.to_placeholder
                    Layout.fillWidth: true
                }
            }
            RowLayout {
                FluText {
                    Layout.preferredWidth: 70
                    Layout.topMargin: 2
                    text: lang.subject
                }
                FluTextBox {
                    placeholderText: lang.subject_placeholder
                    Layout.fillWidth: true
                }
            }
            FluMultilineTextBox {
                placeholderText: lang.content_placeholder
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
            text: lang.save_to_drafts
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
                text: lang.send
                onClicked: {
                    showSuccess("点击发送")
                }
                Layout.alignment: Qt.AlignRight
            }
        }
    }
}
