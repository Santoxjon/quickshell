while true; do
    temp=$(sensors 2>/dev/null | awk '
    function read_temp(line, value) {
      line = substr(line, index(line, ":") + 1)

      if (!match(line, /[-+]?[0-9]+([.][0-9]+)?/))
        return ""

      value = substr(line, RSTART, RLENGTH)
      return value + 0
    }

    function consider(priority, line, value) {
      value = read_temp(line)

      if (value == "")
        return

      if (!found || priority < best_priority) {
        best_temp = value
        best_priority = priority
        found = 1
      }
    }

    /^[^[:space:]][^:]*$/ {
      cpu_chip = $0 ~ /^(coretemp|k10temp|zenpower|cpu_thermal|soc_thermal|fam15h_power)/
      next
    }

    /^Package id [0-9]+:/ {
      consider(1, $0)
      next
    }

    /^Tctl:/ {
      consider(2, $0)
      next
    }

    /^Tdie:/ {
      consider(3, $0)
      next
    }

    /^(CPU|CPU Temp|CPU Package|Physical id [0-9]+):/ {
      consider(4, $0)
      next
    }

    /^Core [0-9]+:/ {
      value = read_temp($0)

      if (value != "" && (!core_found || value > core_temp)) {
        core_temp = value
        core_found = 1
      }

      next
    }

    cpu_chip && /^temp[0-9]+:/ {
      consider(6, $0)
    }

    END {
      if (found)
        printf "%d°C", best_temp
      else if (core_found)
        printf "%d°C", core_temp
    }
    ')
    
    [ -z "$temp" ] && temp="--°C"
    echo "$temp"
    sleep 2
done
