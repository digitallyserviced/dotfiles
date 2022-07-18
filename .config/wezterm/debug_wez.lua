-- wezterm = require 'wezterm'
local wezterm_conf = require("lib.wez_config")
require("lib.styles")
-- local wez = require("wez")

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local wezconf = {}

wezconf.window_background_opacity = 0.5
wezconf.text_background_opacity = 0.5
wezconf.font_size = 12
wezconf.line_height = 1.0
-- wezconf.tab_bar_at_bottom = false
wezconf.tab_bar_at_bottom = true
wezconf.window_padding = { top = "4pt", left = "0pt", bottom = "0pt", right = "0pt" }
wezconf.automatically_reload_config = true
wezconf.enable_kitty_keyboard = true
wezconf.custom_block_glyphs = true
wezconf.foreground_text_hsb = {
  hue = 1.0,
  -- saturation = 1.3,
  -- brightness = 3.3,
}
-- local ed = require('docker_domains')
-- wezconf.exec_domains=ed
local color_list = { "red", "green", "yellow", "blue", "magenta", "cyan" }

local dimmer = { brightness = 0.4 }
wezterm.GLOBAL.debug = true
-- require('my_events')
local config = wezterm_conf.override(wezconf)
config.font = wezterm.font_with_fallback({
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
})

QQ = wezterm.format
P = function(content)
  if type(content) == "table" then
    wezterm.log_info(QQ(content))
  else
    wezterm.log_info(content)
  end
end
-- make a style
ORANGETXT = STYLE({ BG("#152528"), FG("#e85c51") })
-- print style
P(ORANGETXT("ORANGETXT"))
-- make a bold style
BOLD = STYLE({ BL(true) })
-- make an underline style
UNDERLINE = STYLE({ UL("Single") })
-- make helper for multiple formats
local appender, printer = NEW_FORMATTER()
-- print orangetxt with bold and underline added but not resetting style with bold and underline
appender(ORANGETXT("ORANGETXT"))
appender(BOLD("BOLDED"))
appender(UNDERLINE("UNDERLINED"))
P(printer())
-- P(ORANGETXT(BOLD(UNDERLINE("ORANGETXT+BOLD+UNDERLINE"), false), false))
-- make a style with a bg
CAPINSIDESTYLE = STYLE({ BG("#ad5c7c"), FG("#152528") })
CAPWRAPSTYLE = STYLE({ FG("#ad5c7c"), BG("#152528") })
-- make a capped element
SLANT = CAPPER(SLANT_LEFT, SLANT_RIGHT, CAPWRAPSTYLE, CAPINSIDESTYLE)
-- print the capped slant thing
P(SLANT("  省TITLE  "))

-- require('os').exit(0, true)
TAG = ROUNDCAP(STYLE({ BG("#2f3239"), FG("#7baf00") }), STYLE({ FG("#2f3239"), BG("#7baf00") }))
P(TAG(" WHEE "))

local newappender, newprinter = NEW_FORMATTER()
SEP = STYLE({ FG("#e85c51") })
CTRL = BADGE(STYLE({ BG("#7aa4a1"), FG("#152528") }))
ALT = BADGE(STYLE({ BG("#ad5c7c"), FG("#152528") }))
SHIFT = BADGE(STYLE({ BG("#fda47f"), FG("#152528") }))
LEADER = BADGE(STYLE({ BG("#e85c51"), FG("#152528") }))
newappender(CTRL("CTRL"))
newappender(ALT("ALT"))
newappender(SHIFT("SHIFT"))
P(newprinter(QQ(SEP(" | "))))
function make_mods_badges(mods)
  local modbadges = {}
  for m in mods:gmatch("([^|]+)") do
    local b = ""
    if m == "CTRL" then
      b = CTRL(m)
    end
    if m == "SHIFT" then
      b = SHIFT(m)
    end
    if m == "LEADER" then
      b = LEADER(m)
    end
    if m == "ALT" then
      b = ALT(m)
    end
    if string.len(b) > 0 then
      table.insert(modbadges, b)
    end
  end
  return table.concat(modbadges, QQ(SEP(" + ")))
end
wezterm.on("format-launcher-item", function(label, action, launcher_type)
  local appender, printer = NEW_FORMATTER(true)
  if launcher_type["KeyAssignment"] ~= nil then
    -- shortcut launcher item
    if launcher_type["KeyAssignment"]["mods"] ~= nil then
      local keybadges = make_mods_badges(launcher_type["KeyAssignment"]["mods"])
      appender(keybadges)
    end
    appender(wezterm.format({ ATTR_RESET }))
    appender(QQ(SEP(" - ")))
    appender(launcher_type["KeyAssignment"]["code"])
    appender(" ")
    -- appender(TAG(table.concat(action, " ")))
    if type(action) == "string" then
      appender(TAG(action))
    elseif type(action) == "table" then
      appender(string.format("%s", action))
    end
    return printer()
  end
  return label
end)

return config
