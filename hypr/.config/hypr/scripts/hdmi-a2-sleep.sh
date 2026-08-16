#!/bin/bash
# Manage HDMI-A-2 during the lock screen.
#
# Problem history:
#   - HDMI-A-2 (NEC EA243WM on HDMI) ignores `dpms off` and wakes itself via the
#     HDMI handshake, so it stayed lit all night while the other two slept.
#   - `dpms off` in a loop makes it flicker; only fully disabling the output makes
#     it sleep cleanly.
#   - But disabling an output forces a DRM modeset that can disturb HDMI-A-1/DP-2,
#     and leaving HDMI-A-2 disabled while unlocking makes the other two flicker.
#
# Strategy (single daemon, no competing instances):
#   locked + idle  -> after a short settle, disable HDMI-A-2 so it sleeps.
#   locked + waking -> the moment HDMI-A-1 powers back on (user starting to unlock),
#                      re-enable HDMI-A-2 so all three outputs are consistent again,
#                      which stops the flicker while typing the password.
#   unlocked       -> ensure HDMI-A-2 is enabled.

MON="HDMI-A-2"
MON_MODE="HDMI-A-2,1920x1080,1920x0,1"
SETTLE=15          # seconds to wait after lock before sleeping HDMI-A-2

enable_mon()  { hyprctl keyword monitor "$MON_MODE" >/dev/null 2>&1; }
disable_mon() { hyprctl keyword monitor "$MON,disabled" >/dev/null 2>&1; }
hdmi1_on() {
    [[ "$(hyprctl monitors -j 2>/dev/null | jq -r '.[]|select(.name=="HDMI-A-1")|.dpmsStatus')" == "true" ]]
}

state=unlocked
lock_time=0

while true; do
    if pidof hyprlock >/dev/null 2>&1; then
        now=$(date +%s)
        case $state in
            unlocked)
                state=locking
                lock_time=$now
                ;;
            locking)
                if (( now - lock_time >= SETTLE )); then
                    disable_mon
                    sleep 1
                    hyprctl dispatch dpms off HDMI-A-1 >/dev/null 2>&1
                    hyprctl dispatch dpms off DP-2 >/dev/null 2>&1
                    state=asleep
                fi
                ;;
            asleep)
                # User woke the machine to unlock -> restore HDMI-A-2 immediately.
                if hdmi1_on; then
                    enable_mon
                    state=awake
                fi
                ;;
            awake)
                : # user is typing the password; leave everything on
                ;;
        esac
    else
        if [[ $state != unlocked ]]; then
            enable_mon
            state=unlocked
        fi
    fi
    sleep 1
done
