# volume [get | up [n] | down [n] | mute]   (key presses; level is read back)
read_v() { sh_ dumpsys audio | awk '/- STREAM_MUSIC:/{f=1} f&&/Muted:/{m=$2} f&&/Current:/{c=$0} f&&/Devices:/{print "muted=" m " |" c; exit}'; }
case "${1:-get}" in
  get) ;;
  up|down) gate || exit 1; n=${2:-1}; k=$([ "$1" = up ] && echo KEYCODE_VOLUME_UP || echo KEYCODE_VOLUME_DOWN)
    keys=""; for _ in $(seq 1 "$n"); do keys="$keys $k"; done; sh_ input keyevent $keys ;;
  mute) gate || exit 1; sh_ input keyevent KEYCODE_VOLUME_MUTE ;;
  *) echo "volume [get|up [n]|down [n]|mute]"; exit 2 ;;
esac
say "$(read_v)"
