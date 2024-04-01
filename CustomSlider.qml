import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic as T

T.Slider{
    id: control

    implicitWidth: 500
    property color color: "green"
    property color backgroundColor: "red"
    property color borderColor: "black"

    from: 0.0
    to: 1.0
    value: 0.5
    orientation: Qt.Horizontal
    enabled: false

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 4
        width: control.availableWidth
        height: implicitHeight
        radius: 2
        color: control.backgroundColor
        border.color: control.borderColor

        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            color: control.color
            radius: 2
            border.color: control.borderColor
        }
    }
}
