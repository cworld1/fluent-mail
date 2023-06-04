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
    title: "FluentMail"
    width: 1000
    height: 640
    closeDestory: false
    minimumWidth: 520
    minimumHeight: 460
    appBarVisible: false
    launchMode: FluWindow.SingleTask

    closeFunc: function(event){
        close_app.open()
        event.accepted = false
    }

    Connections {
        target: appInfo
        function onActiveWindow(){
            window.show()
            window.raise()
            window.requestActivate()
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
                text: "退出"
                onTriggered: {
                    window.deleteWindow()
                    FluApp.closeApp()
                }
            }
        }
        onActivated:
            (reason)=>{
                if(reason === SystemTrayIcon.Trigger){
                    window.show()
                    window.raise()
                    window.requestActivate()
                }
            }
    }

    // 退出提示框
    FluContentDialog{
        id: close_app
        title: "退出"
        message: "确定要退出程序吗？"
        negativeText: "最小化"
        buttonFlags: FluContentDialog.NeutralButton | FluContentDialog.NegativeButton | FluContentDialog.PositiveButton
        onNegativeClicked: {
            system_tray.showMessage("提示","Fluent Mail 已隐藏至托盘，点击托盘可再次激活窗口");
            window.hide()
        }
        positiveText: "退出"
        neutralText: "取消"
        onPositiveClicked: {
            window.deleteWindow()
            FluApp.closeApp()
        }
    }

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

    // 顶栏控制栏
    FluNavigationView{
        id: nav_view
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        z: 999
        items: ItemsOriginal
        footerItems:ItemsFooter
        topPadding: FluTools.isMacos() ? 20 : 5
        displayMode:MainEvent.displayMode
        logo: "qrc:/fluentmail/res/image/favicon.ico"
        title:"FluentUI"
        autoSuggestBox:FluAutoSuggestBox{
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
