import QtQml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Timeline

Rectangle {

    id: control
    implicitWidth: 500
    implicitHeight: 800
    border.color: "navy"
    border.width: 2

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

        Rectangle { color: "orange"; Layout.fillWidth: true; height: 8 }
        Label { text: "Move the top slider..."; Layout.fillHeight: false; Layout.fillWidth: true  }
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
        Rectangle { color: "yellow"; Layout.fillWidth: true; height: 8 }

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
            CustomLabel {
                text: "Transition"
                tipText: "This animations uses the states and transitions.\n"+
                         "States : no animation, moving, rising and falling are defined\n" +
                         "Transitions: control the animations that are triggered on state change"
            }
            CustomSlider{
                id: stateSlider
                Layout.fillWidth: true
                // value: DEFAULT
            }

            ///////////////////////////////////////////////////////////////////////////
            // Simple Behavior on NumberAnimation
            // used to smooth the property
            ///////////////////////////////////////////////////////////////////////////
            CustomLabel {
                text: "NumberAnimation"
                tipText: "Behaviour on value .... with a NumberAnimation.\n"+
                         "is the simplest to setup using a one-liner."
            }
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
            CustomButton {
                text: "Click me!"
                enabled: control.animating
                Layout.fillWidth: true
                onClicked: { manAnimator.start() }
                tipText: "To use on demand animation, create an instance of a PropertyAnimation \n"+
                         "(or any other Animation type), \n" +
                         "and then call the start() method manually. We also demonstrate loops count 3."

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
            CustomLabel {
                text: "Optional"
                tipText: "Here we make use of the Bevaviour Item enabled property.\n" +
                         "E.g. we only animate when the input value is falling."
            }
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
            CustomLabel {
                text: "Custom Behavior"
                tipText: "Here we make our own custom Bevaviour Item with our own\n" +
                         "specialized and reusable Behavour (e.g. delay, then animate)."
            }
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
            CustomButton {
                text: "Timeline start!"
                enabled: control.animating
                Layout.fillWidth: true
                onClicked: { timelineAnimation.start() }
                tipText: "Here we use the Timeline to precicely\n"+
                         "control the sequence of animations. The TimeLine\n"+
                         "pingPong property is set to true make a trip there and back again."
            }
            CustomSlider {
                id: timelineSlider
                Layout.fillWidth: true
            }
        }
        Item { id: spacer; Layout.fillHeight: true }
    }

    states: [
        // Top down priority...
        State {
            name: "no animation"
            when: !control.animating
            PropertyChanges {
                // explicit false (default) - will make a new binding
                // explicit: false
                stateSlider.value: inSlider.value
            }
        },
        State {
            name: "moving"
            when: inSlider.pressed
            PropertyChanges {
                // explicit true - will ensure there is not a binding used,
                // instead the property value is assigned
                explicit: true
                stateSlider.value: inSlider.value
            }
        },
        State {
            name: "rising"
            when: control.rising
            PropertyChanges {
                // explicit true - will ensure there is not a binding used,
                // instead the property value is assigned
                explicit: true
                stateSlider.value: inSlider.value
            }
        },
        State {
            name: "falling"
            when: !control.rising
            PropertyChanges {
                // explicit - will ensure there is not a binding used, insteas the value is assigned
                explicit: true
                stateSlider.value: inSlider.value
            }
        }
    ]
    transitions: [
        Transition {
            to: "rising"
            // click PropertyAnimation<HERE> to get the lightbulb in QtCreator editor to get the animation dialog
            PropertyAnimation {
                to: control.levelIn
                target: stateSlider
                property: "value"
                easing.type: Easing.OutElastic
                duration: 200
                alwaysRunToEnd: true
            }
        },
        Transition {
            to: "falling"
            // click PropertyAnimation<HERE> to get the lightbulb in QtCreator editor to get the animation dialog
            PropertyAnimation {
                to: control.levelIn
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
