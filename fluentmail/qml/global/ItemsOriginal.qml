pragma Singleton

import QtQuick
import FluentUI

FluObject {
    property var navigationView

    // 主页
    FluPaneItem {
        title: lang.home
        icon: FluentIcons.Home
        // cusIcon: Image {
        //     anchors.centerIn: parent
        //     source: FluTheme.dark ? "qrc:/fluentmail/res/svg/home_dark.svg" : "qrc:/fluentmail/res/svg/home.svg"
        //     sourceSize: Qt.size(30, 30)
        //     width: 18
        //     height: 18
        // }
        onTap: {
            navigationView.push("qrc:/fluentmail/qml/page/T_Home.qml")
        }
    }

    // 写邮件
    FluPaneItem {
        title: lang.compose
        icon: FluentIcons.Edit
        recentlyUpdated: true
        image: "qrc:/fluentmail/res/image/control/AutoSuggestBox.png"
        desc: "1982年，第一张电脑笑脸 : -) 诞生。今天，人们已经习惯用它来表达心情。尝试使用它吧！"
        onTap: {
            navigationView.push("qrc:/fluentmail/qml/page/T_Compose.qml")
        }
    }

    // 收件箱
    FluPaneItem {
        title: lang.inbox
        icon: FluentIcons.Mail
        recentlyUpdated: true
        image: "qrc:/fluentmail/res/image/control/CommandBarFlyout.png"
        desc: "1987年9月14日21时07分，中国第一封电子邮件从北京发往德国。“越过长城，走向世界。”"
        onTap: {
            navigationView.push("qrc:/fluentmail/qml/page/T_MailList.qml", {pane_title: lang.inbox})
        }
    }

    FluPaneItemSeparator {}

    // 星标邮件
    FluPaneItem {
        title: lang.starred
        icon: FluentIcons.FavoriteStar
        recentlyAdded: true
        order: 0
        image: "qrc:/fluentmail/res/image/control/StandardUICommand.png"
        desc: "点亮你的收件箱，点亮行迹与感动。"
        onTap: navigationView.push("qrc:/fluentmail/qml/page/T_MailList.qml", {pane_title: lang.starred})
    }

    // 已发送
    FluPaneItem {
        title: lang.sent
        icon: FluentIcons.Completed
        recentlyAdded: true
        order: 1
        image: "qrc:/fluentmail/res/image/control/Checkbox.png"
        desc: "信息已传递，等待远方回音。"
        onTap: navigationView.push("qrc:/fluentmail/qml/page/T_DraftList.qml", {pane_title: lang.sent})
    }

    // 草稿
    FluPaneItem {
        title: lang.drafts
        icon: FluentIcons.KnowledgeArticle
        recentlyAdded: true
        order: 2
        image: "qrc:/fluentmail/res/image/control/InkCanvas.png"
        desc: "你创造的创意沉淀之地，思绪的保留室。"
        onTap: navigationView.push("qrc:/fluentmail/qml/page/T_DraftList.qml", {pane_title: lang.drafts})
    }

    // 垃圾箱
    FluPaneItem {
        title: lang.deleted
        icon: FluentIcons.Delete
        recentlyAdded: true
        order: 3
        image: "qrc:/fluentmail/res/image/control/ParallaxView.png"
        desc: "垃圾箱，是一个不可逆的过程。"
        onTap: navigationView.push("qrc:/fluentmail/qml/page/T_MailList.qml", {pane_title: lang.deleted})
    }

    FluPaneItemSeparator {}

    // 其他的
    FluPaneItemExpander {
        title: lang.basic_input
        icon: FluentIcons.CheckboxComposite
        FluPaneItem {
            title: "Buttons"
            image: "qrc:/fluentmail/res/image/control/Button.png"
            desc: "A control that responds to user input and raisesa Click event."
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_Buttons.qml")
            }
        }
        FluPaneItem {
            title: "Text"
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_Text.qml")
            }
        }
        FluPaneItem {
            title: "Slider"
            image: "qrc:/fluentmail/res/image/control/Slider.png"
            desc: "A control that lets the user select from a rangeof values by moving a Thumb control along atrack."
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_Slider.qml")
            }
        }
        // FluPaneItem {
        //     title: "CheckBox"
        //     image: "qrc:/fluentmail/res/image/control/Checkbox.png"
        //     desc: "A control that a user can select or clear."
        //     onTap: {
        //         navigationView.push("qrc:/fluentmail/qml/page/T_CheckBox.qml")
        //     }
        // }
        // FluPaneItem {
        //     title: "ToggleSwitch"
        //     onTap: {
        //         navigationView.push("qrc:/fluentmail/qml/page/T_ToggleSwitch.qml")
        //     }
        // }
    }

    FluPaneItemExpander {
        title: lang.form
        icon: FluentIcons.GridView
        FluPaneItem {
            title: "TextBox"
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_TextBox.qml")
            }
        }
        FluPaneItem {
            title: "TimePicker"
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_TimePicker.qml")
            }
        }
        FluPaneItem {
            title: "DatePicker"
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_DatePicker.qml")
            }
        }
        FluPaneItem {
            title: "CalendarPicker"
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_CalendarPicker.qml")
            }
        }
        FluPaneItem {
            title: "ColorPicker"
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_ColorPicker.qml")
            }
        }
    }

    FluPaneItemExpander {
        title: lang.surface
        icon: FluentIcons.SurfaceHub
        // FluPaneItem {
        //     title: "InfoBar"
        //     image: "qrc:/fluentmail/res/image/control/InfoBar.png"
        //     desc: "An inline message to display app-wide statuschange information."
        //     onTap: {
        //         navigationView.push("qrc:/fluentmail/qml/page/T_InfoBar.qml")
        //     }
        // }
        FluPaneItem {
            title: "Progress"
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_Progress.qml")
            }
        }
        FluPaneItem {
            title: "RatingControl"
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_RatingControl.qml")
            }
        }
        FluPaneItem {
            title: "Badge"
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_Badge.qml")
            }
        }
        FluPaneItem {
            title: "Rectangle"
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_Rectangle.qml")
            }
        }
        FluPaneItem {
            title: "StatusView"
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_StatusView.qml")
            }
        }
        // FluPaneItem {
        //     title: "Carousel"
        //     onTap: {
        //         navigationView.push("qrc:/fluentmail/qml/page/T_Carousel.qml")
        //     }
        // }
        FluPaneItem {
            title: "Expander"
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_Expander.qml")
            }
        }
    }

    FluPaneItemExpander {
        title: lang.popus
        icon: FluentIcons.ButtonMenu
        FluPaneItem {
            title: "Dialog"
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_Dialog.qml")
            }
        }
        FluPaneItem{
            title:"ComboBox"
            onTap:{
                navigationView.push("qrc:/fluentmail/qml/page/T_ComboBox.qml")
            }
        }
        FluPaneItem {
            title: "Tooltip"
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_Tooltip.qml")
            }
        }
        FluPaneItem {
            title: "Menu"
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_Menu.qml")
            }
        }
    }

    FluPaneItemExpander {
        title: lang.navigation
        icon: FluentIcons.AllApps
        FluPaneItem {
            title: "Pivot"
            image: "qrc:/fluentmail/res/image/control/Pivot.png"
            desc: "Presents information from different sources in atabbed view."
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_Pivot.qml")
            }
        }
        FluPaneItem {
            title: "BreadcrumbBar"
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_BreadcrumbBar.qml")
            }
        }
        FluPaneItem {
            title: "TabView"
            image: "qrc:/fluentmail/res/image/control/TabView.png"
            desc: "A control that displays a collection of tabs thatcan be used to display several documents."
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_TabView.qml")
            }
        }
        FluPaneItem {
            title: "TreeView"
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_TreeView.qml")
            }
        }
        // FluPaneItem {
        //     title: "TableView"
        //     image: "qrc:/fluentmail/res/image/control/DataGrid.png"
        //     desc: "The TableView control provides a flexible way to display a collection of data in rows and columns"
        //     onTap: {
        //         navigationView.push("qrc:/fluentmail/qml/page/T_TableView.qml")
        //     }
        // }
        // FluPaneItem {
        //     title: "MultiWindow"
        //     onTap: {
        //         navigationView.push("qrc:/fluentmail/qml/page/T_MultiWindow.qml")
        //     }
        // }
        FluPaneItem {
            title: "FlipView"
            image: "qrc:/fluentmail/res/image/control/FlipView.png"
            desc: "Presents a collection of items that the user canflip through, one item at a time."
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_FlipView.qml")
            }
        }
    }

    FluPaneItemExpander {
        title: lang.theming
        icon: FluentIcons.Brightness
        FluPaneItem {
            title: "Acrylic"
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_Acrylic.qml")
            }
        }
        // FluPaneItem {
        //     title: "Theme"
        //     onTap: {
        //         navigationView.push("qrc:/fluentmail/qml/page/T_Theme.qml")
        //     }
        // }
        FluPaneItem {
            title: "Typography"
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_Typography.qml")
            }
        }
        FluPaneItem {
            title: "Awesome"
            onTap: {
                navigationView.push("qrc:/fluentmail/qml/page/T_Awesome.qml")
            }
        }
    }

    // FluPaneItemExpander {
    //     title: lang.media
    //     icon: FluentIcons.Media
    //     FluPaneItem {
    //         title: "MediaPlayer"
    //         image: "qrc:/fluentmail/res/image/control/MediaPlayerElement.png"
    //         desc: "A control to display video and image content."
    //         onTap: {
    //             navigationView.push("qrc:/fluentmail/qml/page/T_MediaPlayer.qml")
    //         }
    //     }
    // }

    function getRecentlyAddedData()
    {
        var arr = []
        for (var i = 0; i < children.length; i++) {
            var item = children[i]
            if (item instanceof FluPaneItem && item.recentlyAdded)
            {
                arr.push(item)
            }
            if (item instanceof FluPaneItemExpander)
            {
                for (var j = 0; j < item.children.length; j++) {
                    var itemChild = item.children[j]
                    if (itemChild instanceof FluPaneItem && itemChild.recentlyAdded)
                    {
                        arr.push(itemChild)
                    }
                }
            }
        }
        arr.sort(function(o1, o2){ return o1.order - o2.order })
        return arr
    }

    function getRecentlyUpdatedData()
    {
        var arr = []
        var items = navigationView.getItems();
        for (var i = 0; i < items.length; i++) {
            var item = items[i]
            if (item instanceof FluPaneItem && item.recentlyUpdated)
            {
                arr.push(item)
            }
        }
        return arr
    }

    function getSearchData()
    {
        var arr = []
        var items = navigationView.getItems();
        for (var i = 0; i < items.length; i++) {
            var item = items[i]
            if (item instanceof FluPaneItem)
            {
                arr.push({title: item.title, key: item.key})
            }
        }
        return arr
    }

    function startPageByItem(data)
    {
        navigationView.startPageByItem(data)
    }

}
