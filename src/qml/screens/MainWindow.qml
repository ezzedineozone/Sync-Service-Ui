import QtQuick
import "../components"
Window
{
    width:1026
    height:1509
    visible: true
    Rectangle{
        width:100
        height:100
        color: "white"
        ButtonMed{
            innerText:"Sync"
        }
        x:parent.x+3
    }


}

