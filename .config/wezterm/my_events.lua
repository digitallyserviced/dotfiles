local events = require("lib.wez_events")()
local palette = {
  "#e85c51",
  "#7aa4a1",
  "#fda47f",
  "#5a93aa",
  "#ad5c7c",
  "#a1cdd8",
  "#ebebeb",
  "#ff8349",
  "#cb7985",
}

local timed = 0

events.on("window-config-reloaded", function(window, pane)
  local str = "Reloaded config"

  if timed == 0 then
    timed = tonumber(wezterm.strftime("%s"))
  else
    str = "Reloaded config: " .. tostring(tonumber(wezterm.strftime("%s%.3f")) - timed)
    timed = 0
  end

end)

events.on('open-uri', function(window, p, uri)
      wezterm.log_info(uri)
  local start, match_end = uri:find("nvr:")
  if start == 1 then
    local filepath = uri:sub(match_end + 1)
  -- window:toast_notification("wezterm", filepath, nil, 4000)
    wezterm.action_callback(function(win, pane)
      wezterm.background_child_process(
          {"nvr", wezterm.glob(filepath)}
      )
    end)
    -- window:perform_action(wezterm.action { SpawnCommandInNewWindow = {
    --   args = { "mutt", recipient }
    -- } }, pane);
    -- prevent the default action from opening in a browser
    return false
  end
  return true
  -- code
end)
events.on("format-window-title", function(tab, pane, tabs, panes, config)
  local zoomed = ""
  if tab.active_pane.is_zoomed then
    zoomed = "[Z] "
  end

  local index = ""
  if #tabs > 1 then
    index = string.format("[%d/%d] ", tab.tab_index + 1, #tabs)
  end

  return zoomed .. index .. tab.active_pane.title
end)

events.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local num = tab.tab_index
  local inspect = require('inspect')
  wezterm.log_info(inspect(panes))
  local pcol = (num % #palette) + 1
  local bg = palette[pcol]
  local txt = "#444444"

  local pane = tab.active_pane
  local title = paths.basename(pane.foreground_process_name) .. " " .. pane.pane_id

  if tab.is_active then
    bg = palette[((pcol + 8) % #palette) + 1]
    txt = "#000000"
  elseif hover then
    bg = palette[((pcol - 8) % #palette) + 1]
    txt = "#222222"
  end

  -- local title = wezterm.pad_left(tab.active_pane.title, "6")
  -- title = wezterm.pad_right(tab.active_pane.title, "2")
  local intensity = tab.is_active == true and "Bold" or "Normal"

  local out = {}
  function append(val2)
    for i, v in ipairs(val2) do
      table.insert(out, v)
    end
  end

  local LEFT_SLASH = SYM('ple_left_hard_divider')
  local RIGHT_SLASH = SYM('ple_right_hard_divider')
  local ico = tab.is_active and '⬤' or '⭘'
  local SYNLEDGE = STYLE({ BG("#000000"), FG(bg) })
  local SYEDGE = STYLE({ UL("Single"), BG("#000000"), FG(bg) })
  local ACTIVE = STYLE({ UL("Single"), FG(bg) })(" " .. ico .. " ")
  -- local LEFT=SYEDGE(ROUND_LEFT)
  -- local RIGHT=SYEDGE(ROUND_RIGHT)
  local LEFT = SYNLEDGE(LEFT_SLASH)
  local RIGHT = SYEDGE(LEFT_SLASH)
  local PAD = STYLE({ UL("Single") })
  -- local MAINTXT=STYLE({BG("#222222"), HL('https://www.google.com'), FG(bg), UL(tab.is_active and "Single" or "None"), BL(tab.is_active)})
  local MAINTXT = STYLE({ HL('https://www.google.com'), UL("Single"), FG(bg), BL(tab.is_active) })
  append(LEFT)
  append(PAD(" "))
  append(ACTIVE)
  append(MAINTXT(" " .. title .. " "))
  append(PAD(" "))
  append(RIGHT)
  return out
end)

events.on("update-right-status", function(window, pane)
  -- Each element holds the text for a cell in a "powerline" style << fade
  local cells = {}
  -- Figure out the cwd and host of the current pane.
  -- This will pick up the hostname for the remote host if your
  -- shell is using OSC 7 on the remote host.
  local leader = ""
  if window:leader_is_active() then
    leader = "LEADER"
  end
  -- wezterm:toast_notification("wezterm", pane.foreground_process_name, nil, 4000)
  local cwd_uri = pane:get_current_working_dir()
  -- wezterm.log_info(pane:get_user_vars())
  -- wezterm.log_error(cwd_uri)
  if cwd_uri then
    cwd_uri = cwd_uri:sub(8)
    local slash = cwd_uri:find("/")
    local cwd = ""
    local hostname = ""
    if slash then
      hostname = cwd_uri:sub(1, slash - 1)
      -- Remove the domain name portion of the hostname
      local dot = hostname:find("[.]")
      if dot then
        hostname = hostname:sub(1, dot - 1)
      end
      -- and extract the cwd from the uri
      cwd = cwd_uri:sub(slash, -1)

      table.insert(cells, cwd)
      table.insert(cells, hostname)
    end
  end

  if string.len(leader) > 0 then
    table.insert(cells, leader)
  end

  local date = wezterm.strftime("%a %b %-d %H:%M")
  table.insert(cells, date)

  local num_cells = 0
  local out = {}
  function append(val2)
    -- out = table.move(out, 0, #out, 0, val2)
    for i, v in ipairs(out) do
      table.insert(val2, v)
    end
    out = val2
  end

  local prevbg = nil
  local nextbg = nil
  local bg = "#000000"
  local fg = "#222222"

  local segments = 1
  local styler = function(cell, cap)
    segments = segments + 1
    cell = cell or nil
    prevbg = palette[((segments) - 1 % #palette) + 1]
    bg = palette[((segments) % #palette) + 1]
    nextbg = palette[((segments) + 1 % #palette) + 1]
    local MAINTXT = STYLE({ BG(bg), FG("#000000") })
    if cell ~= nil then
      append(MAINTXT(cell))
    end
    if segments > 0 then
      append(STYLE({ BG("#000000"), FG(bg) })(TOP_TRIANGLE))
      if not cap then
        append(STYLE({ BG(nextbg), FG("#000000") })(TOP_TRIANGLE))
      end
    end
  end
  while #cells > 0 do
    local cell = table.remove(cells, 1)
    styler(cell)
  end
  styler("")
  styler("")
  styler(nil, true)

  window:set_right_status(wezterm.format(out))
end)
