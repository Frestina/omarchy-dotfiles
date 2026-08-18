-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Direct access to workspaces 11/12 (pinned to the left monitor in
-- hypr/workspaces.lua), since default SUPER+1..0 only covers 1-10.
o.bind("SUPER + F11", "Workspace 11", hl.dsp.focus({ workspace = "11" }))
o.bind("SUPER + F12", "Workspace 12", hl.dsp.focus({ workspace = "12" }))

-- Change SUPER+SHIFT+A from ChatGPT to Claude (Brave, Default profile)
hl.unbind("SUPER + SHIFT + A")
o.bind("SUPER + SHIFT + A", "Claude", "omarchy-launch-webapp https://claude.ai/new --profile-directory=Default")

-- Resize focused window with the numpad +/- keys
o.bind("SUPER + KP_Add", "Grow window", hl.dsp.window.resize({ x = 50, y = 50, relative = true }))
o.bind("SUPER + KP_Subtract", "Shrink window", hl.dsp.window.resize({ x = -50, y = -50, relative = true }))

-- Skip forward/back 5s in the active media player (e.g. YouTube in Brave) via MPRIS.
-- Doesn't require focus/click on the player, but needs playerctl installed.
o.bind("SHIFT + F9", "Seek forward 5s", "playerctl position 5+")
o.bind("SHIFT + F7", "Seek back 5s", "playerctl position 5-")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")
