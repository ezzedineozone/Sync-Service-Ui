import QtQuick
Rectangle
{
    color:"#d3d3d3"
    border.color: "#b5b5b5"
    border.width: 0.5
    height: customText.implicitHeight + 3
    width: customText.implicitWidth + 6
    Text{
        id: customText
        text:"placeholder"
        color: "black"
        anchors.left: parent.left
        anchors.leftMargin: 3
    }
    property alias innerText: customText.text
}
