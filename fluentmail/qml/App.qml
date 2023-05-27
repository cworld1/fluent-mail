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
        "/":"qrc:/fluentmail/qml/window/MainWindow.qml",
        "/about":"qrc:/fluentmail/qml/window/AboutWindow.qml",
        "/login":"qrc:/fluentmail/qml/window/LoginWindow.qml",
        "/media":"qrc:/fluentmail/qml/window/MediaWindow.qml",
        "/singleTaskWindow":"qrc:/fluentmail/qml/window/SingleTaskWindow.qml",
        "/standardWindow":"qrc:/fluentmail/qml/window/StandardWindow.qml",
        "/singleInstanceWindow":"qrc:/fluentmail/qml/window/SingleInstanceWindow.qml"
    }
    FluApp.initialRoute = "/"
    FluApp.run()
}
}
