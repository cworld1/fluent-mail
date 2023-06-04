import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI
import "../component"

CustomWindow {
    id: window
    title: lang.about
    width: 600
    height: 400
    fixSize: true
    launchMode: FluWindow.SingleTask

    ColumnLayout {
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        RowLayout {
            Layout.topMargin: 20
            Layout.leftMargin: 15
            spacing: 14
            FluText {
                text: "Fluent Mail"
                font: FluTextStyle.Title
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        FluApp.navigate("/")
                    }
                }
            }
            FluText {
                text:"v%1".arg(appInfo.version)
                font: FluTextStyle.Body
                Layout.alignment: Qt.AlignBottom
            }
        }

        RowLayout {
            spacing: 14
            Layout.topMargin: 20
            Layout.leftMargin: 15
            FluText {
                text: "By: "
            }
            FluText {
                text:"CWorld"
                Layout.alignment: Qt.AlignBottom
            }
        }

        RowLayout {
            spacing: 14
            Layout.topMargin: 20
            Layout.leftMargin: 15
            FluText {
                text:"GitHub："
            }
            FluTextButton {
                id: text_link
                text: "https://github.com/cworld1/fluent-mail"
                Layout.alignment: Qt.AlignBottom
                onClicked: {
                    Qt.openUrlExternally(text_link.text)
                }
            }
        }

        RowLayout {
            spacing: 14
            Layout.leftMargin: 15
            Layout.topMargin: 20
            Layout.fillWidth: true
            FluText {
                id: text_desc
                text: "Fluent Mail is a simple mail client based on Qt and Fluent UI. \nIt is still in the early stages of development. \nIf you have any questions or suggestions, please contact me by email \nor submit an issue on GitHub."
            }
        }
    }
}
