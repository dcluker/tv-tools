# tv-tools

ADB helpers for the Fire TVs, run from the Mac. One command, one TV (or all of them), with a safety check built in so
nothing disturbs a TV that is playing a video.

```
cd ~/Desktop/Projects/tv-tools
./tv                       # lists every command
./tv all status            # every TV
./tv bedroom diag          # hardware, display, memory, busiest processes, decoder errors
./tv living volume up 3
```

## Setup

1. **ADB on the Mac:** `brew install android-platform-tools` (already there if `adb version` works).
2. **ADB debugging on each TV:** Settings > My Fire TV > Developer Options > ADB debugging **On**.
   The first connection from this Mac asks "Allow USB debugging?" on the TV: tick "Always allow" and accept.
3. **TV list:** `tvs.env` (copy `tvs.env.example`; gitignored), one `name=ip` per line. Give each TV a fixed address in the router
   (Living-room Stick `.221`, Bedroom TV `.213`). Add a TV by adding a line.

## Commands

`./tv <name|all> <command> [args] [--force]`

| Command | What it does | Disturbs the TV? |
|---|---|---|
| `status` | awake?, app on screen, uptime, free memory, MyFlix version, volume | no |
| `diag` | model, chip, display modes, memory and storage, busiest processes, recent decoder/display errors | no |
| `screenshot` | saves a PNG to `~/Desktop/tv-shots` | no |
| `packages [pattern]` | lists installed apps, optionally filtered | no |
| `volume get` | current volume and mute state | no |
| `volume up [n]` / `down [n]` / `mute` | volume key presses, level read back after | yes (gated) |
| `key <name>` | one remote key: `up down left right ok back home menu play pause rewind forward sleep wake` | yes (gated, except media/back/home) |
| `clean` | frees memory without a restart (closes cached background apps), shows before/after | yes (gated) |
| `reboot` | restarts the TV and waits until it is back | yes (gated) |
| `refresh-myflix [clear]` | relaunches MyFlix; `clear` also clears its web cache | yes (gated) |
| `autoplay [on\|off]` | the Fire TV home-screen video (a memory and decoder hog on small TVs); no argument shows the setting | no |

Examples:

```
./tv bedroom clean                 # memory low and the TV feels slow
./tv bedroom diag > ~/Desktop/bedroom-diag.txt
./tv living refresh-myflix clear   # app shows an old page
./tv all autoplay off
./tv bedroom screenshot
```

## The safety gate

Anything that disturbs a TV first checks it:

- **Asleep:** refuses (it never wakes a sleeping TV).
- **In the MyFlix player (a video is on):** refuses.
- `--force` skips the check. Read-only commands never check.

## Things that are different on Fire TVs

- **A TV that is "off" has no network at all.** It shows as "not reachable" here. Nothing can wake it over ADB or
  Wake-on-LAN. Waking needs the remote, an IR blaster, or HDMI-CEC from another device.
- **A "sleeping" Stick still answers ADB** (screen off, network up), so `status` works on it.
- **Screenshots show the framebuffer, not the panel.** A glitch in the TV's own picture chip will not appear in them.
  The screenshot command also strips a 44-byte text header the Bedroom TV puts in front of the PNG.
- **Volume** is changed by key presses; the Fire OS here has no direct "set volume" command. The level is read back from
  `dumpsys audio` (0 to 100 scale).
- **Quoting:** `adb shell` joins arguments into one string for the TV's shell, so a `|` inside a grep pattern becomes a
  pipe. Wrap such commands in one quoted string: `sh_ "grep -E 'a|b' /proc/meminfo"`.

## Never do

- `pm clear dev.theprivatehome.myflix`: it wipes the pairing token and the TV has to be paired again.
  (`refresh-myflix clear` only clears the web cache.)
- Reboot or force-stop a TV that someone is watching (the gate stops this unless you pass `--force`).

## Troubleshooting

| Symptom | Likely cause |
|---|---|
| `not reachable` | TV is fully off, or the IP changed (check the router), or ADB debugging got switched off after an update |
| `unauthorized` in `adb devices` | Accept the "Allow USB debugging?" prompt on the TV |
| `status` shows low `MemAvailable` (under ~300 MB) | `./tv <tv> clean`; if it keeps happening, `reboot` weekly and `autoplay off` |
| Picture tears or smears | `./tv <tv> diag` while it is happening; then Settings > Diagnostics > Run picture test in MyFlix on that TV |
| Two Macs fight over a TV | ADB allows one authorised key set per TV; keep the keys in `~/.android/` |

## Adding a command

Drop `commands/<name>.sh`. The first line must be a comment with a one-line description (it shows in `./tv`). The script runs with
`NAME` (the TV's name), `IP`, `FORCE` and the helpers from `lib.sh` available:

- `sh_ <cmd>`: run a command on the TV, `\r` stripped
- `tv_awake`, `tv_focus`, `tv_playing`: state checks
- `gate || exit 1`: the safety check; use it for anything that changes what is on screen
- `say "text"`: prints `[name] text`

## Related

- MyFlix's own Settings > Diagnostics > **Run picture test** (19 full-screen patterns for finding display faults).
- `~/Desktop/Projects/myflix/scripts/tv-refresh.sh`: the original MyFlix refresh helper used by the Torrent Hub button.
- `~/Desktop/Projects/tv-launcher/`: the debloat lists and undo scripts for both TVs.
