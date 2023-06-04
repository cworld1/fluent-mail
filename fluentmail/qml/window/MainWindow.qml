import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform
import FluentUI
import "../component"
import "qrc:///fluentmail/qml/global/"

CustomWindow {
    id: window
    title: "Fluent Mail"
    width: 1000
    height: 640
    closeDestory: false
    minimumWidth: 520
    minimumHeight: 460
    appBarVisible: false
    launchMode: FluWindow.SingleTask

    // 窗口关闭事件
    closeFunc: function(event){
        close_app.open()
        event.accepted = false
    }

    // 窗口激活事件
    function onActiveWindow() {
        window.show()
        window.raise()
        window.requestActivate()
    }
    Connections {
        target: appInfo
        function active() {
            onActiveWindow()
        }
    }

    // 系统托盘
    SystemTrayIcon {
        id: system_tray
        visible: true
        icon.source: "qrc:/fluentmail/res/image/favicon.ico"
        tooltip: "Fluent Mail"
        menu: Menu {
            MenuItem {
                text: lang.show
                onTriggered: {
                    onActiveWindow()
                }
            }
            MenuItem {
                text: lang.exit
                onTriggered: {
                    window.deleteWindow()
                    FluApp.closeApp()
                }
            }
        }
        onActivated:
            (reason) => {
                if(reason === SystemTrayIcon.Trigger) {
                    onActiveWindow()
                }
            }
    }

    // 退出提示框
    FluContentDialog{
        id: close_app
        title: lang.tip
        message: "Are you sure to exit?"
        buttonFlags: FluContentDialog.NeutralButton | FluContentDialog.NegativeButton | FluContentDialog.PositiveButton
        neutralText: lang.cancel
        negativeText: lang.minimize
        onNegativeClicked: {
            system_tray.showMessage(lang.tip, "Fluent Mail is hide in system tray. You can click the icon to reopen it.");
            window.hide()
        }
        positiveText: lang.exit
        onPositiveClicked: {
            window.deleteWindow()
            FluApp.closeApp()
        }
    }

    // 顶栏
    FluAppBar {
        id: title_bar
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        darkText: lang.dark_mode
        showDark: true
        z: 7
    }
    
    // 主内容
    FluNavigationView {
        id: nav_view
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        z: 999
        topPadding: FluTools.isMacos() ? 20 : 5
        // 顶栏
        title: "Fluent Mail"
        logo: "qrc:/fluentmail/res/image/favicon.ico"
        displayMode: MainEvent.displayMode
        // 侧边栏
        items: ItemsOriginal
        footerItems: ItemsFooter
        // 搜索框
        autoSuggestBox: FluAutoSuggestBox{
            width: 280
            anchors.centerIn: parent
            iconSource: FluentIcons.Search
            items: ItemsOriginal.getSearchData()
            placeholderText: lang.search
            onItemClicked:
                (data)=>{
                    ItemsOriginal.startPageByItem(data)
                }
        }
        Component.onCompleted: {
            ItemsOriginal.navigationView = nav_view
            ItemsFooter.navigationView = nav_view
            nav_view.setCurrentIndex(0)
        }
    }
}
