_G["wezterm"] = require("wezterm")
_G["helper"] = require("lib.wez_helper")
require('lib.styles')
-- require('lib.wez_events')
local tablelib = require "tablelib"
local M = {}
M.wezterm=_G["wezterm"]

_G['debug']=false
function Config()
  M.base_options = nil
  M.config = function()
    local key_cfg = require("wez_key_new")(M)

    local options_static = require("lib.wez_static_opt")
    local options_dynamic = require('lib.wez_dynamic_opt')
    local colors = require("colors")
    helper.set_palette("terafox")
    options_static.color_scheme_dirs = {
      paths.path_join(wezterm.config_dir, "color_schemes")
    }

    M.base_options = helper.merge(options_static, options_dynamic(M))
    M.base_options.colors = colors.colors
    M.base_options.color_schemes = colors.color_schemes
    M.base_options.leader = key_cfg.leader
    M.base_options.keys = key_cfg.keys

    return M.base_options
  end

  M.reload_paths = function (paths)
    paths = paths or {}
    paths.setup_reload_paths(paths)
  end

  M.override = function(overrides)
    M.base_options = M.base_options or M.config()
    overrides = overrides or {}
    return tablelib.merge_all(M.base_options, overrides)
  end

  M.bind_events = function(events)
    helper.bind_events(events)
  end

  return M

end
return Config()
-- #
-- 
-- 
-- ⌨⛀⛁⛂⛃⛖⛗⚱⚲⚳⚴⚵⚶⚷⚸⚠⚟⚞⚛⚜⚝♳♴♵♶♷♸♹♺♻☣☤☭☯☠☡☢☐☑☒☓☄
