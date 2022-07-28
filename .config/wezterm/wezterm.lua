local wezconf = {}
wezterm=require("wezterm")

wezconf.window_background_opacity = 0.7
wezconf.font_size = 10 
wezconf.tab_bar_at_bottom = true
local wezterm_conf = require("wezterm_conf")(wezterm)
wezconf.foreground_text_hsb = {
  hue = 1.0,
  -- saturation = 1.3,
  -- brightness = 3.3,
}
wezconf.font=wezterm.font_with_fallback {
      -- { family = "ShureTechMono NF", weight = "Regular" },
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
