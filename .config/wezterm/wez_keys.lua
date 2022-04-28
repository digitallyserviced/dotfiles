return function(M)
  local keys = {}

  keys = {
    leader = { key = "VoidSymbol", mods = "", timeout_milliseconds = 1001 },
    keys = {
      { key = "D", mods = "LEADER|SHIFT|CTRL",  action=M.wezterm.action{CloseCurrentPane={confirm=true}}},
      { key = "l", mods = "LEADER|CTRL", action = "ShowLauncher" },
      { key = "d", mods = "LEADER|CTRL", action = "ShowDebugOverlay" },
      { key = "r", mods = "LEADER", action = "ReloadConfiguration" },
      { key = "LeftArrow", mods = "LEADER", action = M.wezterm.action { ActivatePaneDirection = "Left" } },
      { key = "RightArrow", mods = "LEADER", action = M.wezterm.action { ActivatePaneDirection = "Right" } },
      { key = "UpArrow", mods = "LEADER", action = M.wezterm.action { ActivatePaneDirection = "Up" } },
      { key = "DownArrow", mods = "LEADER", action = M.wezterm.action { ActivatePaneDirection = "Down" } },
      { key = "h", mods = "LEADER", action = M.wezterm.action { AdjustPaneSize = { "Left", 5 } } },
      { key = "j", mods = "LEADER", action = M.wezterm.action { AdjustPaneSize = { "Down", 5 } } },
      { key = "k", mods = "LEADER", action = M.wezterm.action { AdjustPaneSize = { "Up", 5 } } },
      { key = "L", mods = "LEADER", action = M.wezterm.action { AdjustPaneSize = { "Right", 5 } } },
      { key = "-", mods = "LEADER", action = M.wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } } },
      { key = "|", mods = "LEADER|SHIFT", action = M.wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } } },
      { key = "PageUp", mods = "CTRL", action = M.wezterm.action { ActivateTabRelative = -1 } },
      { key = "PageDown", mods = "CTRL", action = M.wezterm.action { ActivateTabRelative = 1 } },
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
