import QtQuick
import QtQuick.Layouts
import "../components"
Window
{
    property string defaultFont: "Segoe UI"
    property int defaultFontWeight: 360
    property int mainGridColumns: 3
    property int mainGridRows: 3
    property int mainWindowWidth: 1000
    property int mainWindowHeight: 1400

    width: mainWindowWidth
    height: mainWindowHeight
    visible: true
    GridLayout{
       rows: mainGridRows
       columns: mainGridColumns
       rowSpacing:0
       MenuBar{
           id: menuBar
           width:mainWindowWidth
           Layout.columnSpan: mainGridColumns
           Layout.column:0
           Layout.row:0
           Component.onCompleted: {
               menuBar.addItem("File")
               menuBar.addItem("Action")
               menuBar.addItem("View")
           }
       }
       CustomButton{
           Layout.row:1
           Layout.column:0
           radius:0
           innerText:"test"
           textFontWeight: defaultFontWeight
       }
    }
}

