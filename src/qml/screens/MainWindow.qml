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
       MenuBar{
           id: menuBar
           width:mainWindowWidth
           Layout.columnSpan: mainGridColumns
           Component.onCompleted: {
               menuBar.addItem("File")
               menuBar.addItem("Action")
               menuBar.addItem("View")
           }
       }
    }
}

