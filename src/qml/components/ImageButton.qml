import QtQuick
import QtQuick.Layouts
Rectangle{
    property int _defaultLeftRightPadding:12
    property int _defaultTopBottomPadding:2

    property string imageUrl:""
    property int extraHeightPadding: 0
    property int extraWidthPadding: 0
    property int leftPadding:0
    property string mainColor:"#F3F3F3"
    property string buttonSize: "medium"
    property string title: ""

    color: "#F5F5F5"

    border.width: 0
    border.color: "#b5b5b5"
    radius: 3

    width: innerImage.width + customText.implicitWidth + _defaultLeftRightPadding + extraWidthPadding + leftPadding
    height: innerImage.height + _defaultTopBottomPadding + extraHeightPadding

    Layout.preferredWidth: width
    Layout.preferredHeight: height
    RowLayout{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenterOffset:- (parent.width/2) + (innerImage.width + customText.width)/2 + 7 + leftPadding
        spacing:7
        Image{
            id: innerImage
            width:45
            height:45
            Layout.preferredWidth: width
            Layout.preferredHeight: height
            Layout.row:0
        }
        Text{
            id: customText
            text:title
            Layout.row:1
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
        innerImage.source = imageUrl
    }
}
