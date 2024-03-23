import QtQuick

Behavior {
    id: root
    readonly property Item fallTarget: targetProperty.object
    readonly property string fallPropertyName: targetProperty.name
    property int fallDelay: 500
    property int fallDuration: 1000
    property int riseDelay: 0
    property int riseDuration: 200

    property real prevLevel: 0
    property bool rising: true
    onTargetValueChanged: {
        if (targetValue >= prevLevel)
            rising = true;
        else
            rising = false;
        prevLevel = targetValue;
    }

    SequentialAnimation {
        PauseAnimation {
            duration: root.rising ? root.riseDelay : root.fallDelay
        }
        NumberAnimation {
            target: root.fallTarget
            property: root.fallPropertyName
            to: root.targetValue
            easing.type: Easing.OutQuad
            duration: root.rising ? root.riseDuration : root.fallDuration
        }
        PropertyAction { } // actually change the controlled property
    }
}
