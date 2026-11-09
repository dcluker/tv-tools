# awake?, app on screen, uptime, memory, load, MyFlix version, volume
say "awake: $(tv_awake && echo yes || echo no) | app: $(tv_focus)"
say "uptime: $(sh_ uptime | sed 's/,  *[0-9]* users.*//')"
say "memory: $(sh_ "grep -E 'MemAvailable|MemTotal' /proc/meminfo" | awk '{printf "%s %d MB  ", $1, $2/1024}')"
say "MyFlix: $(sh_ dumpsys package dev.theprivatehome.myflix | grep -m1 versionName | tr -d ' ')"
v=$(sh_ dumpsys audio | awk '/- STREAM_MUSIC:/{f=1} f&&/Muted:/{m=$2} f&&/Current:/{c=$0} f&&/Devices:/{d=$2; print "volume device=" d " muted=" m " | " c; exit}')
say "${v:-volume: unknown}"
