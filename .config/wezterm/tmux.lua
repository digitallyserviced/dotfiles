local template = require("lib.template")
local C = require("lib.color")
local terafox=require('palette.terafox')
local M = {}

local dbg = require('dbg')

function M.generate(spec)
  -- local colors = {
  --   bg = spec.bg0,
  --   fg = spec.fg2,
  --   fg_alt = spec.fg3,
  -- }
  local boxes = { "cpu_box", "mem_box", "net_box", "proc_box" }
  local grads = { "temp", "cpu", "free", "cached", "available", "used", "download", "upload" }
  local grad_steps = { "start", "mid", "end" }

  local themeKeys = {
    "main_bg", "main_fg", "title", "hi_fg",
    "selected_bg", "selected_fg", "inactive_fg",
    "graph_text", "proc_misc",
    "cpu_box", "mem_box", "net_box", "proc_box",
    "div_line",
    "temp_start", "temp_mid", "temp_end",
    "cpu_start", "cpu_mid", "cpu_end",
    "free_start", "free_mid", "free_end",
    "cached_start", "cached_mid", "cached_end",
    "available_start", "available_mid", "available_end",
    "used_start", "used_mid", "used_end",
    "download_start", "download_mid", "download_end",
    "upload_start", "upload_mid", "upload_end"
  }
  local theme = {}
  local offset = 0
  dbg()
  print(spec)
  for i, v in ipairs({ spec.bg0, spec.fg0, spec.fg3, spec.cyan.bright }) do
    theme[themeKeys[i]] = v
  end
  offset = 4
  for i, v in ipairs({ spec.bg3, spec.sel1, spec.sel0 }) do
    theme[themeKeys[i + offset]] = v
  end
  offset = 7
  for i, v in ipairs({ spec.red.base, spec.green.bright }) do
    theme[themeKeys[i + offset]] = v
  end
  offset = 9
  for i, v in ipairs({ spec.orange.dim, spec.pink.dim, spec.cyan.dim, spec.blue.bright }) do
    theme[themeKeys[i + offset]] = v
  end
  offset = 13
  for i, v in ipairs({ spec.blue.base }) do
    theme[themeKeys[i + offset]] = v
  end

  function gradFor(orig, to, amount)
    amount = amount or 0.15
    to = to or spec.bg0
    orig = orig.base and orig.base or orig
    return C(orig):blend(C(to), amount):to_css()
  end

  function startMidEndGradFor(orig, fer)
    local grad = {}
    grad[fer .. "_start"] = gradFor(orig.bright, C(orig.bright):shade(0.3))
    grad[fer .. "_mid"] = gradFor(orig.base, C(orig.base):shade(0.6))
    grad[fer .. "_end"] = gradFor(orig.dim, C(orig.dim):shade(0.9))
    return grad
  end

  function makeGrads()
    local cols = {"red","green","yellow","blue","magenta","cyan","white","orange","pink"}
    while #grads > 0 do
      local themekey = table.remove(grads, 1)
      local color = table.remove(cols)
      local sme = startMidEndGradFor(spec[color], themekey)
      for index, value in pairs(sme) do
        theme[index]=value
      end
    end
  end
    -- for _, item in ipairs(grads) do
    --
    -- end
  makeGrads();
  local content=[[
  ]]

  function append(what)
    local str = string.format("%s\n", what)
    content = content .. str
  end
  function themestr(tk, val)
    return string.format('theme[%s]="%s"', tk, val)
  end
  for key, value in pairs(theme) do
    append(themestr(key, value))
  end
  print(content)

  local filed=io.open("/home/chris/.config/btop/themes/terafox.theme", "w")
  if filed ~= nil then
    filed:write(content)
    filed:flush()
    filed:close()
  end
end

  -- _ = theme
M.generate(terafox.spec)

-- end

return M

--   local content = [[
-- #!/usr/bin/env bash
-- # Nightfox colors for Tmux
-- # Style: ${meta.name}
-- # Upstream: ${meta.url}
-- set -g mode-style "fg=${blue},bg=${fg}"
-- set -g message-style "fg=${blue},bg=${fg}"
-- set -g message-command-style "fg=${blue},bg=${fg}"
-- set -g pane-border-style "fg=${fg}"
-- set -g pane-active-border-style "fg=${blue}"
-- set -g status "on"
-- set -g status-justify "left"
-- set -g status-style "fg=${blue},bg=${bg}"
-- set -g status-left-length "100"
-- set -g status-right-length "100"
-- set -g status-left-style NONE
-- set -g status-right-style NONE
-- set -g status-left "#[fg=${black},bg=${blue},bold] #S #[fg=${blue},bg=${bg},nobold,nounderscore,noitalics]"
-- set -g status-right "#[fg=${bg},bg=${bg},nobold,nounderscore,noitalics]#[fg=${blue},bg=${bg}] #{prefix_highlight} #[fg=${fg},bg=${bg},nobold,nounderscore,noitalics]#[fg=${blue},bg=${fg}] %Y-%m-%d  %I:%M %p #[fg=${blue},bg=${fg},nobold,nounderscore,noitalics]#[fg=${black},bg=${blue},bold] #h "
-- setw -g window-status-activity-style "underscore,fg=${fg_alt},bg=${bg}"
-- setw -g window-status-separator ""
-- setw -g window-status-style "NONE,fg=${fg_alt},bg=${bg}"
-- setw -g window-status-format "#[fg=${bg},bg=${bg},nobold,nounderscore,noitalics]#[default] #I  #W #F #[fg=${bg},bg=${bg},nobold,nounderscore,noitalics]"
-- setw -g window-status-current-format "#[fg=${bg},bg=${fg},nobold,nounderscore,noitalics]#[fg=${blue},bg=${fg},bold] #I  #W #F #[fg=${fg},bg=${bg},nobold,nounderscore,noitalics]"
-- ]]
