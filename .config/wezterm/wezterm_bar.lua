local wezconf = {}

wezconf.enable_tab_bar = false;
wezconf.custom_block_glyphs = true
wezconf.window_background_opacity = 0.7;
wezconf.window_padding = {
  top = 0,
  bottom = 0,
  left = 0,
  right = 0
};
wezconf.initial_rows = 3;
wezconf.check_for_updates = false;
wezconf.font_size = 11;
wezconf.line_height=1.0;
wezconf.automatically_reload_config = false;
wezterm = require("wezterm")
local wezterm_conf = require("wezterm_conf")(wezterm)
wezconf.font = wezterm.font_with_fallback {
      { family = "Iosevka Term", weight = "Regular" },
      -- { family = "BitstreamVeraSansMono Nerd Font Mono", weight = "Regular" },
      -- { family = "ShureTechMono NF", weight = "Regular" },
      -- { family = "FuraCode Nerd Font", weight = "Regular" },
      -- { family = "Iosevka Term", weight = "Regular" },
      -- { family = "MesloLGL Nerd Font Mono", weight = "Regular" },
      -- { family = "PragmataPro Mono", weight = "Regular" },
      -- { family = "Hack Nerd Font", weight = "Regular" },
      { family = "JetBrains Mono", weight = "Regular" },
      -- { family = "Terminus", weight = "Bold" },
      "Noto Color Emoji",
    }
local config = wezterm_conf.override(wezconf)

return config;
