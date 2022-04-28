local fox = require("palette.terafox")
local C = require("lib.color")
local ansi = {}
local bright = {}

for _,v in ipairs(C.color_list) do
  table.insert(ansi, fox.palette[v].base)
  table.insert(bright, fox.palette[v].bright)
end
return {
  color_schemes = {
    ["test"] = {
      -- The default text color
      foreground = fox.spec.fg0,
      -- The default background color
      background = fox.spec.bg1,

      -- Overrides the cell background color when the current cell is occupied by the
      -- cursor and the cursor style is set to Block
      cursor_bg = "#52ad70",
      -- Overrides the text color when the current cell is occupied by the cursor
      cursor_fg = "black",
      -- Specifies the border color of the cursor when the cursor style is set to Block,
      -- or the color of the vertical or horizontal bar when the cursor style is set to
      -- Bar or Underline.
      cursor_border = "#52ad70",

      -- the foreground color of selected text
      selection_fg = fox.spec.fg1,
      -- the background color of selected text
      selection_bg = fox.spec.sel0,

      -- The color of the scrollbar "thumb"; the portion that represents the current viewport
      scrollbar_thumb = "#222222",

      -- The color of the split lines between panes
      split = "#444444",

      ansi = ansi,
      brights = bright,
      -- ansi = { "black", "green", "navy", "purple", "teal", "silver" },
      -- brights = { "grey", "red", "lime", "yellow", "blue", "fuchsia", "aqua", "white" },

      -- Arbitrary colors of the palette in the range from 16 to 255
      indexed = { [136] = "#af8700" },

      -- Since: 20220319-142410-0fcdea07
      -- When the IME, a dead key or a leader key are being processed and are effectively
      -- holding input pending the result of input composition, change the cursor
      -- to this color to give a visual cue about the compose state.
      compose_cursor = "orange",
    },
  },
  colors = {
    tab_bar = {
      -- The color of the strip that goes along the top of the window
      -- (does not apply when fancy tab bar is in use)
      background = "#0b0022",

      -- The active tab is the one that has focus in the window
      active_tab = {
        -- The color of the background area for the tab
        bg_color = "#2b2042",
        -- The color of the text for the tab
        fg_color = "#c0c0c0",

        -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
        -- label shown for this tab.
        -- The default is "Normal"
        intensity = "Normal",

        -- Specify whether you want "None", "Single" or "Double" underline for
        -- label shown for this tab.
        -- The default is "None"
        underline = "None",

        -- Specify whether you want the text to be italic (true) or not (false)
        -- for this tab.  The default is false.
        italic = false,

        -- Specify whether you want the text to be rendered with strikethrough (true)
        -- or not for this tab.  The default is false.
        strikethrough = false,
      },

      -- Inactive tabs are the tabs that do not have focus
      inactive_tab = {
        bg_color = "#1b1032",
        fg_color = "#808080",

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `inactive_tab`.
      },

      -- You can configure some alternate styling when the mouse pointer
      -- moves over inactive tabs
      inactive_tab_hover = {
        bg_color = "#3b3052",
        fg_color = "#909090",
        italic = true,

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `inactive_tab_hover`.
      },

      -- The new tab button that let you create new tabs
      new_tab = {
        bg_color = "#1b1032",
        fg_color = "#808080",

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `new_tab`.
      },

      -- You can configure some alternate styling when the mouse pointer
      -- moves over the new tab button
      new_tab_hover = {
        bg_color = "#3b3052",
        fg_color = "#909090",
        italic = true,

        -- The same options that were listed under the `active_tab` section above
        -- can also be used for `new_tab_hover`.
      },
    },
  },
}
