-- Pin workspaces to specific monitors.
-- See https://wiki.hypr.land/Configuring/Workspace-Rules/

-- Left Monitor
hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1", default = true, persistent = true })
hl.workspace_rule({ workspace = "10", monitor = "HDMI-A-1", persistent = true })
hl.workspace_rule({ workspace = "11", monitor = "HDMI-A-1", persistent = true })
hl.workspace_rule({ workspace = "12", monitor = "HDMI-A-1", persistent = true })

-- Middle Monitor
hl.workspace_rule({ workspace = "1", monitor = "DP-2", default = true, persistent = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-2", persistent = true })
hl.workspace_rule({ workspace = "3", monitor = "DP-2", persistent = true })
hl.workspace_rule({ workspace = "4", monitor = "DP-2", persistent = true })

-- Right Monitor
hl.workspace_rule({ workspace = "5", monitor = "DVI-D-1", default = true, persistent = true })
hl.workspace_rule({ workspace = "6", monitor = "DVI-D-1", persistent = true })
hl.workspace_rule({ workspace = "7", monitor = "DVI-D-1", persistent = true })
hl.workspace_rule({ workspace = "8", monitor = "DVI-D-1", persistent = true })
