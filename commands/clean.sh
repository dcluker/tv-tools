# free memory without a restart (kills cached background apps), shows before/after
before=$(sh_ grep MemAvailable /proc/meminfo | awk '{print int($2/1024)}')
gate || exit 1
sh_ am kill-all; sleep 5
after=$(sh_ grep MemAvailable /proc/meminfo | awk '{print int($2/1024)}')
say "available memory: ${before} MB -> ${after} MB"
