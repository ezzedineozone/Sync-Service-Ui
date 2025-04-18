import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import "../components"
import user.QObjects 1.0;

ApplicationWindow {
    property string selectedDialog: ""
    property int isEditMode: 0
    property string oldModuleName: ""

    signal done();
    signal cancel;
    signal openSignal;
    signal sourceFolderAccepted();
    signal destinationFolderAccepted();
    signal typeSelected;
    signal directionSelected;
    signal nameModified;
    signal openEditWindow(string moduleName, string moduleType, string moduleDirection, string sourcePath, string destinationPath);
    signal editModule(string moduleName, string new_name, string moduleType, string moduleDirection, string sourcePath, string destinationPath);

    //onOpenEditWindow
    onOpenEditWindow: (moduleName, sourcePath, destinationPath, moduleType, moduleDirection)=>{
        console.log("openEditWindow signal received");
        module_name.text = moduleName;
        source_input.text = sourcePath;
        destination_input.text = destinationPath;
        let direction_index = -1;
        window.isEditMode = 1;
        for(let i = 0; i < sync_directions.count; i++)
        {
            if(sync_directions.get(i).name === moduleDirection)
            {
                direction_index = i;
                break;
            }
        }
        if(direction_index !== -1)
        {
            selected_direction.currentIndex = direction_index;
        }
        let type_index = -1;
        for(let i = 0; i < sync_types.count; i++)
        {
            if(sync_types.get(i).name === moduleType)
            {
                type_index = i;
                break;
            }
        }
        if(type_index !== -1)
        {
            selected_type.currentIndex = type_index;
        }
        window.visible = true;
        window.oldModuleName = moduleName;
    }
    onOpenSignal : ()=>{
        window.isEditMode = 0;
    }
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
        done();
    }
    function onEditButtonClick(){
        console.log("edit button clicked"); 
        let new_name = module_name.text;
        let moduleType = selected_type.currentText;
        let moduleDirection = selected_direction.currentText;
        let sourcePath = source_input.text;
        let destinationPath = destination_input.text;
        editModule(oldModuleName, new_name, moduleType, moduleDirection, sourcePath, destinationPath);
        window.oldModuleName = "";
        window.visible = false;
    }
    function onMainButtonClick(){
        if(window.isEditMode == 1)
        {
            onEditButtonClick();
        }
        else
        {
            onAddButtonClick();
        }
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
                    Text{
                        text: (window.isEditMode === 1) ? "Save" : "Add"
                        font.pixelSize: 14
                        anchors.centerIn: parent
                        id: main_btn_text
                    } 
                    innerText: ""
                    width: main_btn_text.width + 20
                    border_width: 1
                    behavior: onMainButtonClick
                    id: main_btn
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
