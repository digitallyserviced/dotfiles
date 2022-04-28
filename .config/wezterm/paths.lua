return function (helper)
  local M = {}
  assert(helper, "Must pass helper object instance to paths")

  M.reload_paths = {}
  M.reloadables = {
    "helper.lua",
    "wez_keys.lua",
    "wezterm_conf.lua",
    "wezterm_bar.lua",
    "paths.lua",
    "lib/*.lua",
    "color_schemes/*.toml",
    "palette/*.lua"
  }

  M.path_join = function(...)
    local sep = helper.is_windows and [[\]] or "/"
    return table.concat({ ... }, sep)
  end

   M.basename = function(s)
    return string.gsub(s, "(.*[/\\])(.*)", "%2")
  end

   M.relative_path = function (p)
    return assert(helper.is_posix_path(), "Fuck windows") and not (string.sub(p, 1, 1) == "/")
   end

  M.get_paths = function (paths)
    local reload_paths = {}
    for _, path in ipairs(paths) do
      path = M.relative_path(path) and M.path_join(helper.wezterm.config_dir, path)
      local globs = helper.wezterm.glob(path)
      while #globs > 0 do
        local p = table.remove(globs, 1)
        table.insert(reload_paths, p)
      end
    end

    return reload_paths
  end

  M.add_reload_paths = function (reload_paths)
    while #reload_paths > 0 do
      local path = table.remove(reload_paths, 1)
      helper.wezterm.add_to_config_reload_watch_list(path)
    end
  end

  M.setup_reload_paths = function(more_paths)
    M.reloadables = helper.merge(M.reloadables, more_paths)
    M.paths = M.get_paths(M.reloadables) or {}
    M.add_reload_paths(M.paths)
  end

  return M

end
