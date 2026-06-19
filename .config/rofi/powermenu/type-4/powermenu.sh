#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Power Menu
#
## Available Styles
#
## style-1   style-2   style-3   style-4   style-5

# Текущая тема
dir="$HOME/.config/rofi/powermenu/type-4"
theme='style-3' # <--- можете поменять на нужный стиль (1-5)

# CMDs (В NixOS uptime и hostname доступны глобально, если пакеты coreutils/procps в системе)

host=$(hostname)

# Options (Иконки)
shutdown=''
reboot=''
lock=''
logout=''
yes=''
no=''

# Rofi CMD
rofi_cmd() {
    rofi -dmenu \
        -p "Goodbye ${USER}" \
        -mesg "Uptime: $uptime" \
        -theme "${dir}/${theme}.rasi"
}

# Confirmation CMD
confirm_cmd() {
    rofi -dmenu \
        -p 'Confirmation' \
        -mesg 'Are you Sure?' \
        -theme "${dir}/shared/confirm.rasi"
}

# Ask for confirmation
confirm_exit() {
    echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$lock\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
    selected="$(confirm_exit)"
    if [[ "$selected" == "$yes" ]]; then
        if [[ $1 == '--shutdown' ]]; then
            systemctl poweroff
        elif [[ $1 == '--reboot' ]]; then
            systemctl reboot
        elif [[ $1 == '--logout' ]]; then
            # Исправлено под современные сессии / Wayland / X11
            if [[ "$DESKTOP_SESSION" == 'openbox' ]]; then
                openbox --exit
            elif [[ "$DESKTOP_SESSION" == 'bspwm' ]]; then
                bspc quit
            elif [[ "$DESKTOP_SESSION" == 'i3' ]]; then
                i3-msg exit
            elif [[ "$DESKTOP_SESSION" == 'plasma' ]]; then
                qdbus org.kde.ksmserver /KSMServer logout 0 0 0
            elif command -v hyprctl >/dev/null 2>&1; then
                hyprctl dispatch exit # Поддержка Hyprland
            elif command -v swaymsg >/dev/null 2>&1; then
                swaymsg exit # Поддержка Sway
            fi
        fi
    else
        exit 0
    fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
        run_cmd --shutdown
        ;;
    $reboot)
        run_cmd --reboot
        ;;
    $lock)
        # КРИТИЧЕСКИЙ СБОЙ ДЛЯ NIXOS ИСПРАВЛЕН ТУТ:
        # Вместо жесткого пути /usr/bin/ проверяем наличие утилит в окружении ($PATH)
        if command -v betterlockscreen >/dev/null 2>&1; then
            betterlockscreen -l
        elif command -v i3lock >/dev/null 2>&1; then
            i3lock
        elif command -v swaylock >/dev/null 2>&1; then
            swaylock # Если вы на Wayland/Sway/Hyprland
        elif command -v hyprlock >/dev/null 2>&1; then
            hyprlock # Если используете hyprlock
        fi
        ;;
    $logout)
        run_cmd --logout
        ;;
esac
