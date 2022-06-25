local wezterm = require('wezterm')
local act = wezterm.action
local act_tab_rel = act.ActivateTabRelative
local act_pane_dir = act.ActivatePaneDirection
local adj_pane_size = act.AdjustPaneSize
local rot_pane = act.RotatePanes
local disable = act.DisableDefaultAssignment

---Maps a key assignment
---@param key string | table a string for the key or define all arguments in a positional table
---@otional mods string | table (Optional)if string then like "CTRL|SHIFT" otherwise {"CTRL","SHIFT"}
---@optional action table (Optional)
---@return table args to a single keymap config
local function keymap(key, mods, action)
  if type(key) == "table" then
    return keymap(unpack(key))
  else
    key = assert(key, "Key required for keymapping")
    mods = assert(mods, "Key required for keymapping")
    action = assert(action, "Key required for keymapping")
  end

  local map = {}
  map["key"] = key
  map["mods"] = type(mods) == "string" and mods or table.concat(mods, "|")
  map["action"] = action or wezterm.action_callback(function() end)
  return map
end

---Maps an action instead of individual keys
---provides a function to provide arguments and a key for a 
---preset action
---@param action function
---@param mods string | table if string then like "CTRL|SHIFT" otherwise {"CTRL","SHIFT"}
---@param action table
---@return Color
local function actionmap(action, mods)

end
return function(M)
  local keys = {}

  keys = {
    leader = { key = "VoidSymbol", mods = "", timeout_milliseconds = 1001 },
    keys = {
      { key = "D", mods = "LEADER|SHIFT|CTRL", action = M.wezterm.action { CloseCurrentPane = { confirm = true } } },
      { key = "p", mods = "LEADER|CTRL", action = M.wezterm.action { PaneSelect = {}} },
      { key = "l", mods = "LEADER|CTRL", action = "ShowLauncher" },
      { key = "b", mods = "LEADER|CTRL", action = M.wezterm.action { RotatePanes = "CounterClockwise" } },
      { key = "n", mods = "LEADER|CTRL", action = M.wezterm.action { RotatePanes = "Clockwise" } },
      { key = "d", mods = "LEADER|CTRL", action = "ShowDebugOverlay" },
      { key = "L", mods = "CTRL|SHIFT", action="DisableDefaultAssignment"},
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
