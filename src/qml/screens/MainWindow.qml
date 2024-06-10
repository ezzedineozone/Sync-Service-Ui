import QtQuick
import QtQuick.Layouts
import "../components"
import "../components/SyncTable"

Window
{
    QtObject{
        id: appMetadata
        readonly property string appVersion: "0.1.0"
    }

    function openAddSyncModulePopup(){
        addSyncModule.visible = true
    }
    AddSyncModule{
        id: addSyncModule
    }

    property string defaultFont: "Segoe UI"
    property int defaultFontWeight: 360
    property int mainGridColumns: 3
    property int mainGridRows: 5
    property int mainWindowWidth: 900
    property int mainWindowHeight: 650


    minimumWidth: utilBar.implicitWidth
    minimumHeight: menuBar.height + utilBar.height + mainStatusBar.height
    width: mainWindowWidth
    height: mainWindowHeight
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
                   Component.onCompleted: {
                       utilBarModify.addButton("qrc:images/icons/plus.png", "Add", openAddSyncModulePopup)
                       utilBarModify.addButton("qrc:images/icons/edit.png", "Edit", openAddSyncModulePopup)
                       utilBarModify.addButton("qrc:images/icons/delete.png", "Delete", openAddSyncModulePopup)
                   }
               }

               UtilBar{
                   Layout.fillWidth: true
                   id: utilBarControl
                   Component.onCompleted: {
                       utilBarControl.addButton("qrc:images/icons/sync.png", "Sync All", openAddSyncModulePopup)
                       utilBarControl.addButton("qrc:images/icons/pause.png", "Pause All", openAddSyncModulePopup)
                   }
               }
           }
       }
        SyncTable{
           id: syncTable
           Layout.column:0
           Layout.row:2
           Layout.margins: 1
           Layout.topMargin: 10
           Component.onCompleted: syncTable.addSyncModule(1, "local", "oneway", "C://documents" , "C://desktop");
        }
        StatusBar{
            id: mainStatusBar
            displayVersion:true
            Layout.fillWidth: true
            Layout.columnSpan: mainGridColumns
            Layout.row: 3
            Layout.column: 0
        }
    }
}

