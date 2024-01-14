import QtQuick
Rectangle
{
    color:"#F3F3F3"
    border.color: "#b5b5b5"
    border.width: 0.5
    radius:3
    height: customText.implicitHeight + 2 + extraHeightPadding
    width: customText.implicitWidth + 5 + extraWidthPadding
    Text{
        id: customText
        text:"placeholder"
        color: "black"
        anchors.centerIn: parent
        font.pixelSize: 13
        font.family:"Segoe UI"
        font.weight: 400
    }
    property alias innerText: customText.text
    property alias innerFont: customText.font.family
    property alias innerFontWeight: customText.font.weight
    property int extraHeightPadding
    property int extraWidthPadding
}
