pragma Singleton

import QtQuick
import FluentUI

FluObject {
    property var navigationView

    id: footer_items

    FluPaneItemSeparator {}

    FluPaneItem {
        title: lang.user
        icon: FluentIcons.Contact
        // tapFunc: function(){
        //     FluApp.navigate("/about")
        // }
        onTap: {
            navigationView.push("qrc:/fluentmail/qml/page/T_User.qml")
        }
    }

    FluPaneItem {
        title: lang.settings
        icon: FluentIcons.Settings
        onTap: {
            navigationView.push("qrc:/fluentmail/qml/page/T_Settings.qml")
        }
    }

}
