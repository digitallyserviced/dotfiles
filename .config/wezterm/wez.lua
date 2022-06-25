_G["wezterm"] = require("wezterm")
_G["helper"] = require("lib.wez_helper")
local tablelib = require "tablelib"
local M = {}

function Config(wt)
  M.base_options = nil
  M.wezterm = assert(wt, "Need main wezterm module passed as argument")
  local helper = require("helper")
  M.helper = helper(M.wezterm)

  M.config = function()
    local key_cfg = require("wez_keys")(M)

    local options_static = require("options_static")
    local options_dynamic = require('options_dynamic')
    local colors = require("colors")
    M.helper.set_palette("terafox")
    options_static.color_scheme_dirs = {
      M.helper.paths.path_join(wt.config_dir, "color_schemes")
    }

    M.base_options = M.helper.merge(options_static, options_dynamic(M))
    M.base_options.colors = colors.colors
    M.base_options.color_schemes = colors.color_schemes
    M.base_options.leader = key_cfg.leader
    M.base_options.keys = key_cfg.keys

    return M.base_options
  end

  M.reload_paths = function (paths)
    paths = paths or {}
    M.helper.paths.setup_reload_paths(paths)
  end

  M.override = function(overrides)
    M.base_options = M.base_options or M.config()
    overrides = overrides or {}
    return tablelib.merge_all(M.base_options, overrides)
  end

  M.bind_events = function(events)
    M.helper.bind_events(events)
  end

  return M

end

-- #
-- 
-- 
-- ⌨⛀⛁⛂⛃⛖⛗⚱⚲⚳⚴⚵⚶⚷⚸⚠⚟⚞⚛⚜⚝♳♴♵♶♷♸♹♺♻☣☤☭☯☠☡☢☐☑☒☓☄
