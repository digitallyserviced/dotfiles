wezterm = require 'wezterm'
require('lib.styles')

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local wezconf = {}

wezconf.window_background_opacity = 0.8
wezconf.font_size = 12
wezconf.line_height = 1.0
-- wezconf.tab_bar_at_bottom = false
wezconf.tab_bar_at_bottom = true
wezconf.window_padding = { top = "4pt", left = "0pt", bottom = "0pt", right = "0pt" }
wezconf.automatically_reload_config = true;
wezconf.enable_kitty_keyboard = true
wezconf.custom_block_glyphs = true
-- local ed = require('docker_domains')
-- wezconf.exec_domains=ed
local color_list = { "red", "green", "yellow", "blue", "magenta", "cyan" }
-- wezconf.window_background_gradient = {
--      colors = {
--     "#e85c51",
--     "#7aa4a1",
--     "#fda47f",
--     "#5a93aa",
--     "#ad5c7c",
--     "#a1cdd8",
--     "#ebebeb",
--     "#ff8349",
--     "#cb7985",
--        "#012302",
--   },
--      orientation = {
--        Radial={
--          -- Specifies the x coordinate of the center of the circle,
--          -- in the range 0.0 through 1.0.  The default is 0.5 which
--          -- is centered in the X dimension.
--          cx = 0.75,
--
--          -- Specifies the y coordinate of the center of the circle,
--          -- in the range 0.0 through 1.0.  The default is 0.5 which
--          -- is centered in the Y dimension.
--          cy = 0.75,
--
--          -- Specifies the radius of the notional circle.
--          -- The default is 0.5, which combined with the default cx
--          -- and cy values places the circle in the center of the
--          -- window, with the edges touching the window edges.
--          -- Values larger than 1 are possible.
--          radius = 0.725,
--        }
--      },
--   }
-- wezconf.window_background_gradient = {
--      colors = {
--     "#e85c51",
--     "#7aa4a1",
--     "#fda47f",
--     "#5a93aa",
--     "#ad5c7c",
--     "#a1cdd8",
--     "#ebebeb",
--     "#ff8349",
--     "#cb7985",
--        "#012302",
--   },
--      orientation = {
--        Radial={
--          -- Specifies the x coordinate of the center of the circle,
--          -- in the range 0.0 through 1.0.  The default is 0.5 which
--          -- is centered in the X dimension.
--          cx = 0.75,
--
--          -- Specifies the y coordinate of the center of the circle,
--          -- in the range 0.0 through 1.0.  The default is 0.5 which
--          -- is centered in the Y dimension.
--          cy = 0.75,
--
--          -- Specifies the radius of the notional circle.
--          -- The default is 0.5, which combined with the default cx
--          -- and cy values places the circle in the center of the
--          -- window, with the edges touching the window edges.
--          -- Values larger than 1 are possible.
--          radius = 0.725,
--        }
--      },
--   }

-- {
--   source = {File="/home/chris/.config/wezterm/plx/city_-1.png"},
--   -- The texture tiles vertically but not horizontally.
--   -- When we repeat it, mirror it so that it appears "more seamless".
--   -- An alternative to this is to set `width = "100%"` and have
--   -- it stretch across the display
--   repeat_x = "Mirror",
--   hsb = dimmer,
--   -- When the viewport scrolls, move this layer 10% of the number of
--   -- pixels moved by the main viewport. This makes it appear to be
--   -- further behind the text.
--   attachment = {Parallax=0.1},
-- },

local dimmer = { brightness = 0.4 }
local wez = require("wez")
wezterm.GLOBAL.debug=true
local wezterm_conf = require("lib.wez_config")
-- require('my_events')
local config = wezterm_conf.override(wezconf)
config.font = wezterm.font_with_fallback {
  -- { family = "ShureTechMono NF", weight = "Regular" },
  { family = "Iosevka Term", weight = "Regular" },
  -- { family = "MesloLGL Nerd Font Mono", weight = "Regular" },
  -- { family = "PragmataPro Mono", weight = "Regular" },
  -- { family = "BitstreamVeraSansMono Nerd Font Mono", weight = "Regular" },
  -- { family = "Hack Nerd Font", weight = "Regular" },
  -- { family = "FuraCode Nerd Font", weight = "Regular" },
  -- { family = "JetBrains Mono", weight = "Light" },
  { family = "Terminus", weight = "Bold" },
  "Noto Color Emoji",
}

-- wez.on('quick-selected', function (window, pane, data)
--   wez.log_error(window, pane, data)
-- end)
-- wezterm.on('gui-startup', function()
--   local mux = wezterm.mux
--   local tab, pane, window = mux.spawn_window { width = 100, height = 40 }
--   pane:split { direction = "Top", size = 3, top_level = true }
--   -- Create a split occupying the right 1/3 of the screen
--   -- pane:split{size=0.3}
--   -- Create another split in the right of the remaining 2/3
--   -- of the space; the resultant split is in the middle
--   -- 1/3 of the display and has the focus.
--   -- pane:split{size=0.5}
-- end)
return config
