import QtQuick 2.15

Item {
    id: root
    width: 112 * DevicePixelRatio
    height: 112 * DevicePixelRatio

    property bool checked: false
    property alias icon: buttonIcon.source

    signal toggled

    Image {
        id: handle
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/res/images/handle.png"
    }

    Image {
        id: toggle
        anchors.centerIn: parent
        source: "qrc:/res/images/toggle.png"
        opacity: checked ? 0.6 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: 200
            }
        }
    }

    Image {
        id: buttonIcon
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            checked = !checked
            root.toggled()
        }
    }
}
