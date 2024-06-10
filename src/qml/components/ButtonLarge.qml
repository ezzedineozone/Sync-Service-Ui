import QtQuick
Rectangle
{
    property alias innerText: customText.text
    property alias innerFont: customText.font.family
    property alias innerFontWeight: customText.font.weight
    property string mainColor: "#F3F3F3"
    property int extraHeightPadding
    property int extraWidthPadding



    id: buttonSmall
    color:mainColor
    border.color: "#b5b5b5"
    border.width: 0.5
    radius:3
    height: customText.implicitHeight + 2 + extraHeightPadding
    width: customText.implicitWidth + 12 + extraWidthPadding
    Text{
        id: customText
        text:"placeholder"
        color: "black"
        anchors.centerIn: parent
        font.pixelSize: 18
        font.family:"Segoe UI"
        font.weight: 400
    }
    MouseArea{
        anchors.fill:parent
        hoverEnabled:true
        onEntered:{
            parent.color = "#e8e6e6"
        }
        onExited:{
            parent.color = mainColor
        }
    }
}
