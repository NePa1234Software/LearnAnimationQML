import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: control
    width: 500
    height: 800
    title: "Learning Animations"
    visible: true

    // fill parent looks terrible (Browser/WebAssembly), thus ensure the smaller size
    CustomControl { Layout.fillHeight: true; Layout.fillWidth: true }
}
