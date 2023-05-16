import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI

Window {
    id:app
    Component.onCompleted: {
        FluApp.init(app)
        FluTheme.darkMode = FluDarkMode.System
        FluApp.routes = {
            "/":"qrc:/FluentMail/qml/window/MainWindow.qml",
            "/about":"qrc:/FluentMail/qml/window/AboutWindow.qml",
            "/login":"qrc:/FluentMail/qml/window/LoginWindow.qml",
            "/media":"qrc:/FluentMail/qml/window/MediaWindow.qml",
            "/singleTaskWindow":"qrc:/FluentMail/qml/window/SingleTaskWindow.qml",
            "/standardWindow":"qrc:/FluentMail/qml/window/StandardWindow.qml",
            "/singleInstanceWindow":"qrc:/FluentMail/qml/window/SingleInstanceWindow.qml"
        }
        FluApp.initialRoute = "/"
        FluApp.run()
    }
}
