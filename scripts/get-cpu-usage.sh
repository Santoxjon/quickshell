#!/usr/bin/env bash

while true; do
    mpstat -P ALL 1 1 | awk '
    BEGIN {
        tooltip = ""
    }

    /^Average:/ {
        idle = $NF
        gsub(",", ".", idle)
        usage = int(100 - idle)

        if ($2 == "all") {
            main = sprintf("%02d%%", usage)
        }

        if ($2 ~ /^[0-9]+$/) {
            tooltip = tooltip sprintf("Core %2d: %3d%%\\n", $2, usage)
        }
    }

    END {
        sub(/\\n$/, "", tooltip)

        gsub(/"/, "\\\"", tooltip)

        printf "{\"usage\":\"%s\",\"tooltipText\":\"%s\"}\n", main, tooltip
    }
    '
done