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
    property int mainWindowWidth: 900
    property int mainWindowHeight: 650


    minimumWidth: mainWindowWidth
    minimumHeight: mainWindowHeight
    visible: true
    GridLayout{
       anchors.fill: parent
       rows: mainGridRows
       columns: mainGridColumns
       rowSpacing:0
       columnSpacing:0
       MenuBar{
           id: menuBar
           Layout.column:0
           Layout.row:0
           Layout.columnSpan: mainGridColumns
           Layout.preferredWidth: parent.width
           Component.onCompleted: {
               menuBar.addItem("File")
               menuBar.addItem("Action")
               menuBar.addItem("View")
           }
       }
       Rectangle{
           color: "lightgray"
           Layout.row:1
           Layout.column: 0
           Layout.columnSpan: mainGridColumns
           Layout.preferredWidth: parent.width
           Layout.preferredHeight: utilBar.implicitHeight
           RowLayout{
               id: utilBar
               anchors.fill:parent
               spacing:3
               UtilBar{
                   id: utilBarModify
                   Layout.preferredWidth: 0.4 * mainWindowWidth
                   Component.onCompleted: {
                       utilBarModify.addButton("qrc:images/icons/plus.png", "Add")
                       utilBarModify.addButton("qrc:images/icons/edit.png", "Edit")
                       utilBarModify.addButton("qrc:images/icons/delete.png", "Delete")
                   }
               }

               UtilBar{
                   Layout.fillWidth: true
                   id: utilBarControl
                   Component.onCompleted: {
                       utilBarControl.addButton("qrc:images/icons/sync.png", "Sync All")
                       utilBarControl.addButton("qrc:images/icons/pause.png", "Pause All")
                   }
               }
           }
       }
           //temporary spacer element for until we add the tableSync
        Rectangle{
               Layout.column:0
               Layout.row:2
               Layout.columnSpan: mainGridColumns
               Layout.preferredWidth: parent.width
               Layout.fillWidth: true
               Layout.fillHeight: true
            }
        StatusBar{
            id: mainStatusBar
            width:mainWindowWidth
            displayVersion:true
            Layout.preferredWidth: parent.width
            Layout.columnSpan: mainGridColumns
            Layout.row: 3
            Layout.column: 0
        }
    }
}

