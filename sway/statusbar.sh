while :
do
	status="$(date +'%d.%m.%Y %X')"
	if command -v pamixer &> /dev/null; then
		vol_status="Volume: $(pamixer --get-volume)%"
		if pamixer --get-mute | grep -q 'true'; then
			vol_status="$vol_status (Muted)"
		fi
		status="$vol_status | $status"
	fi
	if [ -d "/sys/class/power_supply/BAT0" ]; then
		status="Battery: $(cat /sys/class/power_supply/BAT0/capacity)% ($(cat /sys/class/power_supply/BAT0/status)) | $status"
	fi
	if playerctl status | grep -q 'Playing'; then
		status="Playing: $(playerctl metadata xesam:title) - $(playerctl metadata xesam:artist) | $status"
	fi

	echo "$status"
	sleep 0.5
done
