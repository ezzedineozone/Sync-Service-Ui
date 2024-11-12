import QtQuick
import QtQuick.Controls
import Qt.labs.qmlmodels
import QtQuick.Layouts

Rectangle {
    property string cell_main_color: "#F3F3F3"
    property string cell_secondary_color: "#EBEBEB"
    property string header_main_color: "#E1E1E1"
    property string header_secondary_color: "#CFCFCF"
    property var headerLabels: ["Name", "Source", "Destination", "Type", "Direction", "Edit"]
    property bool sortedAscending: true
    property int sortedColumnIndex: 0
    signal moduleAdded(string name, string source, string destination, string type, string direction)
    onModuleAdded : function(name, source, destination, type, direction){
        addModule(name, source, destination, type, direction);
    }
    //below here each will corespond to its respective index in headerLabels, that means 0 corresponds to name, 1 to source etc...
    property var sizes : [0.1,0.25,0.25,0.1,0.1,0.2]
    id: main_table_rect
    HorizontalHeaderView {
        id: horizontalHeader
        anchors.left: tableView.left
        anchors.top: parent.top
        syncView: tableView
        anchors.right: tableView.right
        clip: true
        delegate: Item {
            implicitHeight: 25
            implicitWidth: sizes[index] * main_table_rect.width
            MouseArea {
                anchors.fill: parent
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
        clip: true

        model: TableModel {
            TableModelColumn {display: "name" }
            TableModelColumn {display: "source" }
            TableModelColumn {display: "destination"}
            TableModelColumn {display: "type"}
            TableModelColumn {display: "direction"}
            TableModelColumn {display : "edit"}

            rows: [
                { name: "Item 1", source: "src1", destination: "dest1", type: "type1", direction: "dir1", edit: "edit1" },
                { name: "Item 2", source: "src2", destination: "dest2", type: "type2", direction: "dir2", edit: "edit2" },
                { name: "Item 3", source: "src3", destination: "dest3", type: "type1", direction: "dir3", edit: "edit3" },
                { name: "Item 4", source: "src4", destination: "dest1", type: "type2", direction: "dir1", edit: "edit4" },
                { name: "Item 5", source: "src5", destination: "dest2", type: "type1", direction: "dir2", edit: "edit5" },
                { name: "Item 6", source: "src6", destination: "dest3", type: "type3", direction: "dir1", edit: "edit6" },
                { name: "Item 7", source: "src7", destination: "dest4", type: "type1", direction: "dir2", edit: "edit7" },
                { name: "Item 8", source: "src8", destination: "dest5", type: "type2", direction: "dir3", edit: "edit8" }
            ]

        }

        delegate: Item {
            implicitWidth: main_table_rect.width * sizes[column]
            implicitHeight: 25
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: ()=>{rowEntered(row);}
                onExited: ()=>{rowExited(row);}
                id: mouseArea_header

            }
            Rectangle {
                anchors.fill: parent
                color: cell_main_color
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
                        property string cellText: column === 5 ? "Edit" : display
                        anchors.centerIn: parent
                        sourceComponent: column === 5 ? cell_actionsDelegate : cell_textDelegate
                    }
                }
            }
        }
    }
    Component{
        id: cell_textDelegate
        Label{
            anchors.centerIn: parent
            text: cellText
        }
    }
    Component{
        id: cell_actionsDelegate
        Label{
            anchors.centerIn: parent
            text: cellText
        }
    }

    function rowEntered(rowIndex) {

    }

    function rowExited(rowIndex) {

    }
    function reverseSort(column) {
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
    function addModule(name, source, destination, type, direction)
    {
        let module = {
            name: name,
            source: source,
            destination: destination,
            type: type,
            direction: direction,
            edit: ""
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
