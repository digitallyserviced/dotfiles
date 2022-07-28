-- Utility functions -----------------------------------------------------------

-- Join list of arguments into a path separated by the correct path seperator
local options = {
  skip_close_confirmation_for_processes_named = {
    "bash",
    "sh",
    "zsh",
    "fish",
    "tmux",
    "starship",
  },
  color_scheme = "terafox",
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
  warn_about_missing_glyphs = false,
  font_size = 10,
  default_cursor_style = "SteadyUnderline",
  custom_block_glyphs = true,
  dpi = 96.0,
  -- font_hinting = "Full",
  status_update_interval = 2000,
  -- use_cap_height_to_scale_fallback_font=true,
  -- font_hinting = "VerticalSubpixel",
  freetype_interpreter_version = 40,
  -- freetype_load_flags = "FORCE_AUTOHINT|NO_BITMAP",
  freetype_load_target = "HorizontalLcd",
  freetype_render_target = "HorizontalLcd",
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
    },
    {
      regex = "(?:(?:/home/chris|~){1}(?:/){1}((?:/){0,1}(?:[-/\\w\\d\\.]+)))", -- [^/\\s]
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
  -- allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace",
  window_background_opacity = 0.9,
  text_background_opacity = 1.0,
  window_close_confirmation = "NeverPrompt",
  check_for_updates = true,
  check_for_updates_interval_seconds = 86400,
  bold_brightens_ansi_colors = false,
  enable_tab_bar = true,
  tab_max_width = 36,
  window_decorations = "NONE",
  hide_tab_bar_if_only_one_tab = false,
  scrollback_lines = 1500,
  show_tab_index_in_tab_bar = false, -- false
  enable_scroll_bar = false,
  tab_bar_at_bottom = true,
  ssh_domains = {
    {
      name = "maindesk",
      remote_address = "192.168.68.104",
      ssh_option = {
        identityfile = "/home/chris/.ssh/id_rsra.pub",
      },
    },
  },
}

return options
-- colors = {
--   visual_bell = "#202020",
--   tab_bar = coloring.tab_bar,
-- },
-- cursor_blink_rate = 1500,
-- cursor_blink_ease_in = "EaseIn",
-- cursor_blink_ease_out = "EaseOut",
-- harfbuzz_features = {"calt=0", "clig=0", "liga=0"},
-- freetype_load_flags = "MONOCHROME",
-- foreground_text_hsb = {
--   hue = 1.0,
--   saturation = 1.0,
--   brightness = 1.0,
-- },
-- color_scheme = "test",
--  default_gui_startup_args = { "connect", "main" },
-- debug_key_events = true,

-- #
-- 
-- 
-- ⌨⛀⛁⛂⛃⛖⛗⚱⚲⚳⚴⚵⚶⚷⚸⚠⚟⚞⚛⚜⚝♳♴♵♶♷♸♹♺♻☣☤☭☯☠☡☢☐☑☒☓☄
