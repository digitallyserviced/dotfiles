local wezterm = require("wezterm")
local tablelib = require("tablelib")

---Maps a key assignment
---@param key string | table a string for the key or define all arguments in a positional table
---@otional mods string | table (Optional)if string then like "CTRL|SHIFT" otherwise {"CTRL","SHIFT"}
---@optional action table (Optional)
---@return table args to a single keymap config
function KEYMAP(key, mods, action)
  if type(key) == "table" then
    return KEYMAP(table.unpack(key))
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

function MAKEACTION(obj, action, default_args, arg_func)
  obj = assert(obj, "obj needs to be provided as window or pane object")
  default_args = default_args or {}
  local event = nil
  if type(action) == "string" then
    if assert(wezterm.action[action], "Action does not exist") == nil then
      event = action
    else
      action = wezterm.action[action]
    end
  elseif type(action) == "userdata" then
    wezterm.log_info(
      string.format(
        "MAKEACTION provided with action userdata (direct from wezterm object) with default args of %s",
        default_args
      )
    )
  end

  local callargs = nil
  local fun = function(pane, args, force_args)
    if force_args then
      callargs = args
    elseif type(arg_func) == "function" then
      callargs = arg_func(callargs, args, pane)
    elseif type(args) == "table" then
      tablelib.merge_all(default_args, args)
    end
    if event then
      wezterm.emit(event, callargs, pane)
    else
      local callaction = action
      if type(action) == "userdata" and callargs ~= nil then
        callaction = action(callargs)
      else
        wezterm.log_info({ event, callargs, pane })
      end
      obj:perform_action(callaction, pane)
    end
  end
  fun.current_args = callargs
  fun.default_args = default_args

  return fun
end

--[[
Maps an action instead of individual keys with a base action and modkeys
    ```
    local wezterm = require('wezterm')
    local act = wezterm.action
    local adj_pane_size = act.AdjustPaneSize
    local pane_size = ACTIONMAP(adj_pane_size, {"LEADER","CTRL"})
    keys = { pane_size("h", {"Left", 5}) }
    ````
Or use it as a modmapper with the following
    ```lua
    local wezterm = require('wezterm')
    local sdo = wezterm.action.ShowDebugOverlay
    local ldr_shift = ACTIONMAP(nil, {"LEADER","SHIFT"})
    -- leader + shift + d show debug overlay
    ldr_shift("d", "ShowDebugOverlay")
    -- or the same key combo just using the actual action ref
    ldr_shift("d", sdo)
    ````
@param action function
@param mods string | table if string then like "CTRL|SHIFT" otherwise {"CTRL","SHIFT"}
@return function helper function to bind multiple keys to the same action with arguments ]]

function ACTIONMAP(action, mods)
  wezterm.log_info(wezterm.action)
  local modmap = false
  if type(action) == "string" then
    assert(wezterm.action[action], "Action does not exist")
    action = wezterm.action[action]
  elseif action == nil then
    -- wezterm.log_info(string.format("ACTIONMAP without original action for mods (%s) will require action later.", table.concat(mods, "|")))
    modmap = true
  elseif type(action) == "userdata" then
    -- wezterm.log_info(string.format("ACTIONMAP provided with action userdata (direct from wezterm object) for %s", table.concat(mods, "|")))
  else
    _ = true
    -- wezterm.log_error(string.format("ACTIONMAP provided with invalid value for action %s", table.concat(mods, "|")))
  end
  mods = mods or {}
  ---@param key string
  ---@param action_args string | table
  ---       single arguments (i.e. RotatePanes="ClockWise") provide "Clockwise"
  ---       otherwise if there are multiple arguments provide a table (i.e. AdjustPaneSize = {"Left", 5}) provide {"Left", 5}
  return function(key, action_args)
    -- wezterm.log_info(string.format("ACTIONMAP for mods (%s) mapped %s for %s(%s).", table.concat(mods, "|"), key, action, action_args))
    -- make action the action with args or use args as the action
    local call_action = action
    if modmap then
      call_action = action_args
    elseif action ~= nil and action_args ~= nil then
      call_action = action(action_args)
    end
    return KEYMAP(table.pack(key, mods, call_action))
  end
end
