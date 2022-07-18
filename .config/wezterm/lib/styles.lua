local wezterm = require("wezterm")
--#region helper functions
ATTR_RESET = "ResetAttributes"

---Returns a format item table structured like the expectations
---of the lua config for wezterm {name = value}
---@tparam name string the name for the dictionary key that is used
---@tparam value any the value associated with the dictionary key can be any type
---@treturn table
function FormatItem(name, value)
  local v = {}
  v[name] = value
  return v
end

---Returns the table structure for a color argument/attribute for FG and BG style
---@tparam v string any color string argument that wezterm supports
---       "#027bcd", "rgb(0.5,0.5,0.5)", "hsl(0.5,0.5,0.5)" etc...
---@treturn table
---@alias COLOR table
function COLOR(v)
  return FormatItem("Color", v)
end

---Attribute argument type helper function used for text style not color
---@tparam v any name of the attribute
---@treturn table
---@alias AT table
function AT(v)
  return FormatItem("Attribute", v)
end

--#endregion

--#region Functions used for defining attributes to apply to a segment of text

---Returns a Foreground attribute
---@tparam v string a css styled color definition "#027bcd", "rgb(0.5,0.5,0.5)", "hsl(0.5,0.5,0.5)" etc...
---@treturn FG
---@alias FG table
function FG(v)
  return FormatItem("Foreground", COLOR(v))
end

---Returns a Background attribute
---@tparam v string a css styled color definition "#027bcd", "rgb(0.5,0.5,0.5)", "hsl(0.5,0.5,0.5)" etc...
---@treturn BG
---@alias BG table
function BG(v)
  return FormatItem("Background", COLOR(v))
end

---Returns an italic attribute structure
---@tparam v any
---@treturn table
function IT(v)
  return AT(FormatItem("Italic", v))
end

---Returns a BOLD attribute structure
---@tparam v any
---@treturn table
function BL(v)
  v = v and "Bold" or "Normal"
  return AT(FormatItem("Intensity", v))
end

---Returns a half-bold attribute structure
---@tparam v any
---@treturn table
function HBL(v)
  v = v and "Half" or "Normal"
  return AT(FormatItem("Intensity", v))
end

---Returns a strike-through attribute structure
---@tparam v any
---@treturn table
function ST(v)
  return AT(FormatItem("StrikeThrough", v))
end

---Returns a hyperlink attribute structure
---@tparam v any
---@treturn table
function HL(v)
  return AT(FormatItem("Hyperlink", { uri = v, params = {}, implicit = true }))
end

---Returns an underline attribute structure
---@tparam v any
---@treturn table
function UL(v)
  return AT(FormatItem("Underline", v))
end

---Returns a Text item.
---@tparam v string The text content for this segment
---@treturn TEXT | table
--- @alias TEXT table
function TEXT(v)
  return FormatItem("Text", v)
end
--#endregion

--#region Top-level style functions the user will use

--- Returns a function that takes a string of text and returns the attribute table structures
--- required to apply the created style to the supplied text
--- @tparam attrs any
--- @treturn STYLE|function
--- @alias STYLE function
function STYLE(attrs)
  local att = attrs

  --- Returns table with attributes and text to be wezterm.format'd
  --- @tparam d string content to be styled
  --- @tparam reset boolean append reset attribute to the end of table
  --- @treturn table|STYLED
  --- @alias STYLED table
  return function(d, noreset)
    noreset = not noreset
    local out = {}
    for _, v in pairs(att) do
      table.insert(out, v)
    end
    table.insert(out, TEXT(d))
    if not noreset then
      table.insert(out, ATTR_RESET)
    end
    return out
  end
end

--- Takes a beginning and ending string, and a style for them.
--- this creates a function that accepts text content to be wrapped
--- and the style for the content. This produces
--- **STYLE1**<**STYLE2**TEXT**STYLE1**>**RESET**
--- If passing reset false to initial call it will not eset between style changes.
--- @tparam head string content on the left side of the wrapped text
--- @tparam tail string content for the right side of the wrapped text
--- @tparam outside_style? STYLE a style created using the STYLE function to apply to the outside content
--- @tparam reset? boolean defaults to true will reset attributes between each element
--- @treturn WRAP_FUNCTION|function
--- @alias WRAP_FUNCTION function
function WRAP_STYLE(head, tail, outside_style, reset)
  reset = not reset
  outside_style = outside_style or STYLE({ ATTR_RESET })
  local appender, printer = NEW_FORMATTER()

  --- @type WRAP_FUNCTION
  --- @tparam content string content to be wrapped
  --- @tparam inner_style STYLE the style to wrap the inner content with
  return function(content, inner_style)
    inner_style = inner_style or STYLE({ ATTR_RESET })
    appender(outside_style(head))
    appender(inner_style(content))
    appender(outside_style(tail))
    return printer("")
  end
