pragma Singleton

import QtQuick 2.15

QtObject {
  id: root
  readonly property int largeFontSize: 36
  readonly property int middleFontSize: 24
  readonly property int averageFontSize: 16
  readonly property int smallFontSize: 12
  readonly property int tinyFontSize: 10


  /* This is msecs. Half of second is enough for smooth animation. */
  readonly property int timer16: 16
  readonly property int timer200: 200
  readonly property int timer500: 500
  readonly property int timer800: 800
  readonly property int timer1000: 1000
  readonly property int timer2000: 2000
  readonly property int timer4000: 4000

  function toLog(msg) {
    console.log(`${msg}`)
  }
}
