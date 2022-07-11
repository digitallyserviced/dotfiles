local wezterm = require 'wezterm'
local json = require("lib.json")
local docker_exec_domain_shell = {"zsh"} -- {"bash"}
local docker_run_domains = {"<id of containers we can start if stopped>"}
local include_stopped_containers = 1 -- or a 0
function docker_exec_domain(dd, win, pane)
  local state = dd["Running"] and "" or "省"
  local name = string.format("Docker: < %s  > (%s) %s%s [%s]", state, dd["Id"], dd["Image"], dd["Name"], dd["Platform"])
  -- local name = string.format("Docker: (%s) %s%s [%s]", dd["Id"], dd["Image"], dd["Name"], dd["Platform"])
  local action = dd["Running"] and "exec" or "run"
  return wezterm.exec_domain(name, function (cmd)
      local env = cmd.set_environment_variables

      local wrapped = {
        '/usr/bin/docker',
        "action",
        '-it',
        dd["Id"]
      }

      for _, sh_arg in pairs(docker_exec_domain_shell) do
        table.insert(wrapped, sh_arg)
      end
      cmd.args = wrapped
      return cmd
  end)
end
function get_docker_domains (win, pane)
  require('os')
  local cmd = table.concat({wezterm.config_dir,"docker_domains.zsh"}, "/")
  local exit, out, err = wezterm.run_child_process({cmd, include_stopped_containers})
  assert(exit, string.format("Script did not execute successfully, %s", err))
  local dat, len = assert(json.parse(out), "Error parsing json output from script")
  local current_domains = {}
  local ex_domains = {}
  for _,value in ipairs(dat) do
    print(value)
    table.insert(ex_domains, docker_exec_domain(value, win, pane))
  end
  if win ~= nil then
    win:set_config_overrides({exec_domains = ex_domains})
  end
  return ex_domains
end

local exec_domains = get_docker_domains(nil, nil)
print(string.dump(function ()
  return exec_domains
end))
