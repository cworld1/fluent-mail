import QtQuick
import QtQuick.Layouts
import FluentUI

FluWindow {

    id:window

    property bool fixSize
    property alias titleVisible: title_bar.titleVisible
    property bool appBarVisible: true
    default property alias content: container.data

    FluAppBar {
        id: title_bar
        title: window.title
        visible: window.appBarVisible
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        darkText: lang.dark_mode
    }

    Item{
        id:container
        anchors{
            top: title_bar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        clip: true
    }

    Connections{
        target: FluTheme
        function onDarkChanged(){
            if (FluTheme.dark)
                FramelessUtils.systemTheme = FramelessHelperConstants.Dark
            else
                FramelessUtils.systemTheme = FramelessHelperConstants.Light
        }
    }

    function setHitTestVisible(com){
        framless_helper.setHitTestVisible(com)
    }

    function setTitleBarItem(com){
        framless_helper.setTitleBarItem(com)
    }

}
