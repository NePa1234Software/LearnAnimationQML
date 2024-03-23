import QtQml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Timeline

Rectangle {

    id: control
    implicitWidth: 300
    implicitHeight: 500

    property alias levelIn: inSlider.value
    onLevelInChanged: {
        if (levelIn >= prevLevel)
            rising = true;
        else
            rising = false;
        prevLevel = levelIn;
    }
    property real levelOut: 0.3

    // State handling - internal
    property real prevLevel: 0.5
    property bool rising: true
    readonly property bool animating: animationSwitch.checked

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        Label { text: "Move the top slider..."; Layout.fillHeight: false; Layout.fillWidth: true  }

        GridLayout {
            Layout.fillWidth: true
            columns: 2

            // User input
            Label { text: "In" }
            CustomSlider{
                id: inSlider
                enabled: true
                Layout.fillWidth: true
            }

            // Readonly display
            Label { text: "Transition" }
            CustomSlider{
                id: stateSlider
                Layout.fillWidth: true
                // this value is solely handled by the states/transitions
                // value: DEFAULT
            }

            ///////////////////////////////////////////////////////////////////////////
            // Simple Behavior on NumberAnimation
            // used to smooth the property
            ///////////////////////////////////////////////////////////////////////////
            Label { text: "NumberAnimation" }
            CustomSlider{
                id: numSlider
                value: inSlider.value
                // click NumberAnimation<HERE> to get the lightbulb in QtCreator editor to get the animation dialog
                Behavior on value { enabled: control.animating;
                                    NumberAnimation { easing.amplitude: 1.2; easing.period: 0.43; easing.type: Easing.InOutElastic; duration: 1000 } }
                Layout.fillWidth: true
            }

            ///////////////////////////////////////////////////////////////////////////
            // StandAlone activation of PropertyAnimation
            // Activation on some signal, e.g. when user presses the button
            ///////////////////////////////////////////////////////////////////////////
            Button {
                text: "Click me!"
                enabled: control.animating
                Layout.fillWidth: true
                onClicked: { manAnimator.start() }

                // click PropertyAnimation<HERE> to get the lightbulb in QtCreator editor to get the animation dialog
                PropertyAnimation {
                    id: manAnimator;
                    target: manSlider; property: "value";
                    easing.amplitude: 1.2;
                    easing.period: 0.43;
                    easing.type: Easing.OutBounce;
                    duration: 1000
                    loops: 3
                    to: inSlider.value }
            }
            CustomSlider {
                id: manSlider
                Layout.fillWidth: true
            }

            ///////////////////////////////////////////////////////////////////////////
            // Behavor on adds the enabled property which optionally switches the
            // animation on or off. In this case when animation is allowed and the
            // slider is moved to the left (falling).
            ///////////////////////////////////////////////////////////////////////////
            Label { text: "Optional" }
            CustomSlider{
                id: optSlider
                value: inSlider.value
                Behavior on value { enabled: control.animating && !control.rising;
                                    NumberAnimation {
                                        easing.amplitude: 1.2;
                                        easing.period: 0.43;
                                        easing.type: Easing.InOutElastic;
                                        duration: 1000 } }
                Layout.fillWidth: true
            }

            ///////////////////////////////////////////////////////////////////////////
            // Custom Behavior on
            ///////////////////////////////////////////////////////////////////////////
            Label { text: "Custom Behavior" }
            CustomSlider{
                id: customSlider
                value: inSlider.value
                DelayedFallingBehavior on value {
                    enabled: control.animating;
                }
                Layout.fillWidth: true
            }

            ///////////////////////////////////////////////////////////////////////////
            // Timeline animation
            ///////////////////////////////////////////////////////////////////////////
            Button {
                text: "Timeline start!"
                enabled: control.animating
                Layout.fillWidth: true
                onClicked: { timelineAnimation.start() }
            }
            CustomSlider {
                id: timelineSlider
                Layout.fillWidth: true
            }
        }
        Switch {
            id: animationSwitch
            text: checked ? "Animate (ON)" : "Animate (OFF)"
        }
        Label {
            text: "State: %1".arg(control.state)
        }
        Label {
            text: control.rising ? "rising" : "falling"
        }
        Item { id: spacer; Layout.fillHeight: true }
    }

    states: [
        // Top down priority...
        State {
            name: "no animation"
            when: !control.animating
            // Make a new binding
            PropertyChanges {
                stateSlider.value: inSlider.value
            }
        },
        State {
            name: "moving"
            when: inSlider.pressed
            // Break the binding so that it doesnt move
            PropertyChanges {
                explicit: true
                stateSlider.value: inSlider.value
            }
        },
        State {
            name: "rising"
            when: control.rising
            // Break the binding so that it doesnt move
            PropertyChanges {
                explicit: true
                stateSlider.value: inSlider.value
            }
        },
        State {
            name: "falling"
            when: !control.rising
            // Break the binding so that it doesnt move
            PropertyChanges {
                explicit: true
                stateSlider.value: inSlider.value
            }
        }
    ]
    transitions: [
        Transition {
            to: "rising"
            PropertyAnimation {
                to: control.levelIn
                //onToChanged: restart()
                target: stateSlider
                property: "value"
                duration: 100
            }
        },
        Transition {
            to: "falling"
            PropertyAnimation {
                to: control.levelIn
                //onToChanged: restart()
                target: stateSlider
                property: "value"
                duration: 1000
                alwaysRunToEnd: true
            }
        }
    ]

    Timeline {
        id: timeline
        animations: [
            TimelineAnimation {
                id: timelineAnimation
                //onFinished: node.restoreDefaults()
                running: false
                loops: 1
                duration: 5000
                to: 2000
                from: 0
                pingPong: true
            }
        ]
        startFrame: 0
        endFrame: 2000
        enabled: true

        KeyframeGroup {
            target: timelineSlider
            property: "value"
            Keyframe {
                value: 0
                frame: 100
            }

            Keyframe {
                value: 0.4
                frame: 500
            }

            Keyframe {
                value: 0.6
                frame: 1500
            }

            Keyframe {
                value: 0.5
                frame: 1700
            }

            Keyframe {
                value: 1.0
                frame: 2000
            }
        }
    }
}
