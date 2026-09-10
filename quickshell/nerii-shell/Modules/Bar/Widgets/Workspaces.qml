import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.Commons
import qs.Widgets

Row {
    spacing: Style.marginM

    Repeater {
        id: repeater
        model: 10

        NText {
            // Тернарник или null, если не найден
            property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1) ?? null
            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

            // Прямое логическое выражение вместо if/else
            property bool onScreen: bar_root.screen?.name === ws?.monitor?.name

            // Безопасное обращение через optional chaining + includes
            property bool keep: Boolean(Config.data?.bar?.keepWorkspaces?.[bar_root.screen?.name]?.includes(index + 1))

            // Nullish coalescing (??) заменяет ветвление
            // Задаешь массив символов
            property var icons: ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"]

            // Берешь символ из массива, если в конфиге ничего не задано
            property string label: Config.data?.bar?.workspaceIcons?.[index + 1] ?? icons[index]
            text: label
            visible: ws ? onScreen : keep
            color: isActive
            ? Colors.md3.primary
            : (ws ? Colors.md3.on_background : Colors.md3.surface_container_highest)

            font {
                family: Style.fontDefault
                weight: Style.fontWeightSemiBold
                pixelSize: Style.fontSizeL
            }

            Behavior on color {
                ColorAnimation { duration: Style.animationFast }
            }
        }
    }
}
