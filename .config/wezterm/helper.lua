---@diagnostic disable: unused-local
-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
function dump(o)
  if type(o) == "table" then
    local s = "{ "
    for k, v in pairs(o) do
      if type(k) ~= "number" then
        k = '"' .. k .. '"'
      end
      s = s .. "[" .. k .. "] = " .. dump(v) .. ","
    end
    return s .. "} "
  else
    return tostring(o)
  end
end

function helper(wt)
  local M = {}
  local timed = 0
  M.pprint = function(...)
    wt.log_info(dump({ { ... } }))
  end
  M.debug = false
  M.wezterm = assert(wt, "Helper needs wezterm module passed")
  local config_dir = M.wezterm.config_dir

  M.tables = require("tablelib")
  M.paths = require("paths")(M)

  local TOP_TRIANGLE = ""
  local NEXT_TRIANGLE = ""
  local palette = {
    "#F24732",
    "hsl(200 50% 60%)",
    "#ffb454",
    "#59c2ff",
    "#95e6cb",
  }

  function M.set_palette(name)
    local ok, pal = pcall(require, table.concat({ "lib", name }, "."))
    if ok then
      local p = {}
      for index, value in ipairs(pal.spec.syntax) do
        table.insert(p, value)
      end
      palette = p
    end
  end

  function M.merge(t1, t2)
    for _, v in ipairs(t2) do
      table.insert(t1, v)
    end

    return t1
  end

  function M.keybind(mods, key, action)
    if type(action) == "table" then
      action = M.wezterm.action(action)
    end

    return {
      mods = mods,
      key = key,
      action = action,
    }
  end

  M.events = require("events")(M)

  M.events.on("window-config-reloaded", function(window, pane)
    local str = "Reloaded config"

    if timed == 0 then
      timed = tonumber(M.wezterm.strftime("%s"))
    else
      str = "Reloaded config: " .. tostring(tonumber(M.wezterm.strftime("%s%.3f")) - timed)
      timed = 0
    end

    window:toast_notification("wezterm", str, nil, 4000)
  end)

  M.events.on("format-window-title", function(tab, pane, tabs, panes, config)
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

  M.events.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local edge_background = palette[6]
    local background = palette[4]
    local foreground = palette[5]
    local txt = "#444444"

    local pane = tab.active_pane
    local title = basename(pane.foreground_process_name) .. " " .. pane.pane_id

    if tab.is_active then
      background = palette[5]
      foreground = palette[1]
      txt = "#000000"
    elseif hover then
      background = palette[4]
      foreground = palette[1]
      txt = "#222222"
    end

    local edge_foreground = background

    local title = M.wezterm.pad_left(tab.active_pane.title, "6")
    title = M.wezterm.pad_right(tab.active_pane.title, "2")
    local intensity = tab.is_active == true and "Bold" or "Normal"

    local num = tab.tab_index
    return {
      { Text = " " },
      { Background = { Color = "#000000" } },
      { Foreground = { Color = foreground } },
      { Text = "" },
      { Background = { Color = foreground } },
      { Foreground = { Color = txt } },
      { Text = " " .. string.sub(title, 1, max_width - 5) .. " " },
      { Background = { Color = "#000000" } },
      { Foreground = { Color = foreground } },
      { Text = "" },
      { Text = " " },
    }
  end)

  M.styles = {}

  M.styles.addStyle = function(name, fg, bg, intensity, underline, italic)
    italic = italic and {Attribute={Italic=italic}} or M.styles.default.italic
    underline = underline and {Attribute={Underline=underline}} or M.styles.default.italic
    intensity = intensity and {Attribute={Underline=underline}} or M.styles.default.italic
    fg = fg and { Foreground = { Color = fg}} or M.styles.default.fg
    bg = bg and {Background = {Color = bg}} or M.styles.default.bg
    if M.styles[name] == nil then
      M.styles[name] = {
        fg,bg,intensity,underline,italic
      }
    end
  end

  M.formatter.textStyled = function(text, fg, bg)
    local format = {}
    return {
      { Foreground = fg },
      { Background = bg },
      { Text = text },
    }
  end

  M.events.on("update-right-status", function(window, pane)
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
        cwd = cwd_uri:sub(slash)

        -- table.insert(cells, cwd)
        table.insert(cells, hostname)
      end
    end

    if string.len(leader) > 0 then
      table.insert(cells, leader)
    end

    local date = M.wezterm.strftime("%a %b %-d %H:%M")
    table.insert(cells, date)

    -- Color palette for the backgrounds of each cell
    local colors = palette

    local hsl = "hsl(%hue% %sat% 60%)"
    local color_hue = 200
    local incr = 40
    local sat = 50

    local function get_color(update, sats)
      sats = sats or false
      local new_color = color_hue + incr
      if update then
        color_hue = new_color
      end
      local hsl_new = ""
      if not sats then
        hsl_new = string.gsub(hsl, "%%sat%%", tostring(sat) .. "%%")
      else
        hsl_new = string.gsub(hsl, "%%sat%%", tostring(sat) .. "%%")
      end
      -- M.wezterm.log_info(hsl_new)
      return string.gsub(hsl_new, "%%hue%%", tostring(new_color))
    end

    -- Foreground color for the text across the fade
    local text_fg = "#222222"

    -- The elements to be formatted
    local elements = {}
    -- How many cells have been formatted
    local num_cells = 0

    -- Translate a cell into elements
    local function push(text, is_last)
      -- local cell_no = (num_cells + 1) % 5
      local color = get_color(false)
      table.insert(elements, { Foreground = { Color = text_fg } })
      table.insert(elements, { Background = { Color = color } })
      table.insert(elements, { Text = " " .. text .. " " })
      if not is_last then
        table.insert(elements, { Foreground = { Color = get_color(false, true) } })
        table.insert(elements, { Background = { Color = get_color(false, false) } })
        table.insert(elements, { Text = NEXT_TRIANGLE })
        table.insert(elements, { Foreground = { Color = get_color(true, true) } })
        table.insert(elements, { Text = TOP_TRIANGLE })
      end
      num_cells = num_cells + 1
    end

    table.insert(elements, { Foreground = { Color = get_color() } })
    table.insert(elements, { Text = NEXT_TRIANGLE })

    table.insert(elements, { Foreground = { Color = get_color() } })
    table.insert(elements, { Text = TOP_TRIANGLE })

    while #cells > 0 do
      local cell = table.remove(cells, 1)
      push(cell, #cells == 0)
    end

    window:set_right_status(M.wezterm.format(elements))
  end)

  M.is_windows = M.wezterm.target_triple:match("windows") ~= nil
  M.is_macos = M.wezterm.target_triple:match("darwin") ~= nil
  M.is_nix = M.wezterm.target_triple:match("linux") ~= nil
  M.is_posix_path = (M.is_macos or M.is_nix)

  return M
end

return helper
