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
    property var headerLabels: ["Name", "Source", "Destination", "Type", "Direction", "Status"]
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
            TableModelColumn {display : "name"}

            rows: [
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
                        property string cellText: column === 5 ? display : display
                        property int setHeight: parent.parent.height
                        property int setWidth: parent.parent.width
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 3
                        sourceComponent: column === 5 ? cell_actionsDelegate : cell_textDelegate
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
            property string status: "active"
            objectName: "progress_bar_"
            width: setWidth - 6
            height: setHeight - 6
            inner_text: {
                return status.charAt(0).toUpperCase() + status.slice(1) + ".";
            }
            progress_color: {
            if (status === "active") {
                return "#47fc7d";
            } else if (status === "paused") {
                return "#d3d3d3";
            } else if (status === "done") {
                return "#1E90FF";
            } else {
                return "#000000";
            }
            }
        }
        // Label{
        //     text: cellText
        // }
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
            Status: name
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
