import QtQuick
import QtQuick.Layouts

// requires ButtonSmall.qml
Rectangle{
    color: "#F5F5F5"
    height: menuRow.implicitHeight + 5
    Layout.preferredHeight: height
    ListModel{
        id: menuItems
    }
    GridLayout{
        id: menuRow
        rows:1
        columns: menuItems.count
        columnSpacing:2
        Repeater{
            model: menuItems
            delegate:ImageButton{
                border.width: 0
                imageUrl: model.imageUrl
                title: model.title
                Layout.column: index
                Layout.row:0
                Layout.topMargin: 5
                extraHeightPadding:5
                extraWidthPadding:25
                leftPadding:5
            }
        }
    }
    function addItem(imageUrl, text = "")
    {
        if(text === "")
            menuItems.append({imageUrl:imageUrl})
        else
        {
            menuItems.append({imageUrl:imageUrl, title:text})
        }
    }
}
