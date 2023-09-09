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
                NumberAnimation { to: -120; duration: 2000; easing.type: Easing.InOutQuad }
                NumberAnimation { to: -70; duration: 1000; easing.type: Easing.InOutQuad }
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
