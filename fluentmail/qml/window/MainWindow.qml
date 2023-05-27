﻿import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform
import FluentUI
import "qrc:///fluentmail/qml/global/"

FluWindow {

    id:window
    title: "FluentMail"
    width: 1000
    height: 640
    closeDestory:false
    minimumWidth: 520
    minimumHeight: 460
    launchMode: FluWindow.SingleTask

    closeFunc:function(event){
        close_app.open()
        event.accepted = false
    }

    Connections{
        target: appInfo
        function onActiveWindow(){
            window.show()
            window.raise()
            window.requestActivate()
        }
    }

    // 系统托盘
    SystemTrayIcon {
        id:system_tray
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
        id:close_app
        title:"退出"
        message:"确定要退出程序吗？"
        negativeText:"最小化"
        buttonFlags: FluContentDialog.NeutralButton | FluContentDialog.NegativeButton | FluContentDialog.PositiveButton
        onNegativeClicked:{
            system_tray.showMessage("提示","Fluent Mail 已隐藏至托盘，点击托盘可再次激活窗口");
            window.hide()
        }
        positiveText:"退出"
        neutralText:"取消"
        onPositiveClicked:{
            window.deleteWindow()
            FluApp.closeApp()
        }

    }

    // 顶栏控制栏
    FluNavigationView{
        id:nav_view
        anchors.fill: parent
        items: ItemsOriginal
        footerItems:ItemsFooter
        z:11
        displayMode:MainEvent.displayMode
        logo: "qrc:/fluentmail/res/image/favicon.ico"
        title:"FluentMail"
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
        actionItem:Item{
            height: 40
            width: 148
            RowLayout{
                anchors.centerIn: parent
                spacing: 5
                FluText{
                    text:lang.dark_mode
                }
                FluToggleSwitch{
                    selected: FluTheme.dark
                    clickFunc:function(){
                        if(FluTheme.dark){
                            FluTheme.darkMode = FluDarkMode.Light
                        }else{
                            FluTheme.darkMode = FluDarkMode.Dark
                        }
                    }
                }
            }
        }
        Component.onCompleted: {
            ItemsOriginal.navigationView = nav_view
            ItemsFooter.navigationView = nav_view
            nav_view.setCurrentIndex(0)
        }
    }

}
