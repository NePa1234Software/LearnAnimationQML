import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: control
    width: 300
    height: 500
    title: "Learning Animations"
    visible: true


    ColumnLayout {
        anchors.fill: parent
        CustomControl { Layout.fillHeight: true; Layout.fillWidth: true }
    }
}
