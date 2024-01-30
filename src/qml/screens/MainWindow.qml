import QtQuick
import QtQuick.Layouts
import "../components"

Window
{
    QtObject{
        id: appMetadata
        readonly property string appVersion: "0.1.0"
    }



    property string defaultFont: "Segoe UI"
    property int defaultFontWeight: 360
    property int mainGridColumns: 3
    property int mainGridRows: 5
    property int mainWindowWidth: 800
    property int mainWindowHeight: 650

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
           Layout.row:1
           Layout.column: 0
           Layout.columnSpan: mainGridColumns
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
           Layout.row:2
           Layout.columnSpan: mainGridColumns
           height: mainWindowHeight - menuBar.implicitHeight - utilBar.implicitHeight - 105
           width: mainWindowWidth
       }
        StatusBar{
            id: mainStatusBar
            width:mainWindowWidth
            displayVersion:true
            Layout.preferredWidth: width
            Layout.columnSpan: mainGridColumns
            Layout.row: 3
            Layout.column: 0
        }
        Text{
            text:"test"
            visible:false
            Component.onCompleted: {
                mainStatusBar.progressRate(0.2)
            }
        }
    }
}

