import QtQuick
import QtQuick.Layouts
Rectangle{
    Layout.fillWidth: true
    Layout.fillHeight: true
    ListModel{
        id: syncModules
    }
}

function addSyncModule (syncModule){
    syncModules.append(syncModule)
}
function addSyncModule(type, direction, source, destination)
