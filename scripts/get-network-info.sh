#!/usr/bin/env bash

set -uo pipefail
export LC_ALL=C

readonly poll_interval=2

read_network_info() {
    local route interface address prefix gateway dns

    route=$(ip -4 route show default 2>/dev/null | head -n 1)
    interface=$(awk '{ for (i = 1; i <= NF; i++) if ($i == "dev") { print $(i + 1); exit } }' <<< "$route")
    gateway=$(awk '{ for (i = 1; i <= NF; i++) if ($i == "via") { print $(i + 1); exit } }' <<< "$route")
    address=$(ip -4 -o address show dev "$interface" scope global 2>/dev/null | awk '{ for (i = 1; i <= NF; i++) if ($i == "inet") { print $(i + 1); exit } }')

    prefix=""
    if [[ $address == */* ]]; then
        prefix=${address##*/}
        address=${address%/*}
    fi

    dns=""
    if command -v resolvectl >/dev/null 2>&1 && [[ -n $interface ]]; then
        dns=$(resolvectl dns "$interface" 2>/dev/null | sed 's/^[^:]*:[[:space:]]*//' | xargs)
    fi
    if [[ -z $dns || $dns == "Link "* ]]; then
        dns=$(awk '$1 == "nameserver" { print $2 }' /etc/resolv.conf 2>/dev/null | xargs)
    fi

    printf '%s|%s|%s|%s\n' \
        "${address:---}" "${prefix}" "${gateway:---}" "${dns:---}"
}

if ! command -v ip >/dev/null 2>&1; then
    printf 'network-info: required command not found: ip\n' >&2
    exit 127
fi

while true; do
    read_network_info
    sleep "$poll_interval"
done
