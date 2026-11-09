# key <up|down|left|right|ok|back|home|menu|play|pause|rewind|forward|sleep|wake>   (refuses while playing)
case "${1:-}" in up) c=DPAD_UP;; down) c=DPAD_DOWN;; left) c=DPAD_LEFT;; right) c=DPAD_RIGHT;; ok) c=DPAD_CENTER;; back) c=BACK;; home) c=HOME;;
  menu) c=MENU;; play) c=MEDIA_PLAY;; pause) c=MEDIA_PAUSE;; rewind) c=MEDIA_REWIND;; forward) c=MEDIA_FAST_FORWARD;; sleep) c=SLEEP;; wake) c=WAKEUP;;
  *) echo "key <up|down|left|right|ok|back|home|menu|play|pause|rewind|forward|sleep|wake>"; exit 2;; esac
case "$1" in play|pause|rewind|forward|back|home) ;; *) gate || exit 1;; esac   # media keys are the point while playing
sh_ input keyevent "KEYCODE_$c"; say "sent $1"
