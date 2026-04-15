#!/bin/bash
LOGFILE=`cat ~/.tmp.filetomonitor.genmon`
ICON_NORMAL=""
ICON_ALERT="/usr/share/icons/Adwaita/symbolic/status/software-update-urgent-symbolic.svg"

# if log doesn't exist, nothing running
[[ ! -f $LOGFILE ]] && echo "<icon>$ICON_NORMAL</icon>" && exit 0

# check last modification time (in seconds)
mtime=$(stat -c %Y "$LOGFILE")
now=$(date +%s)
diff=$(( now - mtime ))

# if changed in the last x s → alert
if (( diff < 3 )); then
    echo "<img>$ICON_ALERT</img>"
    LASTLINES=`tail -n 2 $LOGFILE`
    echo "<tool>Activity detected $diff s ago
    $LASTLINES   </tool>"
    notify-send -t 5 "New log" "$LASTLINES"
else
    echo "<icon>$ICON_NORMAL</icon>"
    echo "<tool>No activity ($diff s ago)</tool>"
fi

