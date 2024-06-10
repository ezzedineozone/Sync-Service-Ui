import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: outer_rectangle
    width: 50
    height: 20
    Layout.preferredWidth: width
    Layout.preferredHeight: height
    color: "lightgray"

    RowLayout {
        anchors.fill: parent
        Rectangle {
            width: outer_rectangle.width - 1
            height: parent.height
            color: "#F0F0F0"
        }
    }

    MouseArea {
        id: mouse_area
        anchors.fill: parent
        cursorShape: Qt.SizeHorCursor

        property real initialWidth: 0
        property real initialX: 0

        onPressed: {
            initialWidth = outer_rectangle.width
            initialX = mouseX
        }

        onPositionChanged: {
            var deltaX = mouseX - initialX
            var newWidth = initialWidth + deltaX
            outer_rectangle.width = Math.max(50, Math.min(80, newWidth))
        }
    }
}
