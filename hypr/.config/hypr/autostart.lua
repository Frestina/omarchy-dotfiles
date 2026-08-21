-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- Keep the YouTube web app inside its tile when it goes fullscreen.
o.launch_on_start(os.getenv("HOME") .. "/.config/hypr/scripts/youtube-fakefullscreen")
