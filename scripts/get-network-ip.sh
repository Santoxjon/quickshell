#!/usr/bin/env bash

set -uo pipefail
export LC_ALL=C

readonly poll_interval=2

if ! command -v ip >/dev/null 2>&1; then
    printf 'network-address: required command not found: ip\n' >&2
    exit 127
fi

read_address() {
    local interface
    local address

    interface=$(ip -4 route show default 2>/dev/null | awk '
        {
            for (field = 1; field <= NF; field++) {
                if ($field == "dev") {
                    print $(field + 1)
                    exit
                }
            }
        }
    ')

    if [[ -z $interface ]]; then
        printf '%s\n' "--"
        return
    fi

    address=$(ip -4 -o address show dev "$interface" scope global 2>/dev/null | awk '
        {
            for (field = 1; field <= NF; field++) {
                if ($field == "inet") {
                    split($(field + 1), parts, "/")
                    print parts[1]
                    exit
                }
            }
        }
    ')

    if [[ -z $address ]]; then
        address="--"
    fi

    printf '%s\n' "$address"
}

while true; do
    read_address
    sleep "$poll_interval"
done
