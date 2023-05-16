﻿import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import FluentUI

Item {
    property alias title: text_title.text
    default property alias content: container.data
    property int spacing : 0
    property int leftPadding: 10
    property int topPadding: 0
    property int rightPadding: 10
    property int bottomPadding: 10
    property int pageMode: FluNavigationView.Standard
    property string url: ''
    id:control
    FluText{
        id:text_title
        font: FluTextStyle.Title
        visible: text !== ""
        height: visible ? implicitHeight : 0
        padding: 0
        anchors{
            top: parent.top
            topMargin: control.topPadding
            left: parent.left
            right: parent.right
            leftMargin: control.leftPadding
            rightMargin: control.rightPadding
        }
    }
    Flickable{
        id:flickview
        clip: true
        anchors{
            left: parent.left
            right: parent.right
            top: text_title.bottom
            bottom: parent.bottom
            bottomMargin: control.bottomPadding
        }
        contentWidth: parent.width
        contentHeight: container.height
        ScrollBar.vertical: FluScrollBar {
        }
        anchors{
            top: text_title.bottom
            bottom: parent.bottom
        }
        ColumnLayout{
            id:container
            spacing: control.spacing
            clip: true
            anchors{
                left: parent.left
                right: parent.right
                top: parent.top
                leftMargin: control.leftPadding
                rightMargin: control.rightPadding
            }
            width: parent.width
        }
    }
}
