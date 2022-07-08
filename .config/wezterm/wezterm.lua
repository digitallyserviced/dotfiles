local wezconf = {}
wezterm=require("wezterm")

wezconf.window_background_opacity = 0.7
wezconf.font_size = 11
wezconf.tab_bar_at_bottom = true
local wezterm_conf = require("wezterm_conf")(wezterm)
wezconf.font=wezterm.font_with_fallback {
      -- { family = "ShureTechMono NF", weight = "Regular", cell_width=1.2 },
      { family = "Iosevka Term", weight = "Regular" },
      -- { family = "MesloLGL Nerd Font Mono", weight = "Regular" },
      -- { family = "PragmataPro Mono", weight = "Regular" },
      -- { family = "BitstreamVeraSansMono Nerd Font Mono", weight = "Regular" },
      -- { family = "Hack Nerd Font", weight = "Regular" },
      -- { family = "FuraCode Nerd Font", weight = "Regular" },
      -- { family = "JetBrains Mono", weight = "Light" },
      -- { family = "Terminus", weight = "Bold" },
      "Noto Color Emoji",
    }
local config = wezterm_conf.override(wezconf)

return config
