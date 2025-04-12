import QtQuick
import QtQuick.Controls
import Qt.labs.qmlmodels
import QtQuick.Layouts
import '../'
Rectangle {
    property string cell_main_color: "#F3F3F3"
    property string cell_secondary_color: "#EBEBEB"
    property string header_main_color: "#E1E1E1"
    property string header_secondary_color: "#CFCFCF"
    property var headerLabels: ["Name", "Source", "Destination", "Type", "Direction", "Progress", "Status"]
    property bool sortedAscending: true
    property int sortedColumnIndex: 0
    signal moduleAdded(string name, string source, string destination, string type, string direction)
    signal modifyCompletion(string name, real val)
    signal modifyStatus(string name, string Status)
    signal modulePause(string name)
    signal moduleResume(string name)
    signal moduleDelete(string name)
    signal modulePaused(string name);
    signal moduleDeleted(string name);
    signal moduleResumed(string name);
    signal openEditWindow(string name, string source, string destination, string type, string direction);
    onModuleAdded : function(name, source, destination, type, direction){
        addModule(name, source, destination, type, direction);
    }
    onModifyCompletion:function (name, val) {
        modify_progress(name, val);
    }
    onModifyStatus: function(name, status)
    {
        modify_status(name, status);
    }
    onModuleDeleted: function(name) {
        console.log("Module deleted:", name);
        deleteModule(name);
    }
    //below here each will corespond to its respective index in headerLabels, that means 0 corresponds to name, 1 to source etc...
    property var sizes : [0.1,0.2,0.2,0.1,0.1,0.2, 0.1]
    id: main_table_rect
    HorizontalHeaderView {
        id: horizontalHeader
        anchors.left: tableView.left
        anchors.top: parent.top
        syncView: tableView
        anchors.right: tableView.right
        interactive: false

        delegate: Item {
            implicitHeight: 25
            implicitWidth: sizes[index] * main_table_rect.width

            MouseArea {
                anchors.left: parent.left
                anchors.leftMargin: 3
                height: parent.height
                width: parent.width - 9
                hoverEnabled: true
                onEntered: header.color = header_secondary_color
                onExited: header.color = header_main_color
                onClicked: reverseSort(index)
            }

            Rectangle {
                anchors.fill: parent
                color: header_main_color
                id: header
                Rectangle {
                    width: 0.5
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    color: "#cccaca"
                }
                Rectangle {
                    width: 0.5
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    color: "#cccaca"
                }
                Loader{
                    property string header_text: headerLabels[index]
                    property int primary_sorted_column: sortedColumnIndex
                    property int current_index: index
                    property bool sorted_ascending: sortedAscending
                    anchors.centerIn: parent
                    sourceComponent: header_textDelegate
                }
            }
            Image {
                anchors.right: parent.right
                anchors.margins: 5
                id: upArrow
                source: (sortedColumnIndex === -1)
                        ? "qrc:images/icons/downward-arrow.png"
                        : (sortedColumnIndex === index)
                            ? (sortedAscending
                                ? "qrc:images/icons/downward-arrow.png"
                                : "qrc:images/icons/upward-arrow.png")
                            : "qrc:images/icons/downward-arrow.png"
                width: 16
                height: 16
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
    Component{
        id: header_textDelegate
        Label{
            anchors.centerIn: parent
            text: header_text
        }
    }

    TableView {
        id: tableView
        anchors.left: parent.left
        anchors.top: horizontalHeader.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        property int selectedRow: -1
        property bool selectedRowMutex: false
        objectName: "tableView"
        clip: true
        interactive: false

        ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOn
                }
        ScrollBar.horizontal: ScrollBar{
            policy: ScrollBar.AlwaysOn
        }
        columnWidthProvider: function(column) {
            let width = explicitColumnWidth(column);
            if (width >= 0)
                return Math.max(width, 100);
            return explicitColumnWidth(column);
        }
        model: TableModel {
            TableModelColumn {display: "name" }
            TableModelColumn {display: "source" }
            TableModelColumn {display: "destination"}
            TableModelColumn {display: "type"}
            TableModelColumn {display: "direction"}
            TableModelColumn {display : "progress"}
            TableModelColumn {display: "status"}
            rows: [
               { name: "Module7", source: "/local/path/source7", destination: "/local/path/dest7", type: "local", direction: "one-way", status: "active", progress: 0.0 },
               { name: "Module8", source: "/cloud/storage/source8", destination: "/cloud/storage/dest8", type: "cloud", direction: "two-way", status: "active", progress: 0.0 },
               { name: "Module9", source: "/local/path/source9", destination: "/local/path/dest9", type: "local", direction: "one-way", status: "active", progress: 0.0 },
               { name: "Module10", source: "/cloud/storage/source10", destination: "/cloud/storage/dest10", type: "cloud", direction: "two-way", status: "active", progress: 0.0 },
               { name: "Module11", source: "/local/path/source11", destination: "/local/path/dest11", type: "local", direction: "one-way", status: "active", progress: 0.0 },
               { name: "Module12", source: "/cloud/storage/source12", destination: "/cloud/storage/dest12", type: "cloud", direction: "two-way", status: "active", progress: 0.0 }
            ]

        }

        delegate: Item {
            implicitWidth: main_table_rect.width * sizes[column]
            implicitHeight: 25
            MouseArea {
                anchors.left: parent.left;
                width: parent.width;
                height: parent.height - 5;
                hoverEnabled: true
                onEntered: ()=>{tableView.selectedRow = row}
                onExited: ()=>{
                    tableView.selectedRow = -1;
                }

                id: mouseArea_header
            }
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: {
                    if (mouse.button === Qt.RightButton)
                        contextMenu.popup()
                }
                onPressAndHold: {
                    if (mouse.source === Qt.MouseEventNotSynthesized)
                        contextMenu.popup()
                }

                Menu {
                    id: contextMenu
                    MenuItem {
                        text: "Pause"
                        onTriggered: { handlePause(row) }
                    }
                    MenuItem {
                        text: "Resume"
                        onTriggered: { handleResume(row) }
                    }
                    MenuItem {
                        text: "Edit"
                        onTriggered: { handleEdit(row) }
                    }
                    MenuItem {
                        text: "Delete"
                        onTriggered: { handleDelete(row) }
                    }
                }
            }
            Rectangle {
                anchors.fill: parent
                color: row === tableView.selectedRow ? "lightblue" : cell_main_color
                Rectangle {
                    width: 0.5
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    color: "#cccaca"
                }
                Rectangle {
                    width: 0.5
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    color: "#cccaca"
                }
                Item {
                    anchors.fill: parent
                    Loader {
                        property string cellText: display
                        property int setHeight: parent.parent.height
                        property int setWidth: parent.parent.width
                        property int rowVal: row
                        property int colVal: column
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 3
                        sourceComponent: column === 5 ? cell_actionsDelegate :
                                        (column === 6 ? cell_statusDelegate : cell_textDelegate)
                        objectName: "loader"
                    }
                }
            }
        }
    }
    Component{
        id: cell_textDelegate
        Label{
            text: cellText
        }
    }
    Component{
        id: cell_actionsDelegate
        ProgressBar{
            width: setWidth - 6
            height: setHeight - 6
            completion: cellText
        }
    }
    Component{
        id: cell_statusDelegate
        Text{
            text: cellText === "active" ? "Active..." : cellText.charAt(0).toUpperCase() + cellText.slice(1)
            color: cellText === "paused" ? "#808080" :  // gray for paused
                   cellText === "active" ? "#4CAF50" :  // green for active
                   cellText === "done" ? "#2196F3" :    // blue for done
                   cellText === "error" ? "#F44336" :   // red for error
                   "#000000" // Default black color
        }
    }

    function reverseSort(column) {
        console.log("Type of column:", typeof column);
        debugger;
        if (sortedColumnIndex !== column) {
            sortedColumnIndex = column;
            sortedAscending = false;
            sortDesc(column);
        } else {
            sortedAscending = !sortedAscending;
            if(sortedAscending)
                sortAsc(column);
            else
                sortDesc(column);
        }
    }
    function getRowIndexByName(name) {
        let rows = tableView.model.rows;
        for (let i = 0; i < rows.length; i++) {
            if (rows[i]["name"].toLowerCase() === name.toLowerCase()) {
                return i;
            }
        }
        return -1;
    }
    function modify_progress(name, val)
    {
        var ix = tableView.model.index(getRowIndexByName(name), 5);
        tableView.model.setData(ix, "display", val);
    }
    function modify_status(name, status)
    {
        var ix = tableView.model.index(getRowIndexByName(name),6);
        tableView.model.setData(ix, "display", status);
    }

    function sortAsc(column)
    {
        sortedAscending = true;
        sortedColumnIndex = column;
        tableView.model.rows = tableView.model.rows.slice().sort(function(a, b) {
            let valueA = a[tableView.model.columns[column].display];
            let valueB = b[tableView.model.columns[column].display];
            if (typeof valueA === "string") {
                valueA = valueA.toLowerCase();
                valueB = valueB.toLowerCase();
            }
            return valueA > valueB ? 1 : (valueA < valueB ? -1 : 0);
        });
    }
    function sortDesc(column)
    {
        sortedAscending = false;
        sortedColumnIndex = column;
        tableView.model.rows = tableView.model.rows.slice().sort(function(a, b) {
            let valueA = a[tableView.model.columns[column].display];
            let valueB = b[tableView.model.columns[column].display];
            if (typeof valueA === "string") {
                valueA = valueA.toLowerCase();
                valueB = valueB.toLowerCase();
            }
            return valueA < valueB ? 1 : (valueA > valueB ? -1 : 0);
        });
    }
    function handleDelete(row){
        console.log(row);
        let module = getModuleByRowIndex(row);
        console.log(module.name);
        //print all modules
        for(let i = 0; i < tableView.model.rows.length; i++)
        {
            console.log(tableView.model.rows[i].name);
        }
        moduleDelete(module.name);
    }
    function handleEdit(row){
        let module = getModuleByRowIndex(row);
        openEditWindow(module.name, module.source, module.destination, module.type, module.direction);
    }
    function getModuleByRowIndex(row){
        let module = tableView.model.rows[row];
        return module;
    }
    function deleteModule(name){
        let index = getRowIndexByName(name);
        if(index !== -1)
        {
            tableView.model.removeRow(index);
            moduleDeleted(name);
        }
    }
    function addModule(name, source, destination, type, direction)
    {
        let module = {
            name: name,
            source: source,
            destination: destination,
            type: type,
            direction: direction,
            status: "active",
            progress: 0.0
        }
        let col_name = tableView.model.columns[sortedColumnIndex];
        let indexAfter = -1;
        let newArray = tableView.model.rows.slice();

        if(sortedAscending)
        {
            for(let k = 0; k < tableView.model.rows.length; k++)
            {
                let col_value = module[tableView.model.columns[sortedColumnIndex].display];
                if(col_value.toLowerCase() < tableView.model.rows[k][tableView.model.columns[sortedColumnIndex].display].toLowerCase())
                {
                    break;
                }
                indexAfter = k;
            }
        }
        else {
            for(let i = 0; i < tableView.model.rows.length; i++)
            {
                let col_value = module[tableView.model.columns[sortedColumnIndex].display];
                if(col_value.toLowerCase() >= tableView.model.rows[i][tableView.model.columns[sortedColumnIndex].display].toLowerCase())
                {
                    break;
                }
                indexAfter = i;
            }
        }

        newArray.splice(indexAfter + 1, 0, module);
        tableView.model.rows = newArray;
    }

    Component.onCompleted: ()=>{
       sortedColumnIndex = 0;
       tableView.model.rows = tableView.model.rows.slice().sort(function(a, b) {
           let valueA = a[tableView.model.columns[0].display];
           let valueB = b[tableView.model.columns[0].display];
           if (typeof valueA === "string") {
               valueA = valueA.toLowerCase();
               valueB = valueB.toLowerCase();
           }
           if (sortedAscending) {
               return valueA > valueB ? 1 : (valueA < valueB ? -1 : 0);
           } else {
               return valueA < valueB ? 1 : (valueA > valueB ? -1 : 0);
           }
       });
    }
}
