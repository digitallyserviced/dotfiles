-- vim: ts=4 sw=4 noet ai cindent syntax=lua

--[[
Conky, a system monitor, based on torsmo
]]

conky.config = {
    out_to_x = false,
    out_to_console = true,
    short_units = true,
    update_interval = 1
}

local dirname  = debug.getinfo(1).source:match("@?(.*/)")

dofile('gmc.lua')

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ---
-- preset

colorPreset = {
  icon       = colPink500,
  label      = colGrey700,
  separator  = colBlue900,
  value      = colBlack,
  background = nil
}

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ---
-- helper

helper = {}

-- constant

-- glyph icon decoration
local decoPath = 'Documents/standalone/dzen2/assets/xbm'

-- diagonal corner
helper.decoCornerTopLeft     = '^i(' .. decoPath .. '/dc-024-tl.xbm)'
helper.decoCornerTopRight    = '^i(' .. decoPath .. '/dc-024-tr.xbm)'
helper.decoCornerBottomLeft  = '^i(' .. decoPath .. '/dc-024-bl.xbm)'
helper.decoCornerBottomRight = '^i(' .. decoPath .. '/dc-024-br.xbm)'

-- single arrow and double arrow
helper.decoSingleArrowLeft  = '^i(' .. decoPath .. '/sa-024-l.xbm)'
helper.decoSingleArrowRight = '^i(' .. decoPath .. '/sa-024-r.xbm)'
helper.decoDoubleArrowLeft  = '^i(' .. decoPath .. '/da-024-l.xbm)'
helper.decoDoubleArrowRight = '^i(' .. decoPath .. '/da-024-r.xbm)'


-- http://fontawesome.io/
local fontAwesome = '^fn(TerminusTTF)'

-- initialization

--local colorPreset = nil
 
function helper.icon(text, color)
  color = color or colorPreset.icon

  local preIcon  = '^fg(' .. color .. ')' .. fontAwesome
  local postIcon = '^fn()^fg()'
  
  return ' ' .. preIcon .. text .. postIcon .. ' '
end

function helper.label(text, color)
  color = color or colorPreset.label

  return '^fg(' .. color .. ')' .. text
end

function helper.separator(color)
  color = color or colorPreset.separator

  return '^fg(' .. color .. ')' .. '|'
end

function helper.value(text, color)
  color = color or colorPreset.value

  return '^fg(' .. color .. ')' .. text
end

function helper.common(icon, label, value, colorBg)

  colorBg = colorBg or colorPreset.background
  text=''
  
  if colorBg then text = text .. '^bg(' .. colorBg .. ')' end
  if not colorBg then text = helper.separator() end  
  if icon then text = text .. ' ' .. helper.icon(icon) end  
  if label then text = text .. ' ' .. helper.label(label) end  
  if value then text = text .. ' ' .. helper.value(value) .. ' ' end

  return text
end

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ---
-- parts

--[[
You may consider change glyph using FontAwesome icon
http://fontawesome.io/cheatsheet/

* Sample: Battery Icon: 
]]

parts = {}

-- user variables
local wlandev = 'wlp0s3f3u2'

-- shortcut
local _h = helper

-- template variables: Color Indicator
local color_indicator_dark = {
  good      = '',
  degraded  = '\\#b27d12',
  bad       = '\\#802828'
}

local color_indicator_bright = {
  good      = '',
  degraded  = colRed900,
  bad       = colRed500
}

local ci = color_indicator_bright

-- transition image
function parts.transition(decoIcon, decoBg, decoFg)
   text = '^bg(' .. decoBg .. ')' 
       .. '^fg(' .. decoFg .. ')' .. decoIcon

  return text
end

-- Time
function parts.time(colorBg)
  return _h.common('', nil, '${time %H:%M }', colorBg)
end

-- Date
function parts.date(colorBg)
  return _h.common('', nil, '${time %D}', colorBg)
end

-- Volume
function parts.volume(colorBg)
  local volume_command = [[amixer get Master | tail -1 | sed 's/.*\[\([0-9]*%\)\].*/\1/']]
  return _h.common('', 'Vol', "${execi 1 " .. volume_command .. "}", colorBg)
end

-- Host
function parts.host(colorBg)
  return _h.common('', 'Host', '$nodename', colorBg) 
end

-- Uptime
function parts.uptime(colorBg)
  return _h.common('', 'Uptime', '$uptime', colorBg)
end

-- Memory
function parts.mem(colorBg)
  return _h.common('', 'RAM', '$mem/$memmax', colorBg)
end

-- SSID
function parts.ssid(colorBg)
  return _h.common(' ', '', '$wireless_essid', colorBg)
end


-- Lua Function Demo 
-- https://github.com/brndnmtthws/conky/issues/62

