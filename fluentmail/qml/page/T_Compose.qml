import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI
import "../component"

FluScrollablePage {
    title: lang.compose
    property var draft: {}

    Component.onCompleted: {
        draft = appInfo.user.getLatestDraft()
        textbox_email.text = draft.email
        textbox_subject.text = draft.subject
        textbox_content.text = draft.content
        textbox_email.focus = true
    }

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
                    id: textbox_email
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
                    id: textbox_subject
                    placeholderText: lang.subject_placeholder
                    Layout.fillWidth: true
                }
            }
            FluMultilineTextBox {
                id: textbox_content
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
            text: lang.new_draft
            onClicked: {
                draft = appInfo.user.getLatestDraft(true)
                showSuccess("新建成功")
                textbox_email.text = draft.email
                textbox_subject.text = draft.subject
                textbox_content.text = draft.content
                textbox_email.focus = true
            }
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
        }

        RowLayout {
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
            }
            spacing: 15
            FluTextButton {
                text: lang.save_to_drafts
                onClicked: {
                    appInfo.user.saveDraft(
                        draft.id,
                        textbox_email.text,
                        textbox_subject.text,
                        textbox_content.text
                    )
                    showSuccess("保存成功")
                }
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
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
