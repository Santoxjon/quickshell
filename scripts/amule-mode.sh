#!/usr/bin/env bash

set -euo pipefail
export LC_ALL=C

readonly service_unit="amuled.service"
readonly gui_pattern='org\.amule\.amule|amule'

require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        printf 'amule-mode: required command not found: %s\n' "$1" >&2
        exit 127
    fi
}

for command_name in systemctl hyprctl jq; do
    require_command "$command_name"
done

if [[ $# -ne 1 ]]; then
    printf 'usage: %s gui|service\n' "$0" >&2
    exit 2
fi

switch_to_gui() {
    systemctl stop "$service_unit"

    if systemctl is-active --quiet "$service_unit"; then
        printf 'amule-mode: %s is still active\n' "$service_unit" >&2
        exit 1
    fi

    hyprctl dispatch 'hl.dsp.exec_cmd("amule")'
}

switch_to_service() {
    local clients_json
    local addresses
    local pids
    local address
    local pid
    local process_alive

    processes_are_alive() {
        process_alive=false

        while IFS= read -r pid; do
            [[ -z $pid ]] && continue

            if [[ ! $pid =~ ^[0-9]+$ ]]; then
                printf 'amule-mode: refusing invalid process id: %s\n' "$pid" >&2
                return 2
            fi

            if kill -0 "$pid" 2>/dev/null; then
                process_alive=true
                return 0
            fi
        done <<< "$pids"

        return 1
    }

    wait_for_gui_exit() {
        local attempts=$1
        local attempt
        local status

        for ((attempt = 0; attempt < attempts; attempt++)); do
            if processes_are_alive; then
                sleep 0.2
            else
                status=$?

                if [[ $status -eq 2 ]]; then
                    return 2
                fi

                return 0
            fi
        done

        return 1
    }

    clients_json=$(hyprctl clients -j)
    addresses=$(jq -r --arg pattern "$gui_pattern" '
        .[]
        | select(
            [(.class // ""), (.initialClass // "")]
            | join(" ")
            | ascii_downcase
            | test($pattern)
        )
        | .address
    ' <<< "$clients_json")
    pids=$(jq -r --arg pattern "$gui_pattern" '
        .[]
        | select(
            [(.class // ""), (.initialClass // "")]
            | join(" ")
            | ascii_downcase
            | test($pattern)
        )
        | .pid
    ' <<< "$clients_json")

    while IFS= read -r address; do
        [[ -z $address ]] && continue

        if [[ ! $address =~ ^0x[0-9a-fA-F]+$ ]]; then
            printf 'amule-mode: refusing invalid window address: %s\n' "$address" >&2
            exit 1
        fi

        hyprctl dispatch "hl.dsp.window.close({ window = \"address:$address\" })"
    done <<< "$addresses"

    if wait_for_gui_exit 15; then
        systemctl start "$service_unit"
        return
    fi

    while IFS= read -r pid; do
        [[ -z $pid ]] && continue

        if [[ ! $pid =~ ^[0-9]+$ ]]; then
            printf 'amule-mode: refusing invalid process id: %s\n' "$pid" >&2
            exit 1
        fi

        if kill -0 "$pid" 2>/dev/null; then
            kill -TERM "$pid"
        fi
    done <<< "$pids"

    if wait_for_gui_exit 25; then
        systemctl start "$service_unit"
        return
    fi

    printf 'amule-mode: GUI did not exit; service was not started\n' >&2
    exit 1
}

case "$1" in
    gui)
        switch_to_gui
        ;;
    service)
        switch_to_service
        ;;
    *)
        printf 'amule-mode: unsupported mode: %s\n' "$1" >&2
        exit 2
        ;;
esac
