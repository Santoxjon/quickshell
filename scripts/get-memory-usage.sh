#!/usr/bin/env bash

set -uo pipefail
export LC_ALL=C

readonly meminfo_file=/proc/meminfo
readonly poll_interval=1

if [[ ! -r $meminfo_file ]]; then
    printf 'memory-usage: cannot read %s\n' "$meminfo_file" >&2
    exit 1
fi

while true; do
    awk '
        $1 == "MemTotal:" {
            total = $2
            have_total = 1
        }

        $1 == "MemAvailable:" {
            available = $2
            have_available = 1
        }

        END {
            if (!have_total || !have_available || total <= 0) {
                print "{\"percentUsage\":\"--%\",\"gbUsage\":\"--GB / --GB\"}"
                exit
            }

            if (available < 0)
                available = 0
            else if (available > total)
                available = total

            used = total - available
            percent = int(used * 100 / total)
            used_gb = used / 1024 / 1024
            total_gb = total / 1024 / 1024
            total_gb = int(total_gb) + (total_gb > int(total_gb))

            printf "{\"percentUsage\":\"%d%%\",\"gbUsage\":\"%.1fGB / %dGB\"}\n", percent, used_gb, total_gb
        }
    ' "$meminfo_file"

    sleep "$poll_interval"
done
