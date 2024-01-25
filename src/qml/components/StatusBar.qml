import QtQuick
import QtQuick.Layouts
Rectangle{
    height:30
    Layout.preferredHeight: height
    color: "#F0F0F0"
    RowLayout{
        id: contents
        anchors.verticalCenter: parent.verticalCenter
        spacing: 3
        Text{
            Layout.leftMargin: 30
            text:"Status: "
        }

        ProgressBar{
            width: 125
        }
    }
}
