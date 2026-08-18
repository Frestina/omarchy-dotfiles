-- Window rules, ported from the old (pre-Quattro) ~/.config/hypr/windows.conf.
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Web app windows -> specific workspaces
o.window("^brave-discord\\.com__channels_@me-Default$", { workspace = "9" })
o.window("^brave-grok\\.com__-Default$", { workspace = "6" })
o.window("^brave-claude\\.ai__new-Default$", { workspace = "6" })

-- Steam client -> workspace 8, and keep it tiled.
-- Omarchy floats Steam by default (default/hypr/apps/steam.lua); this overrides that.
o.window("^steam$", { workspace = "8", float = false })

-- Steam games -> workspace 4
o.window("^steam_app_1062090$", { workspace = "4" }) -- Timberborn
o.window("^steam_app_3361510$", { workspace = "4" }) -- Coal LLC
o.window("^steam_app_1284190$", { workspace = "4" }) -- Planet Crafter
