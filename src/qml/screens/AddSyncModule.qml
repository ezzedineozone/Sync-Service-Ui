import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "../components"
import user.QObjects 1.0;

ApplicationWindow {
    property string selectedDialog: ""
    property string sync_type
    property string sync_direction
    property string source
    property string destination
    signal done


    id: window
    width: 265
    height: 270
    visible: false
    modality: Qt.ApplicationModal

    function openFolderSelectionModal(type){
       selectedDialog = type
       folder_dialog.open()
    }
    function onAcceptedFolderDialog()
    {
        console.log(folder_dialog.selectedFolder);
        if(selectedDialog === "source")
            source_input.text = folder_dialog.selectedFolder.toString().replace("file:///", "")
        else if(selectedDialog === "destination")
            destination_input.text = folder_dialog.selectedFolder.toString().replace("file:///","")
        else
            console.log("no valid text box found for modal");
    }
    function checkFormValidity()
    {

    }
    function onAddButtonClick(){
        sync_type = selected_type.currentValue;
        sync_direction = selected_direction.currentValue;
        source = source_input.text;
        destination = source_input.text;
        done();
    }
    function onCancelButtonClick(){
        visible = false
    }

    ListModel{
        id: sync_types
        ListElement{
            name:"Local"
        }
        ListElement{
            name:"Cloud"
        }
    }
    ListModel{
        id: sync_directions
        ListElement{
            name: "One-way"
        }
        ListElement{
            name: "Two-way"
        }
        ListElement{
            name: "Backup"
        }
    }

    FolderDialog{
        id: folder_dialog
        modality: Qt.ApplicationModal
        onAccepted: () => {onAcceptedFolderDialog()}
        onRejected: () => {console.log("folder modal rejected")}
        acceptLabel: "Select Folder"
        rejectLabel: "Close"
    }
    Rectangle{
        anchors.fill:parent
        color: "#F0F0F0F0"
        GridLayout{
            anchors.fill: parent
            anchors.margins: 8
            columns: 2
            rows: 5
            ColumnLayout{
                Layout.row:0
                Layout.column:0
                Layout.preferredWidth: parent.width / 2
                Layout.preferredHeight: parent.height * 0.3
                Text{
                    text: "Type: "
                }
                ComboBox{
                    model: sync_types
                    font.pixelSize: 14
                    id: selected_type
                }
            }
            ColumnLayout{
                Layout.row:0
                Layout.column:1
                Layout.preferredWidth: parent.width / 2
                Layout.preferredHeight: parent.height * 0.3
                Text{
                    Layout.leftMargin: 30
                    text: "Direction: "
                }
                ComboBox{
                    Layout.leftMargin: 30
                    model: sync_directions
                    font.pixelSize: 14
                    id: selected_direction
                }
            }

            ColumnLayout{
                Layout.row:1
                Layout.column:0
                Layout.preferredWidth: parent.width / 2
                Layout.preferredHeight: parent.height * 0.3
                Layout.columnSpan: 2
                Text{
                    text: "Source: "
                    width: parent * 0.3
                    font.pixelSize: 13
                }
                RowLayout{
                    TextArea{
                        id: source_input
                        Layout.fillWidth: true
                        font.pixelSize: 16
                        placeholderText: "Source directory here"
                        readOnly: true
                    }
                    ImageButton{
                        imageUrl: "qrc:images/icons/folder.png"
                        imageWidth: source_input.height
                        imageHeight: source_input.height
                        padding:0
                        rightPadding: 0
                        leftPadding:0
                        inner_spacing: 0
                        bottomPadding: 4
                        behavior: () => {openFolderSelectionModal("source")}
                    }
                }
            }
            ColumnLayout{
                Layout.preferredHeight: parent.height * 0.3
                Layout.row:2
                Layout.column:0
                Layout.preferredWidth: parent.width / 2
                Layout.columnSpan: 2
                Text{
                    text: "Destination: "
                    width: parent * 0.1
                    font.pixelSize: 13
                }
                RowLayout{
                    TextArea{
                        id: destination_input
                        Layout.fillWidth: true
                        placeholderText: "Destination directory here"
                        font.pixelSize: 16
                        readOnly: true
                    }
                    ImageButton{
                        imageUrl: "qrc:images/icons/folder.png"
                        imageWidth: destination_input.height
                        imageHeight:destination_input.height
                        padding:0
                        rightPadding: 0
                        leftPadding:0
                        inner_spacing: 0
                        bottomPadding: 4
                        behavior: () => {openFolderSelectionModal("destination")}
                    }
                }
            }
            RowLayout{
                Layout.row: 3
                Layout.column: 0
                spacing : 3
                Layout.columnSpan: 2
                Layout.alignment: Qt.AlignCenter
                Layout.topMargin: 20
                CustomButton{
                    innerText: "Add"
                    buttonSize: "medium"
                    border_width: 1
                    behavior: onAddButtonClick
                }
                CustomButton{
                    innerText: "Cancel"
                    buttonSize: "medium"
                    border_width: 1
                    behavior: onCancelButtonClick
                }
            }
        }
    }
}
