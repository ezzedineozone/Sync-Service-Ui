import QtQuick
import QtQuick.Layouts

// requires ButtonSmall.qml
Rectangle{
    property int leftPadding : 0
    property int heightPadding: 5
    property int widthPadding: 5

    color: "#F5F5F5"
    width: menuRow.implicitWidth + widthPadding
    height: menuRow.implicitHeight + heightPadding
    Layout.preferredHeight: menuRow.implicitHeight + heightPadding
    Layout.preferredWidth:  menuRow.implicitWidth + widthPadding

    ListModel{
        id: menuItems
    }

    GridLayout{
        id: menuRow
        rows:1
        columns: menuItems.count + 1
        columnSpacing:2
        Rectangle{
            width:leftPadding
            height:menuRow.implicitHeight
        }
        Repeater{
            id: repeater
            model: menuItems
            delegate:ImageButton{
                border.width: 0
                imageUrl: model.imageUrl
                title: model.title
                Layout.column: index + 1
                Layout.row:0
                Layout.topMargin: 5
                extraHeightPadding:5
                extraWidthPadding:25
                leftPadding:5
            }
        }
    }
    function addButton(imageUrl, text = "")
    {
        if(text === "")
            menuItems.append({imageUrl:imageUrl})
        else
        {
            menuItems.append({imageUrl:imageUrl, title:text})
        }
    }
}
