#!/bin/bash
# When a YouTube web app enters fullscreen, keep it inside its tile.
# internal=0 (stays in tile), client=2 (YouTube sees fullscreen).
#
# Chromium-family browsers build an --app window's class as
#   <browser>-<host and path>-<profile>
# with the query string dropped and "/" replaced by "_", frozen at window
# creation (it does not change when the page later redirects):
#   https://youtube.com/               -> brave-youtube.com__-Default
#   https://www.youtube.com/watch?v=ID -> brave-www.youtube.com__watch-Default
#   https://youtu.be/ID?t=90           -> brave-youtu.be__ID-Default
#
# Both ends vary: the prefix is the browser (brave-, chrome-) and the suffix is
# the profile directory (Default, Profile 1, ...). So match on the middle only.
# The "__" is the host/path boundary, and is what keeps the match specific: a
# web app for https://example.com/youtube.com/ becomes
# "...__youtube.com_-Default" (single underscore) and does not match.

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

is_youtube_webapp() {
    case "$1" in
        *youtube.com__* | *youtu.be__*) return 0 ;;
        *) return 1 ;;
    esac
}

socat -U - "UNIX-CONNECT:$SOCKET" | while IFS= read -r event; do
    if [[ "$event" == "fullscreen>>1" ]]; then
        class=$(hyprctl activewindow -j 2>/dev/null | jq -r '.class // ""')
        if is_youtube_webapp "$class"; then
            hyprctl dispatch 'hl.dsp.window.fullscreen_state({ internal = 0, client = 2 })' >/dev/null
        fi
    fi
done
