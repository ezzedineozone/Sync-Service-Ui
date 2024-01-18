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

    maximumWidth: mainWindowWidth
    maximumHeight: mainWindowHeight
    minimumWidth: mainWindowWidth
    minimumHeight: mainWindowHeight
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
       UtilBar{
           id: utilBar
           width:mainWindowWidth
           Layout.columnSpan: mainGridColumns
           Layout.column: 0
           Layout.row: 1
           Component.onCompleted: {
               utilBar.addItem("qrc:images/icons/plus.png", "Add")
               utilBar.addItem("qrc:images/icons/sync.png", "Sync Now")
               utilBar.addItem("qrc:images/icons/plus.png", "adddddddddaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
           }
       }
    }
}

