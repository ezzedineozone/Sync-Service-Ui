import QtQuick
import QtQuick.Layouts
Rectangle{
    property int textFontSize: 16
    property string textFont: "Segoe UI"
    property int textFontWeight: 350
    property string innerText: "placeholder"
    property int extraHeightPadding: 3
    property int extraWidthPadding: 5
    property double border_width: 0
    property string mainColor:"#F3F3F3"
    property string buttonSize: "medium"
    property var behavior
    color: mainColor

    border.width: border_width
    border.color: "lightgray"
    radius: 1

    width: customText.implicitWidth + 12 + extraWidthPadding
    height: customText.implicitHeight + 2 + extraHeightPadding

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
        onReleased: {
            behavior()
        }
    }

    Component.onCompleted:{loadAssets()}
    function loadAssets()
    {
        customText.text = innerText;
        customText.font.family = textFont;
        customText.font.weight = textFontWeight;
        if(buttonSize === "medium")
        {
            customText.font.pixelSize = 13
        }
        else if(buttonSize === "large")
            customText.font.pixelSize = 13
        else if(buttonSize === "small")
            customText.font.pixelSize = 13
    }
}
