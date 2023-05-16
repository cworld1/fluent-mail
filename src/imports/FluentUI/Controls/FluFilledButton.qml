﻿import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import FluentUI

Button {
    property bool disabled: false
    property color normalColor: FluTheme.dark ? FluTheme.primaryColor.lighter : FluTheme.primaryColor.dark
    property color hoverColor: FluTheme.dark ? Qt.darker(normalColor,1.1) : Qt.lighter(normalColor,1.1)
    property color disableColor: FluTheme.dark ? Qt.rgba(82/255,82/255,82/255,1) : Qt.rgba(199/255,199/255,199/255,1)
    property color pressedColor: FluTheme.dark ? Qt.darker(normalColor,1.2) : Qt.lighter(normalColor,1.2)
    id: control
    enabled: !disabled
    Keys.onSpacePressed: control.visualFocus&&clicked()
    focusPolicy:Qt.TabFocus
    font:FluTextStyle.Body
    horizontalPadding:12
    background: Rectangle{
        implicitWidth: 28
        implicitHeight: 28
        radius: 4
        FluFocusRectangle{
            visible: control.visualFocus
            radius:8
        }
        color:{
            if(disabled){
                return disableColor
            }
            if(pressed){
                return pressedColor
            }
            return hovered ? hoverColor :normalColor
        }
    }
    contentItem: FluText {
        text: control.text
        font: control.font
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: {
            if(FluTheme.dark){
                if(disabled){
                    return Qt.rgba(173/255,173/255,173/255,1)
                }
                return Qt.rgba(0,0,0,1)
            }else{
                return Qt.rgba(1,1,1,1)
            }
        }
    }
}
