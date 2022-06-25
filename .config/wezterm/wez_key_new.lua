-- the usual
local wezterm = require('wezterm')

-- Key mapper helper library
require('lib.keys')

-- Setup a few local vars to make things a bit easier
-- and less repetetive and more verbose
local act = wezterm.action
local act_tab_rel = act.ActivateTabRelative
local act_pane_dir = act.ActivatePaneDirection
local adj_pane_size = act.AdjustPaneSize
local rot_pane = act.RotatePanes

local disable = act.DisableDefaultAssignment
local pane_rotate = ACTIONMAP(rot_pane, {"LEADER","CTRL"})
local pane_act = ACTIONMAP(act_pane_dir, {"LEADER"})
local pane_size = ACTIONMAP(adj_pane_size, {"LEADER"})
local tab_rel = ACTIONMAP(act_tab_rel, {"CTRL"})
local disable_key = ACTIONMAP(disable, {"CTRL","SHIFT"})

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
      pane_size("h", {"Left", 5}),
      pane_size("l", {"Right", 5}),
      pane_size("k", {"Up", 5}),
      pane_size("j", {"Down", 5}),
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
      { key = "D", mods = "LEADER|SHIFT|CTRL", action = M.wezterm.action { CloseCurrentPane = { confirm = false } } },
      { key = "p", mods = "LEADER|CTRL", action = M.wezterm.action { PaneSelect = {}} },
      { key = "l", mods = "LEADER|CTRL", action = "ShowLauncher" },
      { key = "d", mods = "LEADER|CTRL", action = "ShowDebugOverlay" },
      { key = "r", mods = "LEADER", action = "ReloadConfiguration" },
      { key = "-", mods = "LEADER", action = M.wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } } },
      { key = "|", mods = "LEADER|SHIFT", action = M.wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } } },
      {
        key = ",",
        mods = "CTRL|LEADER",
        action = M.wezterm.action {
          Multiple = {
            {
              SpawnCommandInNewTab = {
                args = { "zsh", "-l", "-c", "nvim", '+"/home/chris/.config/wezterm/M.wezterm.lua"' },
              },
            },
          },
        },
      },
    },
  }

  return keys

end
