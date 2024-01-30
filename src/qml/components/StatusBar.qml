import QtQuick
import QtQuick.Layouts
Rectangle{
    property int leftMargin: 20
    property int numOfElements:2
    property bool displayVersion: false
    height:30
    Layout.preferredHeight: height
    color: "#ededed"
    RowLayout{
        id: contents
        anchors.verticalCenter: parent.verticalCenter
        anchors.fill:parent
        spacing: 3
        Text{
            id: textTitle
            Layout.bottomMargin: 3
            font.pixelSize:14
            color:"#636363"
            Layout.leftMargin: leftMargin
            text:"Status: "
        }

        ProgressBar{
            id: progressBar
            width: 125
        }

        Text{
            id: appVersionText
            visible:false
            Layout.bottomMargin: 3
            Layout.leftMargin: parent.width - textTitle.implicitWidth - appVersionText.implicitWidth - progressBar.width - numOfElements*leftMargin - (numOfElements - 1) * parent.spacing
        }
    }
    function progressRate(a: double)
    {
        progressBar.modifyCompletion(a);
    }
    Component.onCompleted: {
        if(displayVersion === true)
        {
            appVersionText.visible = true;
            appVersionText.text = "V " + appMetadata.appVersion;
        }
    }
}
