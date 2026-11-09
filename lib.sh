# Shared helpers. Sourced by ./tv and every command. macOS-friendly bash.
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ADB="${ADB:-$(command -v adb || echo /opt/homebrew/bin/adb)}"
SHOTS="${TV_SHOTS:-$HOME/Desktop/tv-shots}"

tv_ip() { grep -E "^$1=" "$HERE/tvs.env" | head -1 | cut -d= -f2; }
tv_names() { grep -E '^[a-z0-9_-]+=' "$HERE/tvs.env" | cut -d= -f1; }

# connect <ip>: 0 when the TV answers ADB. A TV that is fully off has no network, so this fails: that is not an error.
tv_connect() { "$ADB" connect "$1:5555" >/dev/null 2>&1; "$ADB" -s "$1:5555" shell true </dev/null >/dev/null 2>&1; }
sh_() { "$ADB" -s "$IP:5555" shell "$@" </dev/null 2>/dev/null | tr -d "\r"; }

tv_awake() { sh_ dumpsys power | grep -q 'mWakefulness=Awake'; }
tv_focus() { sh_ dumpsys window | grep -m1 mCurrentFocus | sed -E 's/.*u0 ([^ }]+).*/\1/'; }
tv_playing() { tv_focus | grep -q 'PlayerActivity'; }

# gate: refuse to disturb a TV that is asleep or playing, unless --force. Read-only commands skip this.
gate() {
  [ "${FORCE:-0}" = 1 ] && return 0
  tv_awake || { echo "[$NAME] asleep: not touching it (use --force)"; return 1; }
  tv_playing && { echo "[$NAME] playing a video: not touching it (use --force)"; return 1; }
  return 0
}
say() { echo "[$NAME] $*"; }
