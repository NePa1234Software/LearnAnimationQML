import QtQuick
import QtQuick.Controls

Label {
    id: control
    text: ""
    property alias borderColor: rect.border.color

    Rectangle
    {
        id: rect
        anchors.fill: parent
        color: "transparent"
        border.color: "blue"
    }
}
