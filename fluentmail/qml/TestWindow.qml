import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform
import FluentUI
import "qrc:///fluentmail/qml/global/"

FluWindow {
    id: window
    title: "FluentUI"
    width: 1000
    height: 640
    closeDestory:false
    minimumWidth: 520
    minimumHeight: 460
    launchMode: FluWindow.SingleTask
    visible: true

    // 顶栏
    FluNavigationView2 {
        id: nav_view
        anchors.fill: parent
        items: ItemsOriginal
        footerItems: ItemsFooter
        z: 11
        displayMode: MainEvent.displayMode
        logo: "qrc:/fluentmail/favicon.ico"
        title: "FluentUI"
    }

    FluFilledButton {
        anchors.centerIn: parent
        text:"Filled Button"
        onClicked: {
            console.log("Hello world")
        }
    }

}