end

--- Returns a React like effect with a function to add content
--- and a function to print the content added.
--- @tparam strings? boolean  if true do not apply wezterm.format
--- @treturn APPENDER, PRINTER
--- @alias APPENDER function,
--- @alias PRINTER function
function NEW_FORMATTER(strings)
  strings = strings or false
  local out = {}
  --- @type APPENDER
  --- @tparam elem string|STYLED the element from a STYLE ouput or a already wezterm.format string
  return function(elem)
    if strings then
      table.insert(out, elem)
    else
      if type(elem) == "table" then
        table.insert(out, wezterm.format(elem))
      else
        table.insert(out, elem)
      end
    end
    --- @type PRINTER
    --- @tparam sep string the separator for each element added to this formatter
    --- @treturn string a string with all elements joined together using sep
  end,
    function(sep)
      sep = sep ~= nil and sep or " "
      return table.concat(out, sep)
    end
end

--- Helper function to produce a function that is preloaded with
--- both inner and outer styles to easily produce a capped element
--- @tparam head string left hand element
--- @tparam tail string right hand element
--- @tparam wrap_style STYLE applied to the outside wrapping elements
--- @tparam inner_style STYLE applied to the inside element
--- @treturn function call the function to produce a wezterm.format'able table
function CAPPER(head, tail, wrap_style, inner_style)
  --- Helper function to produce content wrapped in pre-styled elements
  --- @tparam content string content to be wrapped
  --- @treturn STYLED a wezterm.format'able table
  return function(content)
    local wrap = WRAP_STYLE(head, tail, wrap_style)
    return wrap(content, inner_style)
  end
end

--- An example of using the CAPPER to produce a pre-STYLED element
--- wrapped with pre-defined elements.
--- @tparam outer_style STYLE the style for the outer elements
--- @tparam inner_style STYLE the style for the inner content
--- @treturn STYLE a function that when called produces a wezterm.format'able table
function ROUNDCAP(outer_style, inner_style)
  --- Function that takes only string content and returns a pre-styled
  --- pre-made wrapped element
  --- @tparam content string
  --- @treturn STYLED a wezterm.format'ale table
  return function(content)
    local w = CAPPER(ROUND_LEFT, ROUND_RIGHT, outer_style, inner_style)
    return w(content)
  end
end

--- An example of using the CAPPER to produce a pre-STYLED element
--- wrapped with pre-defined elements simple spaces to produce a badge.
--- @tparam style STYLE the style for the outer elements
--- @treturn STYLE a function that when called produces a wezterm.format'able table
function BADGE(style)
  --- Function that takes only string content and returns a pre-styled
  --- pre-made wrapped element
  --- @tparam content string
  --- @treturn STYLED a wezterm.format'ale table
  return function(content)
    local w = CAPPER(" ", " ", style, style)
    return w(content)
  end
end

--- Return a symbol from the nerdfonts named dictionary
--- @tparam name string name of the nerd font symbol
--- @treturn string utf8 or utf16 sometimes
function SYM(name)
  if wezterm.nerdfonts[name] ~= nil then
    return wezterm.nerdfonts[name]
  end
end
--#endregion

--#region Some constants to be used

ROUND_THIN_LEFT = SYM("ple_left_half_circle_thin")
ROUND_THIN_RIGHT = SYM("ple_right_half_circle_thin")
ROUND_LEFT = SYM("ple_left_half_circle_thick")
ROUND_RIGHT = SYM("ple_right_half_circle_thick")
SLANT_LEFT = SYM("ple_upper_right_triangle")
SLANT_RIGHT = SYM("ple_lower_left_triangle")
TOP_TRIANGLE = SYM("pl_right_hard_divider")
NEXT_TRIANGLE = SYM("pl_right_soft_divider")
LEFT_SLASH = SYM("pl_left_hard_divider")
RIGHT_SLASH = SYM("pl_right_hard_divider")

COLOR_LIST = { "red", "green", "yellow", "blue", "magenta", "cyan" }
COLOR_SCALE = { "base", "bright", "dim" }
--#endregion
