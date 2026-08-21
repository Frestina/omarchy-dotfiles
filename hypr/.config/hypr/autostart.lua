-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- Keep the YouTube web app fake-fullscreen (stays in its tile).
-- exec_on_start, not launch_on_start: the script needs Hyprland's own env
-- (HYPRLAND_INSTANCE_SIGNATURE) to find the event socket.
o.exec_on_start("~/.config/hypr/scripts/youtube-fakefullscreen.sh")
