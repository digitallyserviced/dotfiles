---@diagnostic disable: unused-local
-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
require('styles')
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

  local chars = require('chars')
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

  local ROUND_LEFT = SYM('ple_left_half_circle_thick')
  local ROUND_RIGHT = SYM('ple_right_half_circle_thick')
  local SLANT_LEFT = SYM('ple_upper_right_triangle')
  local SLANT_RIGHT = SYM('ple_lower_left_triangle')
  local TOP_TRIANGLE = SYM('pl_right_hard_divider')
  local NEXT_TRIANGLE = SYM('pl_right_soft_divider')

  local color_list = { "red", "green", "yellow", "blue", "magenta", "cyan"}
  local color_scale = { "base", "bright", "dim" }

  function M.set_palette(name)
    local ok, pal = pcall(require, table.concat({ "palette", name }, "."))
    if ok then
      local p = {}
      for index, scale in pairs(color_scale) do
        for i,v in pairs(color_list) do
          table.insert(p, pal.palette[v][scale])
        end
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

  end)

  M.events.on('open-uri', function(window, p, uri)
    local start, match_end = uri:find("nvr:")
    if start == 1 then
      local filepath = uri:sub(match_end + 1)
    -- window:toast_notification("wezterm", filepath, nil, 4000)
      M.wezterm.action_callback(function(win, pane)
        M.wezterm.background_child_process(
            {"nvr", M.wezterm.glob(filepath)}
        )
      end)
      -- window:perform_action(M.wezterm.action { SpawnCommandInNewWindow = {
      --   args = { "mutt", recipient }
      -- } }, pane);
      -- prevent the default action from opening in a browser
      return false
    end
    return true
    -- code
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
    local num = tab.tab_index
    if (type(num) ~= type({})) then
      num=0
    end
    local pcol = (tonumber(num) % #palette) + 1
    local bg = palette[pcol]
    local txt = "#444444"

    local pane = tab.active_pane
    local title = M.paths.basename(pane.foreground_process_name) .. " " .. pane.pane_id

    if tab.is_active then
      bg = palette[((pcol + 8) % #palette) + 1]
      txt = "#000000"
    elseif hover then
      bg = palette[((pcol - 8) % #palette) + 1]
      txt = "#222222"
    end

    -- local title = M.wezterm.pad_left(tab.active_pane.title, "6")
    -- title = M.wezterm.pad_right(tab.active_pane.title, "2")
    local intensity = tab.is_active == true and "Bold" or "Normal"

    local out = {}
    function append(val2)
      for i, v in ipairs(val2) do
        table.insert(out, v)
      end
    end
-- ︰︱︲︳︴︵︶︷︸︹︺︻︼︽︾︿﹀﹁﹂﹃﹄﹅﹆﹇﹈﹉﹊﹋﹌﹍﹎﹏🯁🯂🯃       🮲🮳🬫🬛     🬸🬴      🬜🬪     🮹🮺      🬕🬷       🬲🬨     🬛🬤   🬥🬶    🬺🬬    🬻🬝     🬝🬻  🬴🬸  🬱🬊     🬍🬖    🬍🬚    🬱🬵     🬚🬩    🬕🬘🬡    🬡🬲🬵🬮🬰    
  local RIGHT_SLASH = SYM('pl_left_hard_divider')
  local LEFT_SLASH = SYM('pl_right_hard_divider')
  local SOFT_RIGHT_SLASH = SYM('pl_left_soft_divider')
  local SOFT_LEFT_SLASH = SYM('pl_right_soft_divider')
    local ico = tab.is_active and '⬤' or '⭘'
    local SOFT_SYNLEDGE = STYLE({ BG(bg), BL(true), FG('#000000') })
    local SOFT_SYEDGE = STYLE({ BG(bg), BL(true), FG('#000000') })
    local SYNLEDGE = STYLE({ BG("#000000"), BL(true), FG(bg) })
    local SYEDGE = STYLE({ BG("#000000"), BL(true), FG(bg) })
    local ACTIVE = STYLE({ FG(txt), BG(bg) })(" " .. ico .. " ")
    -- local LEFT=SYEDGE(ROUND_LEFT)
    -- local RIGHT=SYEDGE(ROUND_RIGHT)
    local SOFT_LEFT = SOFT_SYNLEDGE(SOFT_LEFT_SLASH)
    local SOFT_RIGHT = SOFT_SYEDGE(SOFT_RIGHT_SLASH)
    local LEFT = SYNLEDGE(LEFT_SLASH)
    local RIGHT = SYEDGE(RIGHT_SLASH)
    local PAD = STYLE({ BG(bg)})
    -- local MAINTXT=STYLE({BG("#222222"), HL('https://www.google.com'), FG(bg), UL(tab.is_active and "Single" or "None"), BL(tab.is_active)})
    local MAINTXT = STYLE({ BG(bg), FG(txt), BL(tab.is_active), HL('https://www.google.com') })
    append(LEFT)
    append(SOFT_LEFT)
    -- append(PAD(" "))
    append(ACTIVE)
    append(MAINTXT(" " .. title .. " "))
    append(PAD(" "))
    append(SOFT_RIGHT)
    append(RIGHT)
    return out
  end)

  -- M.styles.makeStyle = function(attrs)
  --   return {
  --     attrs
  --   }
  -- end
  --
  -- M.styles.addStyle = function(name, attrs)
  --   local style = M.styles.makeStyle(fg, bg, intensity, underline, italic)
  --   if M.styles[name] == nil then
  --     M.styles[name] = {
  --       fg, bg, intensity, underline, italic
  --     }
  --   end
  -- end
  --
  -- M.styles.textStyled = function(text, attrs)
  --   local format = attrs
  --   return {
  --     table.unpack(format), TEXT(text)
  --   }

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
    M.wezterm.log_info(pane:get_user_vars())
    -- M.wezterm.log_error(cwd_uri)
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

    local date = M.wezterm.strftime("%a %b %-d %H:%M")
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

    window:set_right_status(M.wezterm.format(out))
  end)

  M.is_windows = M.wezterm.target_triple:match("windows") ~= nil
  M.is_macos = M.wezterm.target_triple:match("darwin") ~= nil
  M.is_nix = M.wezterm.target_triple:match("linux") ~= nil
  M.is_posix_path = (M.is_macos or M.is_nix)

  return M
end

return helper
