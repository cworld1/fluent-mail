import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI
import "qrc:///fluentmail/qml/global/"
import "../component"

FluScrollablePage {

    title:"Settings"

    // 卡片（主题色）
    FluArea {
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 136
        paddings: 10

        ColumnLayout {
            spacing: 10
            anchors {
                left: parent.left
            }
            FluText {
                text: lang.theme_color
                font: FluTextStyle.BodyStrong
                Layout.bottomMargin: 4
            }
            RowLayout {
                Repeater {
                    model: [
                        FluColors.Yellow,
                        FluColors.Orange,
                        FluColors.Red,
                        FluColors.Magenta,
                        FluColors.Purple,
                        FluColors.Blue,
                        FluColors.Teal,
                        FluColors.Green
                    ]
                    delegate: FluRectangle {
                        width: 42
                        height: 42
                        radius: [5,5,5,5]
                        color: mouse_item.containsMouse ? Qt.lighter(modelData.normal,1.1) : modelData.normal
                        FluIcon {
                            anchors.centerIn: parent
                            iconSource: FluentIcons.AcceptMedium
                            iconSize: 15
                            visible: modelData === FluTheme.primaryColor
                            color: FluTheme.dark ? Qt.rgba(0,0,0,1) : Qt.rgba(1,1,1,1)
                        }
                        MouseArea {
                            id: mouse_item
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                FluTheme.primaryColor = modelData
                            }
                        }
                    }
                }
            }
            FluToggleSwitch {
                text: lang.theme_render_native
                Layout.topMargin: 5
                checked: FluTheme.nativeText
                onClicked: {
                    FluTheme.nativeText = !FluTheme.nativeText
                }
            }
        }
    }

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
                    checked: FluTheme.darkMode === modelData.mode
                    text: modelData.title
                    clickListener: function() {
                        FluTheme.darkMode = modelData.mode
                    }
                }
            }
        }
    }

    // 卡片（导航样式）
    FluArea {
        Layout.fillWidth: true
        Layout.topMargin: 10
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
                    checked: MainEvent.displayMode === modelData.mode
                    text: modelData.title
                    clickListener: function() {
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
                        checked: appInfo.lang.objectName === modelData
                        text: modelData
                        clickListener: function(){
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
        Layout.topMargin: 30
        height: 80
        paddings: 10
        ColumnLayout {
            spacing: 10
            anchors {
                top: parent.top
                left: parent.left
            }
            FluText {
                text: "Test"
                font: FluTextStyle.BodyStrong
                Layout.bottomMargin: 4
            }
            RowLayout {
                FluFilledButton {
                    text: "About"
                    onClicked: {
                        FluApp.navigate("/about")
                    }
                }
                FluTextBox {
                    id: textbox_count
                    placeholderText: "Count"
                    Layout.preferredWidth: 50
                }
                FluFilledButton {
                    text: "Pop3Init"
                    onClicked: {
                        if(appInfo.server.pop3Init())
                        {
                            console.log(appInfo.server.pop3Number())
                        }
                    }
                }
                FluFilledButton {
                    text: "Pop3Get"
                    onClicked: {
                        console.log(
                            appInfo.user.addMail(
                                appInfo.server.pop3Get(textbox_count.text)
                            )
                        )
                    }
                }
                FluFilledButton {
                    text: "Pop3Quit"
                    onClicked: {
                        console.log(appInfo.server.pop3Quit())
                    }
                }
            }
        }
    }
}
