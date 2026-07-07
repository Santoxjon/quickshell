#!/usr/bin/env bash

while true; do
    awk '
    /MemTotal/ { total=$2 }
    /MemAvailable/ { available=$2 }
    END {
      used = total - available
      percent = int(used * 100 / total)
      used_gb = used / 1024 / 1024

      printf "{\"percentUsage\":\"%d%%\",\"gbUsage\":\"%.1fGB\"}\n", percent, used_gb
    }
    ' /proc/meminfo
    
    sleep 1
done