local wezconf = {}

wezconf.enable_tab_bar = false;
wezconf.window_background_opacity = 0.85;
wezconf.window_padding = {
  top = 0,
  bottom = 0,
  left = 0,
  right = 0
};
wezconf.initial_rows = 24;
wezconf.initial_cols = 80;
wezconf.check_for_updates = false;
wezconf.font_size = 12;
wezconf.automatically_reload_config = false;
local wezterm_conf = require("wezterm_conf")(require("wezterm"))
local config = wezterm_conf.override(wezconf)

return config;
