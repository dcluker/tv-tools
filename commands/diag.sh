# hardware, display modes, memory pressure, busiest processes, recent decoder/display errors (read-only)
say "model: $(sh_ getprop ro.product.model) | android $(sh_ getprop ro.build.version.release) | build $(sh_ getprop ro.build.display.id)"
say "board/soc: $(sh_ getprop ro.board.platform) / $(sh_ getprop ro.hardware)"
say "uptime: $(sh_ uptime | sed 's/,  *[0-9]* users.*//')"
say "display: $(sh_ wm size | tr '\n' ' ')| $(sh_ dumpsys display | grep -m1 -o 'supportedModes \[[^]]*\]')"
say "active mode: $(sh_ dumpsys display | grep -m1 mActiveModeId)"
say "memory (kB): $(sh_ "grep -E 'MemTotal|MemFree|MemAvailable|SwapTotal|SwapFree' /proc/meminfo" | awk '{printf "%s%s ", $1, $2}')"
say "storage: $(sh_ df /data | tail -1 | awk '{print $5 " used, " int($4/1024) " MB free"}')"
say "busiest processes:"; sh_ top -b -n 1 -m 8 | sed -n '4,13p' | cut -c1-110 | sed 's/^/    /'
say "recent decoder/display errors:"; "$ADB" -s "$IP:5555" logcat -d -t 4000 2>/dev/null | tr -d '\r' | grep -i -E 'mediacodec.*(error|fail)|decoder.*(error|fail)|hwcomposer.*(err|lost)|gpu hang|HDMI.*(err|fail|loss)' | tail -8 | cut -c1-200 | sed 's/^/    /'
