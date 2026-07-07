
while true; do
    iface=$(ip route | awk '/default/ {print $5; exit}')
    ipaddr=$(ip -4 addr show "$iface" 2>/dev/null | awk '/inet / {print $2; exit}' | cut -d/ -f1)
    
    [ -z "$ipaddr" ] && ipaddr="--"
    
    case "$iface" in
        wl*|wlan*) echo "󰖩 $ipaddr" ;;
        en*|eth*)  echo "󰈀 $ipaddr" ;;
        *)         echo "󰈀 $ipaddr" ;;
    esac
    
    sleep 2
done
