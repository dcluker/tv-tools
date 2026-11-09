# list installed apps, or grep them: packages [pattern]
sh_ pm list packages | sed 's/package://' | grep -i -E "${1:-.}" | sort
