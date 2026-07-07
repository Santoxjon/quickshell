while true; do
    temp=$(sensors 2>/dev/null | awk '
    /^Package id 0:/ {
      gsub(/[+°C]/, "", $4)
      printf "%d°C", $4
      exit
    }
    ')
    
    [ -z "$temp" ] && temp="--°C"
    echo "$temp"
    sleep 2
done