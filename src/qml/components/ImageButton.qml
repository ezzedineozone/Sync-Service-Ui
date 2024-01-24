import QtQuick
import QtQuick.Layouts
Rectangle{
    property int _defaultLeftRightPadding:0
    property int _defaultTopBottomPadding:0

    property string imageUrl:""
    property int extraHeightPadding: 10
    property int extraWidthPadding: 10
    property int leftPadding:5
    property string mainColor:"#F5F5F5"
    property string clickColor: "#d9d7d7"
    property string hoverColor: "#e8e6e6"
    property string buttonSize: "medium"
    property string title: ""

    color: mainColor

    border.color: "black"
    border.width:0
    radius: 6

    width: innerImage.width + customText.implicitWidth + _defaultLeftRightPadding + extraWidthPadding + leftPadding + 10
    height: innerImage.height + _defaultTopBottomPadding + extraHeightPadding

    Layout.preferredWidth: width
    Layout.preferredHeight: height
    RowLayout{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenterOffset:- (parent.width/2) + (innerImage.width + customText.implicitWidth + 10)/2  + leftPadding
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
