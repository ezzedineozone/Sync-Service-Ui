import QtQuick
import QtQuick.Layouts
Rectangle{

    property int padding: 5
    property int leftPadding:0
    property int rightPadding:15
    property int bottomPadding:0
    property int topPadding:0
    property string imageUrl:""
    property string mainColor:"#F5F5F5"
    property string clickColor: "#d9d7d7"
    property string hoverColor: "#e8e6e6"
    property string buttonSize: "medium"
    property string title: ""

    color: mainColor

    border.color: "black"
    border.width:0
    radius: 6

    width: contents.implicitWidth + 2 * padding + leftPadding + rightPadding
    height: contents.implicitHeight + 2 *  padding + topPadding + bottomPadding

    Layout.preferredWidth: width
    Layout.preferredHeight: height
    RowLayout{
        id: contents
        anchors.left: parent.left
        anchors.right:parent.right
        anchors.top:parent.top
        anchors.bottom:parent.bottom
        anchors.leftMargin: padding + leftPadding
        anchors.rightMargin: padding + rightPadding
        anchors.topMargin: padding + topPadding
        anchors.bottomMargin: padding + bottomPadding
        spacing:10
        Image{
            id: innerImage
            width:40
            height:40
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
            parent.color = hoverColor
        }
    }

    Component.onCompleted:{loadAssets()}
    function loadAssets()
    {
        innerImage.source = imageUrl
    }
}
