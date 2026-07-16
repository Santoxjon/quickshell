#!/usr/bin/env bash

set -uo pipefail
export LC_ALL=C

readonly retry_interval=1

if ! command -v mpstat >/dev/null 2>&1; then
    printf 'cpu-usage: required command not found: mpstat\n' >&2
    exit 127
fi

while true; do
    if ! sample=$(mpstat -P ALL 1 1); then
        printf 'cpu-usage: failed to read processor statistics\n' >&2
        printf '{"usage":"--%%","tooltipText":"CPU data unavailable"}\n'
        sleep "$retry_interval"
        continue
    fi

    awk '
        BEGIN {
            main = "--%"
            tooltip = ""
        }

        /^Average:/ {
            idle = $NF
            usage = int(100 - idle)

            if (usage < 0)
                usage = 0
            else if (usage > 100)
                usage = 100

            if ($2 == "all")
                main = sprintf("%02d%%", usage)

            if ($2 ~ /^[0-9]+$/)
                tooltip = tooltip sprintf("Core %2d: %3d%%\\n", $2, usage)
        }

        END {
            sub(/\\n$/, "", tooltip)
            printf "{\"usage\":\"%s\",\"tooltipText\":\"%s\"}\n", main, tooltip
        }
    ' <<< "$sample"
done
