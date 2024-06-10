import QtQuick
import QtQuick.Layouts
Rectangle{

    property int padding: 5
    property int leftPadding:5
    property int rightPadding:15
    property int bottomPadding:0
    property int topPadding:0
    property string imageUrl:""
    property string mainColor:"#F5F5F5"
    property string clickColor: "#d9d7d7"
    property string hoverColor: "#e8e6e6"
    property string buttonSize: "medium"
    property int imageWidth:40
    property int imageHeight:40
    property int inner_spacing: 10
    property string title: ""
    property var behavior
    color: mainColor

    border.color: "black"
    border.width:0
    radius: 0
    Layout.preferredWidth: contents.implicitWidth + 2 * padding + leftPadding + rightPadding
    Layout.preferredHeight: contents.implicitHeight + 2 *  padding + topPadding + bottomPadding
    RowLayout{
        id: contents
        anchors.fill:parent
        spacing: inner_spacing
        anchors.leftMargin:leftPadding
        Image{
            id: innerImage
            width:imageWidth
            height:imageHeight
            Layout.preferredWidth: width
            Layout.preferredHeight: height
            Layout.row:0
        }
        Text{
            id: customText
            text:title
            Layout.row:1
            font.weight: 500
            font.pixelSize: 12
        }
    }

    MouseArea{
        id: mouseArea
        anchors.fill:parent
        hoverEnabled:true
        onEntered:{
            parent.color = hoverColor
        }
        onExited:{
            parent.color = mainColor
        }
        onPressed: {
            parent.color = clickColor
        }
        onReleased:{
            parent.color = hoverColor;
            console.log(behavior);
            behavior();
        }
    }

    Component.onCompleted:{loadAssets()}
    function loadAssets()
    {
        innerImage.source = imageUrl
    }
}
