local wezconf = {}
wezterm = require("wezterm")

wezconf.enable_tab_bar = false;
wezconf.window_background_opacity = 0.01;
wezconf.window_padding = {
       top = 0,
    bottom = 0,
      left = 0,
     right = 0,
};
wezconf.initial_rows = 24;
wezconf.initial_cols = 80;
wezconf.check_for_updates = false;
wezconf.font_size = 11;
wezconf.font = wezterm.font_with_fallback {
      -- { family = "ShureTechMono NF", weight = "Regular" },
      -- { family = "Iosevka Term", weight = "Regular" },
      -- { family = "MesloLGL Nerd Font Mono", weight = "Regular" },
      -- { family = "PragmataPro Mono", weight = "Regular" },
      -- { family = "BitstreamVeraSansMono Nerd Font Mono", weight = "Regular" },
      -- { family = "Hack Nerd Font", weight = "Regular" },
      -- { family = "FuraCode Nerd Font", weight = "Regular" },
      { family = "JetBrains Mono", weight = "Regular" },
      -- { family = "Terminus", weight = "Bold" },
      "Noto Color Emoji",
    }
-- wezconf.freetype_load_target = "Light"
-- wezconf.freetype_render_target = "Light"
wezconf.automatically_reload_config = false;
local wezterm_conf = require("wezterm_conf")(wezterm)
local config = wezterm_conf.override(wezconf)

return config;
