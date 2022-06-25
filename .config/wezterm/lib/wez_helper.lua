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
  M.pprint = function(...)
    wt.log_info(dump({ { ... } }))
  end
  M.debug = false
  wezterm = assert(wt, "Helper needs wezterm module passed")
  local config_dir = wezterm.config_dir

  M.wezterm=wezterm
  M.tables = require("tablelib")
  _G["paths"] = require("paths")(M)

  local chars = require('chars')

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
      action = wezterm.action(action)
    end

    return {
      mods = mods,
      key = key,
      action = action,
    }
  end


  M.is_windows = wezterm.target_triple:match("windows") ~= nil
  M.is_macos = wezterm.target_triple:match("darwin") ~= nil
  M.is_nix = wezterm.target_triple:match("linux") ~= nil
  M.is_posix_path = (M.is_macos or M.is_nix)

  return M
end

return helper(wezterm)
