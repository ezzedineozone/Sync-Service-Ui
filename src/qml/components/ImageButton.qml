import QtQuick
import QtQuick.Layouts
Rectangle{
    property string imageUrl:""
    property int extraHeightPadding: 0
    property int extraWidthPadding: 0
    property string mainColor:"#F3F3F3"
    property string buttonSize: "medium"

    color: "#F5F5F5"

    border.width: 0.5
    border.color: "#b5b5b5"
    radius: 3

    width: innerImage.width + 12 + extraWidthPadding
    height: innerImage.height + 2 + extraHeightPadding

    Layout.preferredWidth: width
    Layout.preferredHeight: height

    Image{
        anchors.centerIn: parent
        id: innerImage
        width:45
        height:45
        Layout.preferredWidth: width
        Layout.preferredHeight: height
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
        innerImage.source = imageUrl
    }
}
