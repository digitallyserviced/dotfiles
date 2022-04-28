local wezconf = {}

wezconf.window_background_opacity = 0.9
wezconf.font_size = 10
wezconf.tab_bar_at_bottom = true
local wezterm_conf = require("wezterm_conf")(require("wezterm"))
local config = wezterm_conf.override(wezconf)

return config
