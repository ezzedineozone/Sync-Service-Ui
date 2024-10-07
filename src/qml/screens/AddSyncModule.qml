import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "../components"
import user.QObjects 1.0;

ApplicationWindow {
    property string selectedDialog: ""

    signal done();
    signal cancel;
    signal openSignal;
    signal sourceFolderAccepted();
    signal destinationFolderAccepted();
    signal typeSelected;
    signal directionSelected;
    signal nameModified;


    id: window
    width: 365
    height: 270
    visible: false
    modality: Qt.ApplicationModal




    function openFolderSelectionModal(type){
       selectedDialog = type
       if(type === "source")
       {
           source_folder_dialog.open();
       }
       else if (type === "destination")
       {
           destination_folder_dialog.open();
       }
    }
    function onAcceptedComboBox(type)
    {
        if(type === "direction")
            directionSelected();
        else if (type === "type")
            typeSelected();
        else
            console.log("invalid combo box signal");
    }
    function onAddButtonClick(){
        console.log("calling done signal");
        done();
    }
    function onCancelButtonClick(){
        cancel();
    }
    Component.onCompleted: {
        onAcceptedComboBox("type");
        onAcceptedComboBox("direction");
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
        id: source_folder_dialog
        objectName: "source_folder_dialog"
        modality: Qt.ApplicationModal
        onAccepted: () => {sourceFolderAccepted()}
        onRejected: () => {console.log("folder modal rejected")}
        acceptLabel: "Select Folder"
        rejectLabel: "Close"
    }
    FolderDialog{
        id: destination_folder_dialog
        objectName: "destination_folder_dialog"
        modality: Qt.ApplicationModal
        onAccepted: () => {destinationFolderAccepted()}
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
            columns: 3
            rows: 5
            ColumnLayout{
                Layout.row:0
                Layout.column:1
                Layout.preferredWidth: parent.width / 3
                Layout.preferredHeight: parent.height * 0.3
                Layout.alignment: Qt.AlignHCenter
                Text{
                    Layout.leftMargin: 30
                    text: "Type: "
                }
                ComboBox{
                    Layout.leftMargin: 30
                    objectName: "type_selector"
                    model: sync_types
                    font.pixelSize: 14
                    id: selected_type
                    onActivated: ()=>{onAcceptedComboBox("type")}
                }
            }
            ColumnLayout{
                Layout.row:0
                Layout.column:2
                Layout.preferredWidth: parent.width / 3
                Layout.preferredHeight: parent.height * 0.3
                Layout.alignment: Qt.AlignHCenter
                Text{
                    Layout.leftMargin: 30
                    text: "Direction: "
                }
                ComboBox{
                    objectName: "direction_selector"
                    Layout.leftMargin: 30
                    model: sync_directions
                    font.pixelSize: 14
                    id: selected_direction
                    onActivated: ()=>{onAcceptedComboBox("direction")}
                }
            }
            ColumnLayout{
                Layout.row:0
                Layout.column:0
                Layout.preferredWidth: parent.width / 3
                Layout.preferredHeight: parent.height * 0.3
                Layout.alignment: Qt.AlignLeft
                Text{
                    text: "Name: "
                }
                TextArea{
                    objectName: "module_name"
                    Layout.preferredWidth: selected_direction.width
                    Layout.maximumWidth: selected_direction.width
                    font.pixelSize: 14
                    id: module_name
                    onTextChanged: ()=>{
                        nameModified();
                    };
                }
            }

            ColumnLayout{
                Layout.row:1
                Layout.column:0
                Layout.preferredWidth: parent.width / 2
                Layout.preferredHeight: parent.height * 0.3
                Layout.columnSpan: 3
                Text{
                    text: "Source: "
                    width: parent * 0.3
                    font.pixelSize: 13
                }
                RowLayout{
                    TextArea{
                        id: source_input
                        objectName: "source_input"
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
                Layout.columnSpan: 3
                Text{
                    text: "Destination: "
                    width: parent * 0.1
                    font.pixelSize: 13
                }
                RowLayout{
                    TextArea{
                        id: destination_input
                        objectName: "destination_input"
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
                Layout.columnSpan: 3
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
