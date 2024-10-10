import QtQuick
import QtQuick.Controls
import Qt.labs.qmlmodels

Rectangle {
    property string cell_main_color: "#F3F3F3"
    property string cell_secondary_color: "#EBEBEB"
    property string header_main_color: "#E1E1E1"
    property string header_secondary_color: "#CFCFCF"
    property var headerLabels: ["Name", "Source", "Destination", "Type", "Direction"]
    //below here each will corespond to its respective index in headerLabels, that means 0 corresponds to name, 1 to source etc...
    property var sizes : [0.1,0.35,0.35,0.1,0.1]
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
            }

            Rectangle {
                anchors.fill: parent
                color: header_main_color
                id: header
                Rectangle {
                    width: 1
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    color: "#cccaca"
                }
                Rectangle {
                    width: 1
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    color: "#cccaca"
                }
                Label {
                    anchors.centerIn: parent
                    text: headerLabels[index]
                }
            }
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

            rows: [
                {
                    "name": "cat",
                    "source": "C:\\test_folder",
                    "destination": "C:\\test_folder",
                    "type": "local",
                    "direction" : "one-way",
                },
                {
                    "name": "dog",
                    "source": "C:\\test_folder",
                    "destination": "C:\\test_folder",
                    "type": "local",
                    "direction" : "one-way",
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
                    width: 1
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    color: "#cccaca"
                }
                Rectangle {
                    width: 1
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    color: "#cccaca"
                }
                Label {
                    anchors.centerIn: parent
                    text: display
                }
            }
        }
    }
    function rowEntered(rowIndex) {

    }

    function rowExited(rowIndex) {

    }


}
