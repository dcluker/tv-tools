# autoplay [on|off]  Fire TV home-screen video (a memory and decoder hog on small TVs)
case "${1:-}" in on) v=1;; off) v=0;; "") say "home video autoplay: $(sh_ settings get global com.amazon.tv.settings.featured_item_video_enabled)"; exit 0;; *) echo "autoplay [on|off]"; exit 2;; esac
sh_ settings put global com.amazon.tv.settings.featured_item_video_enabled "$v"; say "home video autoplay: $v"
