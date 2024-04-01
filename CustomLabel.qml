import QtQuick
import QtQuick.Controls

Label {
    id: control
    text: ""
    property alias borderColor: rect.border.color
    property alias tipText: tooltip.text

    Rectangle
    {
        id: rect
        anchors.fill: parent
        color: "transparent"
        border.color: "blue"
        HoverHandler { id: hover }
        ToolTip {
            id: tooltip
            delay: 500
            timeout: 10000
            visible: hover.hovered && text != ""
            text: ""
        }
    }
}
