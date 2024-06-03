import QtQuick
import QtQuick.Layouts

// requires ButtonSmall.qml
Rectangle{
    property int leftPadding : 0
    property int heightPadding: 5
    property int widthPadding: 5
    Layout.preferredHeight: menuRow.implicitHeight
    color: "#F5F5F5"

    ListModel{
        id: menuItems
    }

    GridLayout{
        id: menuRow
        rows:1
        columns: menuItems.count + 1
        columnSpacing:0
        Repeater{
            id: repeater
            model: menuItems
            delegate:ImageButton{
                border.width: 0
                imageUrl: model.imageUrl
                title: model.title
                Layout.column: index + 1
                Layout.row:0
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
