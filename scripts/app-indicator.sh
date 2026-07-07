#!/usr/bin/env bash

get_state() {
    hyprctl clients -j | jq -r '
    [.[].class | ascii_downcase] |
    [
      if any(.[]; test("discord|vesktop|legcord")) then "discord" else empty end,
      if any(.[]; test("steam")) then "steam" else empty end
    ] | join(" ")
    '
}

get_state

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

socat -U - UNIX-CONNECT:"$SOCKET" | while read -r event; do
    case "$event" in
        openwindow*|closewindow*|movewindow*|workspace*)
            get_state
        ;;
    esac
done