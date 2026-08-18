-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = "auto"

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
--hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Configure a specific monitor.
hl.monitor({ output = "HDMI-A-1", mode = "1920x1200", position = "-1920x0", scale = omarchy_monitor_scale })
hl.monitor({ output = "DP-2", mode = "1920x1200", position = "0x0", scale = omarchy_monitor_scale })
hl.monitor({ output = "DVI-D-1", mode = "1920x1200", position = "1920x0", scale = omarchy_monitor_scale })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
