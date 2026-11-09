# relaunch MyFlix (add "clear" to also clear its web cache). Refuses while playing.
gate || exit 1
sh_ am force-stop dev.theprivatehome.myflix
if [ "${1:-}" = clear ]; then sh_ am start -n dev.theprivatehome.myflix/.Home --ez clear_cache true >/dev/null
else sh_ am start -n dev.theprivatehome.myflix/.Home >/dev/null; fi
say "MyFlix relaunched${1:+ ($1)}"
