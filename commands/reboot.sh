# restart the TV (refuses while playing or asleep), waits until it is back
gate || exit 1
sh_ settings get global com.amazon.tv.settings.featured_item_video_enabled >/dev/null
"$ADB" -s "$IP:5555" reboot; say "rebooting..."
for i in $(seq 1 60); do sleep 5; ping -c1 -t 2 "$IP" >/dev/null 2>&1 || continue
  "$ADB" connect "$IP:5555" >/dev/null 2>&1; [ "$(sh_ getprop sys.boot_completed)" = 1 ] && { say "back after ~$((i*5))s"; exit 0; }; done
say "did not come back within 5 minutes"; exit 1
