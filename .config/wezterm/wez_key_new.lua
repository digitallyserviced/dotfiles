-- the usual
local wezterm = require("wezterm")
local wezG = wezterm.GLOBAL
-- Key mapper helper library
require("lib.keys")

-- Setup a few local vars to make things a bit easier
-- and less repetetive and more verbose
wezG.pane_resize_amount = wezG.pane_resize_amount or 5
local act = wezterm.action
local act_tab_rel = act.ActivateTabRelative
local act_pane_dir = act.ActivatePaneDirection
local adj_pane_size = act.AdjustPaneSize

local adj_pane_size_amountadj = wezterm.action_callback(function(win, pane)
  win:perform_action(adj_pane_size({}))
end)
local rot_pane = act.RotatePanes

local disable = act.DisableDefaultAssignment
local pane_rotate = ACTIONMAP(rot_pane, { "LEADER", "CTRL" })
local pane_act = ACTIONMAP(act_pane_dir, { "LEADER" })
local pane_size = ACTIONMAP(adj_pane_size, { "LEADER" })
local tab_rel = ACTIONMAP(act_tab_rel, { "CTRL" })
local disable_key = ACTIONMAP(disable, { "CTRL", "SHIFT" })

return function(M)
  local keys = {}

  keys = {
    leader = { key = "VoidSymbol", mods = "", timeout_milliseconds = 1001 },
    keys = {
      pane_rotate("b", "CounterClockwise"),
      pane_rotate("n", "Clockwise"),
      -- { key = "b", mods = "LEADER|CTRL", action = M.wezterm.action { RotatePanes = "CounterClockwise" } },
      -- { key = "n", mods = "LEADER|CTRL", action = M.wezterm.action { RotatePanes = "Clockwise" } },
      pane_act("LeftArrow", "Left"),
      pane_act("RightArrow", "Right"),
      pane_act("UpArrow", "Up"),
      pane_act("DownArrow", "Down"),
      -- { key = "LeftArrow", mods = "LEADER", action = M.wezterm.action { ActivatePaneDirection = "Left" } },
      -- { key = "RightArrow", mods = "LEADER", action = M.wezterm.action { ActivatePaneDirection = "Right" } },
      -- { key = "UpArrow", mods = "LEADER", action = M.wezterm.action { ActivatePaneDirection = "Up" } },
      -- { key = "DownArrow", mods = "LEADER", action = M.wezterm.action { ActivatePaneDirection = "Down" } },
      pane_size("h", { "Left", wezG.pane_resize_amount }),
      pane_size("l", { "Right", wezG.pane_resize_amount }),
      pane_size("k", { "Up", wezG.pane_resize_amount }),
      pane_size("j", { "Down", wezG.pane_resize_amount }),
      -- { key = "h", mods = "LEADER", action = M.wezterm.action { AdjustPaneSize = { "Left", 5 } } },
      -- { key = "j", mods = "LEADER", action = M.wezterm.action { AdjustPaneSize = { "Down", 5 } } },
      -- { key = "k", mods = "LEADER", action = M.wezterm.action { AdjustPaneSize = { "Up", 5 } } },
      -- { key = "L", mods = "LEADER", action = M.wezterm.action { AdjustPaneSize = { "Right", 5 } } },
      tab_rel("PageUp", -1),
      tab_rel("PageDown", 1),
      -- { key = "PageUp", mods = "CTRL", action = M.wezterm.action { ActivateTabRelative = -1 } },
      -- { key = "PageDown", mods = "CTRL", action = M.wezterm.action { ActivateTabRelative = 1 } },
      disable_key("L", nil),
      -- { key = "L", mods = "CTRL|SHIFT", action="DisableDefaultAssignment"},
      { key = "D", mods = "LEADER|SHIFT|CTRL", action = M.wezterm.action({ CloseCurrentPane = { confirm = false } }) },
      { key = "p", mods = "LEADER|CTRL", action = M.wezterm.action({ PaneSelect = {} }) },
      { key = "l", mods = "LEADER|CTRL", action = "ShowLauncher" },
      { key = "d", mods = "LEADER|CTRL", action = "ShowDebugOverlay" },
      { key = "r", mods = "LEADER", action = "ReloadConfiguration" },
      { key = "-", mods = "LEADER", action = M.wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
      {
        key = "|",
        mods = "LEADER|SHIFT",
        action = M.wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
      },
      {
        key = ",",
        mods = "CTRL|LEADER",
        action = M.wezterm.action({
          Multiple = {
            {
              SpawnCommandInNewTab = {
                args = { "zsh", "-l", "-c", "nvim", '+"/home/chris/.config/wezterm/M.wezterm.lua"' },
              },
            },
          },
        }),
      },
    },
  }

  if wezG.debug then
    require("lib.styles")
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

    local ROUND_LEFT = SYM("ple_left_half_circle_thick")
    local ROUND_RIGHT = SYM("ple_right_half_circle_thick")
    local SLANT_LEFT = SYM("ple_upper_right_triangle")
    local SLANT_RIGHT = SYM("ple_lower_left_triangle")
    local TOP_TRIANGLE = SYM("pl_right_hard_divider")
    local NEXT_TRIANGLE = SYM("pl_left_hard_divider")

    local num_cells = 0
    local out = {}
    function append(val2)
      -- out = table.move(out, 0, #out, 0, val2)
      -- for i, v in ipairs(out) do
      table.insert(out, wezterm.format(val2))
      -- end
      -- out = val2
    end

    local prevbg = nil
    local nextbg = nil
    local bg = "#000000"
    local fg = "#222222"

    local segments = -3
    local styler = function(cell, cap, ender)
      segments = segments + 1
      cell = cell or nil
      prevbg = palette[(math.abs(segments) - 1 % #palette) + 1]
      bg = palette[(math.abs(segments) % #palette) + 1]
      nextbg = palette[(math.abs(segments) + 1 % #palette) + 1]
      local MAINTXT = STYLE({ BG(bg), FG("#000000") })
      if cell ~= nil then
        append(MAINTXT(cell))
      end
      ender = ender or TOP_TRIANGLE
      if segments > 0 then
        append(STYLE({ BG("#000000"), FG(bg) })(ender))
        if not cap then
          append(STYLE({ BG(nextbg), FG("#000000") })(ender))
        end
      else
        append(STYLE({ BG(nextbg), FG("#000000") })(ender))
        if not cap then
          append(STYLE({ BG("#000000"), FG(bg) })(ender))
        end
      end
    end

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
      "#2f2239",
    }
    -- local out = {
    --   wezterm.format(STYLE({BG(palette[10]), FG(palette[8])})("Close: ")),
    --   wezterm.format(STYLE({FG(palette[1]),  BG(palette[10]), UL("Single")})(" y")),
    --   wezterm.format(STYLE({BG(palette[10]), FG(palette[3])})(" / ")),
    --   wezterm.format(STYLE({FG(palette[2]),  BG(palette[10]), UL("Single")})("n ")),
    -- }
    -- local confirm_prompt = act.ConfirmPrompt
    -- local emit = act.EmitEvent
    -- wezterm.emit("refresh_exec_domains")
    -- local cp = ACTIONMAP("ConfirmPrompt", {"CTRL","LEADER"})
    -- keys.keys = table.insert(keys.keys, {key = "P", mods="LEADER|CTRL", action=M.wezterm.action{ConfirmPrompt={prompt="WTF", mode="AnyKey"}}})
    -- keys.keys =
    -- table.insert(keys.keys, cp("M", {prompt="HOLYSHIT"}))
  end

  return keys
end
