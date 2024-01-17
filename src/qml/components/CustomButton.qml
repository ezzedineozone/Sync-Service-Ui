import QtQuick
import QtQuick.Layouts
Rectangle{
    property int textFontSize: 16
    property string textFont: "Segoe UI"
    property int textFontWeight: 375
    property string innerText: "placeholder"
    property int extraHeightPadding: 0
    property int extraWidthPadding: 0
    property string mainColor:"#F3F3F3"
    property string buttonSize: "medium"

    color: mainColor

    border.width: 0.5
    border.color: "#F0F0F0"
    radius: 3

    width: customText.implicitWidth + 12 + extraWidthPadding
    height: customText.implicitHeight + 2 + extraWidthPadding

    Layout.preferredWidth: width
    Layout.preferredHeight: height
    Text{
        anchors.centerIn: parent
        id: customText
        text: innerText
        color: "black"
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

    Component.onCompleted:{loadAssets()}
    function loadAssets()
    {
        customText.text = innerText;
        customText.font.family = textFont;
        customText.font.weight = textFontWeight;
        if(buttonSize == "medium")
            customText.font.pixelSize = 16
        else if(buttonSize == "large")
            customText.font.pixelSize = 18
        else
            customText.font.pixelSize = 13
    }
}
