import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Modules.Core
import qs.Services
import qs.Widgets

SmartPanel {
    id: root

    readonly property bool weatherReady: Config.data.weather.updateWeather && (LocationService.data.weather !== null)

    panelContent: Item {
        id: panelContent

        readonly property real contentPreferredWidth: 380
        readonly property real contentPreferredHeight: 500

        anchors.fill: parent

        Rectangle {
            id: content

            color: root.panelBackgroundColor
            width: parent.width
            height: parent.height
            radius: Style.radiusM
            topLeftRadius: root.isConnected ? 0 : undefined
            topRightRadius: root.isConnected ? 0 : undefined

            border {
                color: root.panelBorderColor
                width: root.showBorders ? Style.borderM : 0
            }

            ColumnLayout {
                id: layout

                anchors.margins: Style.marginM
                anchors.fill: parent
                spacing: Style.marginM

                NText {
                    text: ""
                    font.family: Style.JetBrainsMonoNerd
                    Layout.alignment: Qt.AlignHCenter
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter

                    NIcon {
                        id: icon

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: LocationService.parseWMO(LocationService.data.weather.current_weather.weathercode, LocationService.data.weather.current_weather.is_day)["icon"] + " "
                        color: LocationService.parseWMO(LocationService.data.weather.current_weather.weathercode, LocationService.data.weather.current_weather.is_day)["color"]
                        size: Style.fontSizeXXXL * 2
                    }

                    NText {
                        property string temp: {
                            if (!root.weatherReady)
                                return "";

                            return LocationService.data.weather.current_weather.temperature;
                        }

                        horizontalAlignment: Text.AlignHCenItemter
                        verticalAlignment: Text.AlignVCenter
                        text: temp + '°C'

                        font {
                            pixelSize: Style.fontSizeXXXL * 2
                        }

                    }

                }

                NText {
                    property int windSpeed: {
                        if (!root.weatherReady)
                            return "";

                        // convert km/h to m/s
                        return Math.round(LocationService.data.weather.current_weather.windspeed * 1000 / 3600 * 10) / 10;
                    }
                    property string windDirection: {
                        if (!root.weatherReady)
                            return "";

                        var dir = LocationService.data.weather.current_weather.winddirection;
                        var threshold = 45 / 2;
                        if (dir > 45 - threshold && dir < 45 + threshold)
                            return " SE (" + dir + "°)";

                        if (dir > 90 - threshold && dir < 90 + threshold)
                            return " E (" + dir + "°)";

                        if (dir > 135 - threshold && dir < 135 + threshold)
                            return " NE (" + dir + "°)";

                        if (dir > 180 - threshold && dir < 180 + threshold)
                            return " N (" + dir + "°)";

                        if (dir > 225 - threshold && dir < 225 + threshold)
                            return " NW (" + dir + "°)";

                        if (dir > 270 - threshold && dir < 270 + threshold)
                            return " W (" + dir + "°)";

                        if (dir > 315 - threshold && dir < 315 + threshold)
                            return " SW (" + dir + "°)";
                        else
                            return " S (" + dir + "°)";
                    }

                    text: "  " + windSpeed + " m/s " + windDirection
                    color: {
                        if (windSpeed >= 32.7)
                            return Colors.red;

                        if (windSpeed >= 24.5)
                            return Colors.orange;

                        if (windSpeed >= 13.9)
                            return Colors.yellow;

                        if (windSpeed >= 8)
                            return Colors.status_pending;

                        if (windSpeed >= 3.4)
                            return Colors.status_ok;

                        return Colors.md3.on_background;
                    }
                    font.pixelSize: Style.fontSizeL
                    Layout.alignment: Qt.AlignHCenter
                }

                NDivider {
                }

                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    ColumnLayout {
                        anchors.margins: Style.marginM
                        anchors.fill: parent
                        spacing: Style.marginS

                        Repeater {
                            model: 7

                            Row {
                                id: day

                                property string time: {
                                    if (!root.weatherReady)
                                        return "";

                                    const days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
                                    var date = new Date(LocationService.data.weather.daily.time[modelData]);
                                    return days[date.getDay()];
                                }
                                property string tempMax: {
                                    if (!root.weatherReady)
                                        return "";

                                    return LocationService.data.weather.daily.temperature_2m_max[modelData].toFixed(1);
                                }
                                property string tempMin: {
                                    if (!root.weatherReady)
                                        return "";

                                    return LocationService.data.weather.daily.temperature_2m_min[modelData].toFixed(1);
                                }
                                property string weathercode: {
                                    if (!root.weatherReady)
                                        return 0;

                                    return LocationService.data.weather.daily.weathercode[modelData];
                                }
                                property string sunset: {
                                    if (!root.weatherReady)
                                        return "";

                                    return LocationService.data.weather.daily.sunset[modelData].slice(-5);
                                }
                                property string sunrise: {
                                    if (!root.weatherReady)
                                        return "";

                                    return LocationService.data.weather.daily.sunrise[modelData].slice(-5);
                                }

                                Layout.alignment: Qt.AlignHCenter
                                spacing: Style.marginS

                                // День недели
                                NText {
                                    width: 40
                                    text: day.time
                                    size: Style.fontSizeL
                                    font.family: "JetBrains Mono"
                                }

                                // Иконка погоды
                                NIcon {
                                    width: 25
                                    text: LocationService.parseWMO(day.weathercode, true)["icon"]
                                    size: Style.fontSizeL
                                    color: LocationService.parseWMO(day.weathercode, true)["color"]
                                }

                                // Температура
                                NText {
                                    width: 110
                                    text: day.tempMax + " / " + day.tempMin
                                    size: Style.fontSizeL
                                    font.family: "JetBrains Mono"
                                }

                                // Восход
                                NText {
                                    width: 75
                                    text: " " + day.sunrise
                                    size: Style.fontSizeL
                                    color: Colors.orange
                                    font.family: "JetBrains Mono"
                                }

                                // Закат
                                NText {
                                    width: 75
                                    text: " " + day.sunset
                                    size: Style.fontSizeL
                                    color: Colors.mauve
                                    font.family: "JetBrains Mono"
                                }
                            }
                        }

                    }

                }

            }

        }

    }

}
