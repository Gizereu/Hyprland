import QtQuick
import Quickshell
import qs.Commons
import qs.Services
import qs.Widgets

Item {
    implicitWidth: Math.max(100, text.contentWidth)
    implicitHeight: Style.barHeight

    NText {
        id: text
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        // English format: YYYY-MM-DD | HH:mm | Day
        readonly property string dateTimeString: {
            const days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
            const dayName = days[Time.now.getDay()];
            return `${Time.date}  |  ${Time.time}  |  ${dayName}`;
        }

        text: dateTimeString

        font {
            letterSpacing: 1
            weight: Style.fontWeightLight
        }
    }
}