function _h.exec(command)
    local file = assert(io.popen(command, 'r'))
    local s = file:read('*all')
    file:close()

    s = string.gsub(s, '^%s+', '') 
    s = string.gsub(s, '%s+$', '') 
    s = string.gsub(s, '[\n\r]+', ' ')

    return s
end

-- read once
local machine = _h.exec('uname -r')  

function parts.machine(colorBg)
  return _h.common('', nil, machine, colorBg)
end

-- Media Player Daemon
function parts.mpd(colorBg)
  local mpd = [[\
${if_mpd_playing}\
]] .. _h.icon('') 
.. _h.value(' ${mpd_artist 20} ')
.. _h.icon('')
.. _h.value(' ${mpd_title 30}') ..[[
${else}]] .. _h.icon('') .. [[${endif}\
]]

  return _h.common(nil, nil, mpd, colorBg)
end

-- CPU temperature:
function parts.cputemp(colorBg)
  local cputemp = [[\
${if_match ${acpitemp}<45}\
]] .. _h.value('${acpitemp}°C', ci.good) .. [[
${else}${if_match ${acpitemp}<55}\
]] .. _h.value('${acpitemp}°C', ci.degraded) .. [[
${else}${if_match ${acpitemp}>=55}\
]] .. _h.value('${acpitemp}°C', ci.bad) .. [[
${endif}${endif}${endif}\
]]

  return _h.common('', 'CPU', cputemp, colorBg)
end

-- Network
function parts.network(colorBg)
  local download = _h.icon('') .. [[\
${if_match ${downspeedf ]] .. wlandev .. [[}<1000}\
]] .. _h.value('${downspeed ' .. wlandev .. '}', ci.good) .. [[
${else}${if_match ${downspeedf ]] .. wlandev .. [[}<3000}\
]] .. _h.value('${downspeed ' .. wlandev .. '}', ci.degraded) .. [[
${else}${if_match ${downspeedf ]] .. wlandev .. [[}>=3000}\
]] .. _h.value('${downspeed ' .. wlandev .. '}', ci.bad) .. [[
${endif}${endif}${endif}\
]]

  local upload = _h.icon('') .. [[\
${if_match ${upspeedf ]] .. wlandev .. [[}<300}\
]] .. _h.value('${upspeed ' .. wlandev .. '}', ci.good) .. [[
${else}${if_match ${upspeedf ]] .. wlandev .. [[}<800}\
]] .. _h.value('${upspeed ' .. wlandev .. '}', ci.degraded) .. [[
${else}${if_match ${upspeedf ]] .. wlandev .. [[}>=800}\
]] .. _h.value('${upspeed ' .. wlandev .. '}', ci.bad) .. [[
${endif}${endif}${endif}\
]]

  return _h.common(nil, nil, download .. upload, colorBg)
end

-- Memory
function parts.memory(colorBg)
  local memory = [[\
${if_match ${memperc}<30}\
]] .. _h.value('${memeasyfree}', ci.good) .. [[
${else}${if_match ${memperc}<70}\
]] .. _h.value('${memeasyfree}',ci.degraded) .. [[
${else}${if_match ${memperc}>=70}\
]] .. _h.value('${memeasyfree}', ci.bad) .. [[
${endif}${endif}${endif}\
]]

  return _h.common('', 'MEM', memory, colorBg)
end

-- CPU 0
function parts.cpu0(colorBg)
 local cpu0 = [[\
${if_match ${cpu cpu0}<50}\
]] .. _h.value('${cpu cpu0}%', ci.good) .. [[
${else}${if_match ${cpu cpu0}<60}\
]] .. _h.value('${cpu cpu0}%',ci.degraded) .. [[
${else}${if_match ${cpu cpu0}<=100}\
]] .. _h.value('${cpu cpu0}%', ci.bad) .. [[
${endif}${endif}${endif}\
]]

  return _h.common('', 'CPU', cpu0, colorBg)
end

-- Battery
function parts.battery(colorBg)
  local battery = [[\
${if_match ${battery_percent}<30}\
]] .. _h.value('${battery_percent}%', ci.bad) .. [[
${else}${if_match ${battery_percent}<70}\
]] .. _h.value('${battery_percent}%', ci.degraded) .. [[
${else}${if_match ${battery_percent}>=70}\
]] .. _h.value('${battery_percent}%', ci.good) .. [[
${endif}${endif}${endif}\
]]

  return _h.common('', 'Battery', battery, colorBg)
end

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ---
-- assembly

--[[
disabled = ''
    .. parts.mpd()
    .. parts.uptime()
    .. parts.memory()
    .. parts.battery() 
    .. parts.date()
    .. parts.time()
    .. parts.cputemp()
    .. parts.machine()
]]


enabled = ''
    .. parts.host()
    .. parts.volume()
    .. parts.cpu0()
    .. parts.ssid()
    .. parts.network()
    .. helper.separator()

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ---
-- main

conky.text = [[\
]] .. enabled .. [[\
]]

