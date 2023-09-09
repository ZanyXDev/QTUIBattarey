import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as QQC2
import QtGraphicalEffects 1.15
import Qt.labs.settings 1.0

import common 1.0

QQC2.ApplicationWindow {
    id: appWnd
    // ----- Property Declarations

    // Required properties should be at the top.
    readonly property int screenOrientation: Screen.orientation
    readonly property bool appInForeground: Qt.application.state === Qt.ApplicationActive
    property bool appInitialized: false

    // ----- Signal declarations
    signal screenOrientationUpdated(int screenOrientation)

    // ----- Size information
    width: (screenOrientation === Qt.PortraitOrientation) ? 320 * DevicePixelRatio : 480
                                                            * DevicePixelRatio
    height: (screenOrientation === Qt.PortraitOrientation) ? 480 * DevicePixelRatio : 320
                                                             * DevicePixelRatio
    maximumHeight: height
    maximumWidth: width

    minimumHeight: height
    minimumWidth: width
    // ----- Then comes the other properties. There's no predefined order to these.
    visible: true
    visibility: (isMobile) ? Window.FullScreen : Window.Windowed
    flags: Qt.Dialog
    title: qsTr(" ")
    Screen.orientationUpdateMask: Qt.LandscapeOrientation

    // ----- Then attached properties and attached signal handlers.

    // ----- Signal handlers
    onScreenOrientationChanged: {
        screenOrientationUpdated(screenOrientation)
        if (isDebugMode) {
            console.trace()
            AppSingleton.toLog(
                        `onScreenOrientationChanged:[${screenOrientation}]`)
            AppSingleton.toLog(
                        `appWnd[height,width]:[${appWnd.height
                        / DevicePixelRatio},${appWnd.width / DevicePixelRatio}]`)
        }
    }

    Component.onDestruction: {

        //        var bgrIndex = mSettings.currentBgrIndex
        //        bgrIndex++
        //        mSettings.currentBgrIndex = (bgrIndex < 20) ? bgrIndex : 0
    }
    onAppInForegroundChanged: {
        if (appInForeground) {
            if (!appInitialized) {
                appInitialized = true
            }
        } else {
            if (isDebugMode)
                AppSingleton.toLog(
                            `appInForeground: [${appInForeground} , appInitialized: ${appInitialized}]`)
        }
    }

    background: Image {
        id: background
        anchors.fill: parent
        source: "qrc:/res/images/background2.jpg"
        fillMode: Image.PreserveAspectCrop
    }

    // ----- Visual children
    Item {
        id: mainView
        anchors.fill: parent
        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            scale: 1.52
            source: "qrc:/res/images/title.png"
        }
        QUItBattery {
            id: battery
            anchors.centerIn: parent
            value: slider.value
            charging: chargingToggle.checked
            maxLiquidRotation: liquidToggle.checked ? 50 : 0
            rotation: -90
            SequentialAnimation on rotation {
                running: rotateToggle.checked
                loops: Animation.Infinite
                NumberAnimation {
                    to: -120
                    duration: 2000
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    to: -70
                    duration: 1000
                    easing.type: Easing.InOutQuad
                }
            }
        }
        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            y: 80 * DevicePixelRatio
            source: "qrc:/res/images/arrows.png"
            opacity: !rotateToggle.checked
            Behavior on opacity {
                NumberAnimation {
                    duration: 400
                    easing.type: Easing.InOutQuad
                }
            }
            MouseArea {
                anchors.centerIn: parent
                width: battery.width
                height: 200 * DevicePixelRatio
                enabled: !rotateToggle.checked
                onPositionChanged: {
                    battery.rotation = (mouseX - width * 0.5) * 0.2 - 90
                }
                onReleased: {
                    rotateBackAnimation.start()
                }
                onCanceled: {
                    rotateBackAnimation.start()
                }
                onPressed: {
                    rotateBackAnimation.stop()
                }
            }
        }
        NumberAnimation {
            id: rotateBackAnimation
            target: battery
            property: "rotation"
            to: -90
            duration: 3000
            easing.type: Easing.OutElastic
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8 * DevicePixelRatio
            spacing: 4 * DevicePixelRatio
            Slider {
                id: slider
                width: 150 * DevicePixelRatio
                text: "- Battery Level +"
                value: 0.5
            }
            ToggleButton {
                id: chargingToggle
                icon: "qrc:/res/images/plug.png"
            }
            ToggleButton {
                id: liquidToggle
                icon: "qrc:/res/images/glass.png"
            }
            ToggleButton {
                id: rotateToggle
                icon: "qrc:/res/images/rotate.png"
            }
        }
    }
    //  ----- non visual children
    Settings {
        id: mSettings
        category: "BackgroundItem"
        property int currentBgrIndex
    }

    // ----- JavaScript functions
}
