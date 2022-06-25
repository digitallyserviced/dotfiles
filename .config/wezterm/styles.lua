local wezterm = require('wezterm')

function COLOR(v)
  return FormatItem('Color', v)
end

function SYM(name)
  if wezterm.nerdfonts[name] ~= nil then
    return wezterm.nerdfonts[name]
  end
end

function FormatItem(name, value)
  local v = {}
  v[name] = value
  return v
end

function FG(v)
  return FormatItem('Foreground', COLOR(v))
end

function BG(v)
  return FormatItem('Background', COLOR(v))
end

function AT(v)
  return FormatItem('Attribute', v)
end

function IT(v)
  return AT(FormatItem('Italic', v))
end

function BL(v)
  v = v and "Bold" or "Normal"
  return AT(FormatItem('Intensity', v))
end

function HBL(v)
  v = v and "Half" or "Normal"
  return AT(FormatItem('Intensity', v))
end

function ST(v)
  return AT(FormatItem('StrikeThrough', v))
end

function HL(v)
  return AT(FormatItem('Hyperlink', { uri = v, params = {one = "two"}, implicit = false }))
end

function UL(v)
  return AT(FormatItem('Underline', v))
end

function TEXT(v)
  return FormatItem('Text', v)
end

function STYLE(attrs)
  local att = attrs
  return function(d)
    local out = {}
    for _, v in pairs(att) do
      table.insert(out, v)
    end
    table.insert(out, TEXT(d))
    return out
  end
end

ROUND_LEFT = SYM('ple_left_half_circle_thick')
ROUND_RIGHT = SYM('ple_right_half_circle_thick')
SLANT_LEFT = SYM('ple_upper_right_triangle')
SLANT_RIGHT = SYM('ple_lower_left_triangle')
TOP_TRIANGLE = SYM('pl_right_hard_divider')
NEXT_TRIANGLE = SYM('pl_right_soft_divider')
