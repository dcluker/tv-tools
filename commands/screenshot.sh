# save a screenshot to ~/Desktop/tv-shots (strips the Fire TV's 44-byte text prefix). Shows the framebuffer, not the panel.
mkdir -p "$SHOTS"; f="$SHOTS/$NAME-$(date +%H%M%S).png"
"$ADB" -s "$IP:5555" exec-out screencap -p > /tmp/.tvshot.raw
python3 - "$f" <<'PY'
import sys; d=open('/tmp/.tvshot.raw','rb').read(); i=d.find(b'\x89PNG'); open(sys.argv[1],'wb').write(d[i:] if i>=0 else d)
PY
say "saved $f"
