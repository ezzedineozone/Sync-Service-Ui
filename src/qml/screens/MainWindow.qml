import QtQuick
import QtQuick.Layouts
import "../components"
import "../components/SyncTable"
import QtQuick.Controls
import QtQuick.Dialogs

Window
{
    QtObject{
        id: appMetadata
        readonly property string appVersion: "0.1.0"
    }
    signal addButtonClicked;
    signal connectToService;
    signal serviceConnected;

    onServiceConnected: () => {
        serviceStatus.visible = false;
        syncTable.visible = true;
    }

    function openAddSyncModulePopup(){
        console.log("main window button clicked");
        addButtonClicked();
    }


    AddSyncModule{
        id: addSyncModuleWindow
        objectName: "addSyncModuleWindow"
    }

    Dialog {
        id: mainWindowError
        title: "Error"
        objectName: "modal_error"
        anchors.centerIn: parent
        width: errorLayout.implicitWidth + 20
        height: errorLayout.implicitHeight + 40
        modal: true
        visible: true
        ColumnLayout{
            id: errorLayout
            anchors.centerIn: parent
            Text{
                font.pixelSize: 13
                text: "An error has occured"
                id: generalErrorText
            }
            RowLayout{
                Button{
                    Layout.preferredWidth: 60
                    Layout.preferredHeight: 22
                    Layout.alignment: Qt.AlignHCenter
                    text: "Log"
                    onClicked: mainWindowError.accept()
                }
                Button {
                    Layout.preferredWidth: 60
                    Layout.preferredHeight: 22
                    Layout.alignment: Qt.AlignHCenter
                    text: "OK"
                    onClicked: mainWindowError.accept()
                }
            }


        }
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
       SyncTable {
           id: syncTable
           objectName: "syncTable"
           Layout.row: 2
           Layout.fillHeight: true
           Layout.fillWidth: true
           Layout.column: 0
           Layout.columnSpan: mainGridColumns
           visible: false
       }
        Rectangle{
            id: serviceStatus
            visible: true
            Layout.row:2
            Layout.column:0
            Layout.topMargin:10
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.columnSpan: mainGridColumns
            CustomButton{
                innerText: "Connect To Service"
                anchors.centerIn: parent
                border_width: 1
                behavior: () => {
                    connectToService();
                }
            }
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

