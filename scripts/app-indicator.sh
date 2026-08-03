#!/usr/bin/env bash

set -uo pipefail
export LC_ALL=C

require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        printf 'app-indicator: required command not found: %s\n' "$1" >&2
        exit 127
    fi
}

for command_name in hyprctl jq socat; do
    require_command "$command_name"
done

if [[ -z ${XDG_RUNTIME_DIR:-} || -z ${HYPRLAND_INSTANCE_SIGNATURE:-} ]]; then
    printf 'app-indicator: Hyprland environment is unavailable\n' >&2
    exit 1
fi

readonly event_socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

if [[ ! -S $event_socket ]]; then
    printf 'app-indicator: event socket not found: %s\n' "$event_socket" >&2
    exit 1
fi

last_state=$'\x1f'

emit_state() {
    local state

    if ! state=$(hyprctl clients -j | jq -c '
        def application($id; $pattern):
            [
                .[]
                | select(
                    [(.class // ""), (.initialClass // "")]
                    | join(" ")
                    | ascii_downcase
                    | test($pattern)
                )
                | {
                    address,
                    workspaceId: (.workspace.id // -1),
                    focusHistoryId: (.focusHistoryID // 999999)
                }
            ]
            | sort_by(.focusHistoryId)
            | if length == 0 then
                empty
              else
                {
                    id: $id,
                    workspaceId: .[0].workspaceId,
                    windows: map({address, workspaceId})
                }
              end;

        [
            application("discord"; "discord|vesktop|legcord"),
            application("steam"; "steam"),
            application("amule"; "org\\.amule\\.amule|amule")
        ]
    '); then
        printf 'app-indicator: failed to read Hyprland clients\n' >&2
        return 1
    fi

    if [[ $state != "$last_state" ]]; then
        printf '%s\n' "$state"
        last_state=$state
    fi
}

emit_state

while IFS= read -r event; do
    case "$event" in
        openwindow* | closewindow* | movewindow*)
            emit_state
            ;;
    esac
done < <(socat -U - "UNIX-CONNECT:$event_socket")
