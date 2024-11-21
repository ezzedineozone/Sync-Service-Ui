import QtQuick
import QtQuick.Layouts
Rectangle{
    property double completion: 0
    property string inner_text;
    property string progress_color: "#47fc7d";
    border.color: "#d6d6d6"
    border.width:1
    color: "white"
    width:250
    height:15
    Layout.preferredWidth: width
    Layout.preferredHeight: height
    Rectangle{
        anchors.left :parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: 50
        id: progress
        height: parent.height - parent.border.width * 2
        color: parent.progress_color
    }
    Text {
        text: parent.inner_text
        anchors.centerIn: parent
        color: "black"
        opacity: 0.4
    }

    function modifyCompletion(value: double)
    {
        progress.width = value * progress.parent.parent.width - progress.parent.parent.border.width;
    }

}
