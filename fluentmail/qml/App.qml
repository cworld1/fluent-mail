import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI

Window {
    id: app
    Component.onCompleted: {
        FluApp.init(app)
        FluTheme.darkMode = FluDarkMode.System
        FluApp.routes = {
            "/": "qrc:/fluentmail/qml/window/MainWindow.qml",
            "/about": "qrc:/fluentmail/qml/window/AboutWindow.qml",
            "/login": "qrc:/fluentmail/qml/window/LoginWindow.qml",
            "/detail": "qrc:/fluentmail/qml/window/DetailWindow.qml",
        }
        FluApp.initialRoute = "/"
        FluApp.run()
    }
}
