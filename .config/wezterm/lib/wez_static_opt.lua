-- Utility functions -----------------------------------------------------------

-- Join list of arguments into a path separated by the correct path seperator
local options = {
  -- debug_key_events = true,
  skip_close_confirmation_for_processes_named = {
    "bash",
    "sh",
    "zsh",
    "fish",
    "tmux",
    "starship",
  },
  color_scheme = "terafox",
  -- color_scheme = "test",
--  default_gui_startup_args = { "connect", "main" },
  selection_word_boundary = " \t\n{}[]()\"'`%",
  use_resize_increments = true,
  audible_bell = "Disabled",
  visual_bell = {
    fade_in_function = "EaseIn",
    fade_in_duration_ms = 150,
    fade_out_function = "EaseOut",
    fade_out_duration_ms = 150,
    target = "BackgroundColor",
  },
   -- colors = {
  --   visual_bell = "#202020",
  --   tab_bar = coloring.tab_bar,
  -- },
  -- cursor_blink_rate = 1500,
  -- cursor_blink_ease_in = "EaseIn",
  -- cursor_blink_ease_out = "EaseOut",
  -- harfbuzz_features = {"calt=0", "clig=0", "liga=0"},
  warn_about_missing_glyphs = false,
  font_size =10,
  default_cursor_style = "SteadyUnderline",
  custom_block_glyphs = true,
  dpi = 96.0,
  freetype_load_target = "Normal",
  freetype_render_target = "Normal",
  -- freetype_load_flags = "MONOCHROME",
  -- foreground_text_hsb = {
  --   hue = 1.0,
  --   saturation = 1.0,
  --   brightness = 1.0,
  -- },
  hyperlink_rules = {
    {
      regex = "\\b\\w+://(?:[\\w.-]+)\\.[a-z]{2,15}\\S*\\b",
      format = "$0",
    },
    {
      regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
      format = "mailto:$0",
    },
    {
      regex = "\\bfile://\\S*\\b",
      format = "$0",
    },
    {
      regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
      format = "https://www.github.com/$1/$3",
    },{
      regex = '(?:(?:/home/chris|~){1}(?:/){1}((?:/){0,1}(?:[-/\\w\\d\\.]+)))', -- [^/\\s]
      format = "nvr:$0",
    },
  },

  use_fancy_tab_bar = false,
  line_height = 0.9,
  window_padding = {
    top = "0pt",
    bottom = "0pt",
    left = "0pt",
    right = "0pt",
  },
  allow_square_glyphs_to_overflow_width = "Always",
  window_background_opacity = 0.9,
  text_background_opacity = 0.9,
  window_close_confirmation = "NeverPrompt",
  check_for_updates = true,
  check_for_updates_interval_seconds = 86400,
  bold_brightens_ansi_colors = false,
  enable_tab_bar = true,
  tab_max_width = 36,
  window_decorations = "NONE",
  hide_tab_bar_if_only_one_tab = false,
  scrollback_lines = 3500,
  show_tab_index_in_tab_bar = false, -- false
  enable_scroll_bar = false,
  tab_bar_at_bottom = true,
}

return options

-- #
-- 
-- 
-- ⌨⛀⛁⛂⛃⛖⛗⚱⚲⚳⚴⚵⚶⚷⚸⚠⚟⚞⚛⚜⚝♳♴♵♶♷♸♹♺♻☣☤☭☯☠☡☢☐☑☒☓☄
