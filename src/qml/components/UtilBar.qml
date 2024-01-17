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
                Layout.column: index
                Layout.row:0
            }
        }
    }
    function addItem(imageUrl: string)
    {
        menuItems.append({imageUrl:imageUrl})
    }
}
