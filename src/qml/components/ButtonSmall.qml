import QtQuick
import QtQuick.Layouts
Rectangle
{
    // default values set here
    //anything without a default value can be left empty
    // storing them in variables helps with easier customization
    property string mainColor: "#F3F3F3"
    property string innerFont: "Segoe UI"
    property int innerFontWeight: 400
    property string innerText: "placeHolder"
    property string imageUrl : ""
    property int extraHeightPadding
    property int extraWidthPadding



    id: buttonSmall
    color:mainColor
    border.color: "#b5b5b5"
    border.width: 0.5
    radius:3
    height: customText.implicitHeight + 2 + extraHeightPadding
    width: customText.implicitWidth + 12 + extraWidthPadding
    ColumnLayout{
        anchors.fill:parent
        spacing:0
        Text{
            id: customText
            color: "black"
            anchors.centerIn: parent
            font.pixelSize: 13
            Layout.column:0
        }
        Image{
            id: customImage
            Layout.preferredWidth: 45
            Layout.preferredHeight: 45
            width:45
            height:45
            Layout.column:1
        }
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
        customText.font.family = innerFont;
        customText.font.weight = innerFontWeight;
        if(imageUrl != "")
        {
            customImage.source = imageUrl;
            customText.Layout.column = 1;
            customImage.Layout.column = 0;
            buttonSmall.width = customImage.width + extraWidthPadding;
            buttonSmall.height = customImage.height + extraHeightPadding;
        }
    }

}
