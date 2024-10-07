import QtQuick
import QtQuick.Controls
import Qt.labs.qmlmodels

Rectangle {

    width: parent.width;
    height: parent.height;
    HorizontalHeaderView {
        id: horizontalHeader
        anchors.left: tableView.left
        anchors.top: parent.top
        syncView: tableView
        clip: true
        delegate: Item {
            implicitWidth: tableView.width / tableView.model.columnCount // Adjust width
            implicitHeight: 35 // Fixed height or can be adjusted as needed

            Rectangle {
                anchors.fill: parent
                color: "#e8e8e8"

                // Left border
                Rectangle {
                    width: 1
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    color: "#cccaca"
                }

                // Right border
                Rectangle {
                    width: 1
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    color: "#cccaca"
                }

                // Main content area
                Label {
                    anchors.centerIn: parent
                    text: display
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
            implicitWidth: tableView.width / tableView.model.columnCount
            implicitHeight: 35

            Rectangle {
                id: headerRect
                anchors.fill: parent
                color: "#e8e8e8"
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
}
