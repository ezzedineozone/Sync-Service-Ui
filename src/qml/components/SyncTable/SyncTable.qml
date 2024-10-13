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
    property int sortedColumnIndex: -1
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
                source: ((sortedColumnIndex === index )&& sortedAscending)? "qrc:images/icons/downward-arrow.png" : "qrc:images/icons/upward-arrow.png"
                width: 16  // Set desired width
                height: 16 // Set desired height
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
            TableModelColumn { display: "name" }
            TableModelColumn { display: "source" }
            TableModelColumn {display: "destination"}
            TableModelColumn {display: "type"}
            TableModelColumn {display: "direction"}
            TableModelColumn {display : "edit"}

            rows: [
                {
                    "name": "cat",
                    "source": "C:\\test_folder",
                    "destination": "C:\\test_folder",
                    "type": "local",
                    "direction" : "one-way",
                    "Edit": ""
                },
                {
                    "name": "dog",
                    "source": "C:\\test_folder",
                    "destination": "C:\\test_folder",
                    "type": "local",
                    "direction" : "one-way",
                    "Edit": ""
                },
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
        sortedColumnIndex = column;
        tableView.model.rows = tableView.model.rows.slice().sort(function(a, b) {
            let valueA = a[tableView.model.columns[column].display];
            let valueB = b[tableView.model.columns[column].display];
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
        sortedAscending = !sortedAscending
    }

}
