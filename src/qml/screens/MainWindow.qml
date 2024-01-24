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
       columnSpacing:0
       MenuBar{
           id: menuBar
           Layout.preferredWidth: mainWindowWidth
           Layout.columnSpan: mainGridColumns
           Layout.column:0
           Layout.row:0
           Component.onCompleted: {
               menuBar.addItem("File")
               menuBar.addItem("Action")
               menuBar.addItem("View")
           }
       }
       RowLayout{
           id: utilBar
           spacing:0
           UtilBar{
               id: utilBarModify
               // width:mainWindowWidth / 3
               leftPadding:5
               Component.onCompleted: {
                   utilBarModify.addButton("qrc:images/icons/plus.png", "Add")
                   utilBarModify.addButton("qrc:images/icons/edit.png", "Edit")
                   utilBarModify.addButton("qrc:images/icons/delete.png", "Delete")
               }
           }

           Rectangle{
               Layout.preferredHeight:parent.implicitHeight
               width: 2
               color: "#ebebeb"
           }

           UtilBar{
               leftPadding:5
               Layout.preferredWidth: mainWindowWidth
               id: utilBarControl
               Component.onCompleted: {
                   utilBarControl.addButton("qrc:images/icons/sync.png", "Sync All")
                   utilBarControl.addButton("qrc:images/icons/pause.png", "Pause All")
               }
           }
       }
       Rectangle{
           width: mainWindowWidth
           Layout.columnSpan: mainGridColumns
           height: 10
           Layout.column: 0
           Layout.row: 2
           color:"white"
       }

       ProgressBar{
           id: mainProgressBar
           Layout.column: 0
           Layout.row:3
           Component.onCompleted: {
               mainProgressBar.modifyCompletion(0.5)
           }
       }
    }
}

