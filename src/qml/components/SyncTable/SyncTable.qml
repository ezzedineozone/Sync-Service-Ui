import QtQuick
import QtQuick.Layouts
Rectangle{
    Layout.fillWidth: true
    Layout.fillHeight: true
    ColumnLayout{
        Repeater{
            id: repeater
            model: syncModules
            delegate:Text{
                text: model.syncId + " " + model.type + " " + model.direction + " " + model.source + " " + model.directory + "\n"
            }
        }
    }

    ListModel{
        id: syncModules
    }
    function addSyncModule(syncId, type, direction, source, directory)
    {
        syncModules.append({syncId: syncId, type: type, direction: direction, source: source, directory: directory})
    }
}


