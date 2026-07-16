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
        printf '{"totalUsage":null,"cores":[]}\n'
        sleep "$retry_interval"
        continue
    fi

    awk '
        BEGIN {
            total_usage = "null"
            cores = ""
        }

        /^Average:/ {
            idle = $NF
            usage = int(100 - idle)

            if (usage < 0)
                usage = 0
            else if (usage > 100)
                usage = 100

            if ($2 == "all") {
                total_usage = usage
            } else if ($2 ~ /^[0-9]+$/) {
                if (cores != "")
                    cores = cores ","

                cores = cores sprintf("{\"id\":%d,\"usage\":%d}", $2, usage)
            }
        }

        END {
            printf "{\"totalUsage\":%s,\"cores\":[%s]}\n", total_usage, cores
        }
    ' <<< "$sample"
done
