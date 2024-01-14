import QtQuick
import QtQuick.Layouts

Rectangle{
    color: "#f5f2f2"
    height:20
    ListModel{
        id: menuItems
    }
    GridLayout{
        rows:1
        columns:menuItems.count
        Repeater{
            model: menuItems
            delegate:ButtonSmall{
                Layout.fillWidth: false
                mainColor:"#f5f2f2"
                innerText:model.text
                radius:0
                border.width:0
                Layout.row:0
                Layout.column:index
            }
        }
    }
    function addItem(nameItem: string)
    {
        menuItems.append({text:nameItem})
    }
}
