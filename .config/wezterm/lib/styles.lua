local wezterm = require("wezterm")
--#region helper functions

---Returns a format item table structured like the expectations
---of the lua config for wezterm {name = value}
---@param name string the name for the dictionary key that is used
---@param value any the value associated with the dictionary key can be any type
---@return table
function FormatItem(name, value)
  local v = {}
  v[name] = value
  return v
end

---Returns the table structure for a color argument/attribute for FG and BG style
---@param v string any color string argument that wezterm supports
---       "#027bcd", "rgb(0.5,0.5,0.5)", "hsl(0.5,0.5,0.5)" etc...
---@return table
---@alias COLOR table
function COLOR(v)
  return FormatItem('Color', v)
end

---Attribute argument type helper function used for text style not color
---@param v any name of the attribute
---@return table
---@alias AT table
function AT(v)
  return FormatItem('Attribute', v)
end

--#endregion


--#region Functions used for defining attributes to apply to a segment of text

---Returns a Foreground attribute
---@param v string a css styled color definition "#027bcd", "rgb(0.5,0.5,0.5)", "hsl(0.5,0.5,0.5)" etc...
---@return FG
---@alias FG table
function FG(v)
  return FormatItem('Foreground', COLOR(v))
end

---Returns a Background attribute
---@param v string a css styled color definition "#027bcd", "rgb(0.5,0.5,0.5)", "hsl(0.5,0.5,0.5)" etc...
---@return BG
---@alias BG table
function BG(v)
  return FormatItem('Background', COLOR(v))
end

---Returns an italic attribute structure
---@param v any
---@return table
function IT(v)
  return AT(FormatItem('Italic', v))
end

---Returns a BOLD attribute structure
---@param v any
---@return table
function BL(v)
  v = v and "Bold" or "Normal"
  return AT(FormatItem('Intensity', v))
end

---Returns a half-bold attribute structure
---@param v any
---@return table
function HBL(v)
  v = v and "Half" or "Normal"
  return AT(FormatItem('Intensity', v))
end

---Returns a strike-through attribute structure
---@param v any
---@return table
function ST(v)
  return AT(FormatItem('StrikeThrough', v))
end

---Returns a hyperlink attribute structure
---@param v any
---@return table
function HL(v)
  return AT(FormatItem('Hyperlink', { uri = v, params = {}, implicit = true }))
end

---Returns an underline attribute structure
---@param v any
---@return table
function UL(v)
  return AT(FormatItem('Underline', v))
end

---Returns a Text item.
---@param v string The text content for this segment
---@return table
function TEXT(v)
  return FormatItem('Text', v)
end
--#endregion


ATTR_RESET="ResetAttributes"
--#region Main style function the top-level initial style creation
---Returns a function that takes a string of text and returns the attribute table structures
---required to apply the created style to the supplied text
---@param attrs any
---@return function
function STYLE(attrs)
  local att = attrs
  return function(d, reset)
    reset = not reset
    local out = {}
    for _, v in pairs(att) do
      table.insert(out, v)
    end
    table.insert(out, TEXT(d))
    if reset then
      table.insert(out, ATTR_RESET)
    end
    return out
  end
end

--#region Main style function the top-level initial style creation
---Returns a function that takes a string of text and returns the attribute table structures
---required to apply the created style to the supplied text
---@param attrs any
---@return function
function WRAP_STYLE(head, tail, main_style, reset)
  reset = not reset
  main_style = main_style or STYLE({ATTR_RESET})
  local appender, printer = OUTPUT()
  return function(content, inner_style)
    inner_style = inner_style or STYLE({ATTR_RESET})
    appender(wezterm.format(main_style(head)))
    appender(wezterm.format(inner_style(content)))
    appender(wezterm.format(main_style(tail)))
    return printer()
  end
end

function OUTPUT()
  local out = {}
  return function (elem, format)
    format = not format or format
    if format then
      table.insert(out, wezterm.format(elem))
    else
      table.insert(out, elem)
    end
  end, function (sep)
  print(out)
    sep = sep or ""
    if type(out) == "table" then
      return table.concat(out, sep)
    else
      return out
    end
  end
end

---Return a symbol from the nerdfonts named dictionary
---@param name string name of the nerd font symbol
---@return string utf8 or utf16 sometimes
function SYM(name)
  if wezterm.nerdfonts[name] ~= nil then
    return wezterm.nerdfonts[name]
  end
end
--#endregion


--#region Some constants to be used

ROUND_THIN_LEFT = SYM('ple_left_half_circle_thin')
ROUND_THIN_RIGHT = SYM('ple_right_half_circle_thin')
ROUND_LEFT = SYM('ple_left_half_circle_thick')
ROUND_RIGHT = SYM('ple_right_half_circle_thick')
SLANT_LEFT = SYM('ple_upper_right_triangle')
SLANT_RIGHT = SYM('ple_lower_left_triangle')
TOP_TRIANGLE = SYM('pl_right_hard_divider')
NEXT_TRIANGLE = SYM('pl_right_soft_divider')
LEFT_SLASH = SYM('pl_left_hard_divider')
RIGHT_SLASH = SYM('pl_right_hard_divider')

COLOR_LIST = { "red", "green", "yellow", "blue", "magenta", "cyan"}
COLOR_SCALE = { "base", "bright", "dim" }
--#endregion


