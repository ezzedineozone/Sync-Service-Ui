import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../components"
ApplicationWindow {
    id: window
    width: 300
    height: 400
    visible: false
    modality: Qt.ApplicationModal
    Rectangle{
        anchors.fill:parent
        color: "#F0F0F0F0"
        GridLayout{
            anchors.fill:parent
            anchors.margins: 5
            columns: 2
            rows: 5
            ColumnLayout{
                Layout.row:0
                Layout.column:0
                Layout.preferredWidth: parent.width / 2
                Text{
                    text: "Source: "
                    width: parent * 0.3
                }
                RowLayout{
                    TextArea{
                        id: source_input
                        Layout.fillWidth: true
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
                    }
                }
            }
            ColumnLayout{
                Layout.row:0
                Layout.column:1
                Layout.preferredWidth: parent.width / 2
                Text{
                    text: "Destination: "
                    width: parent * 0.1
                }
                RowLayout{
                    TextArea{
                        id: destination_input
                        Layout.fillWidth: true
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
                    }
                }

            }
        }
    }
}
