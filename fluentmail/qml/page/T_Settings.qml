import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "qrc:///fluentmail/qml/global/"
import "../component"

FluScrollablePage {

    title:"Settings"

    // 卡片（深色模式）
    FluArea {
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 136
        paddings: 10

        ColumnLayout {
            spacing: 10
            anchors {
                top: parent.top
                left: parent.left
            }
            FluText {
                text: lang.dark_mode
                font: FluTextStyle.BodyStrong
                Layout.bottomMargin: 4
            }
            // 选项
            Repeater {
                model: [
                { title: lang.dark_mode_sys, mode: FluDarkMode.System },
                { title: lang.dark_mode_light, mode: FluDarkMode.Light },
                { title: lang.dark_mode_dark, mode: FluDarkMode.Dark }
                ]
                delegate: FluRadioButton {
                    selected : FluTheme.darkMode === modelData.mode
                    text: modelData.title
                    onClicked: {
                        FluTheme.darkMode = modelData.mode
                    }
                }
            }
        }
    }

    // 卡片（导航样式）
    FluArea {
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 168
        paddings: 10

        ColumnLayout {
            spacing: 10
            anchors {
                top: parent.top
                left: parent.left
            }

            FluText {
                text: lang.navigation_view
                font: FluTextStyle.BodyStrong
                Layout.bottomMargin: 4
            }
            Repeater {
                model: [
                    { title: lang.navigation_view_open, mode: FluNavigationView.Open },
                    { title: lang.navigation_view_compact, mode: FluNavigationView.Compact },
                    { title: lang.navigation_view_minimal, mode: FluNavigationView.Minimal },
                    { title: lang.navigation_view_auto, mode: FluNavigationView.Auto }
                ]
                delegate: FluRadioButton {
                    selected: MainEvent.displayMode === modelData.mode
                    text: modelData.title
                    onClicked: {
                        MainEvent.displayMode = modelData.mode
                    }
                }
            }
        }
    }

    // 卡片（语言）
    FluArea {
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 80
        paddings: 10

        ColumnLayout {
            spacing: 10
            anchors {
                top: parent.top
                left: parent.left
            }
            FluText {
                text: lang.locale
                font: FluTextStyle.BodyStrong
                Layout.bottomMargin: 4
            }
            // 横向布局
            Flow {
                spacing: 5
                Repeater {
                    model: ["Zh", "En"]
                    delegate: FluRadioButton {
                        selected: appInfo.lang.objectName === modelData
                        text: modelData
                        onClicked: {
                            console.debug(modelData)
                            appInfo.changeLang(modelData)
                        }
                    }
                }
            }
        }
    }

    // 测试
    FluArea {
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 80
        paddings: 10
        ColumnLayout {
            spacing: 10
            anchors {
                top: parent.top
                left: parent.left
            }
            FluText {
                text: lang.locale
                font: FluTextStyle.BodyStrong
                Layout.bottomMargin: 4
            }
            FluFilledButton {
                // anchors.centerIn: parent
                text:"Filled Button"
                onClicked: {
                    appInfo.buttonclick("Test")
                }
            }
        }
    }
}
