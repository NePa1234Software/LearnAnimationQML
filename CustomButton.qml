import QtQuick
import QtQuick.Controls

Button {
    id: control
    property alias tipText: tooltip.text
    ToolTip {
        id: tooltip
        delay: 500
        timeout: 10000
        visible: control.hovered && text != ""
        text: ""
    }

}
