local wezterm = require("wezterm")
require("lib.styles")

local default_shell = "/bin/bash" -- "/bin/zsh" "/bin/ash" "/bin/dash" "/bin/fish" "/bin/sh"

local state_template = [[
  {{define "state"}} {{- /* a sub template that formats the state to a 1 or 0 dashes wipe whitespace */ -}}
    {{- if (eq . "running") -}}
      1
    {{- else if (eq . "created") -}}
      -1
    {{- else -}}
      0
    {{- end -}}
  {{- end -}}
]]

--- Run a command using wezterm.run_child_process
--- that fetches docker containers. Ensure your user
--- has permissions to interact with docker
--- `sudo usermod -a -G docker youusername`
---@param all boolean include all containers that exist incl. stopped/exited
---@return table of containers
function docker_list(all)
  -- not sure how to handle stopped containers yet...
  -- all = all and true or false -- if including all set the param flag

  local cmd = {
    "/usr/bin/docker", -- path to docker util
    "container", -- we run container subcommand
    "ls", -- list containers
  }
  if all then
    table.insert(cmd, "-a")
  end
  table.insert(cmd, "--format") -- we are gonna specify a format so we can parse easie
  table.insert(cmd, [[
  {   
    {{- /* here we define the format in a go template */ -}}
    {{.ID | printf "%q"}}, {{.Names|printf "%q"}}, {{.Command | printf "%q"}}, {{.Status| printf "%q"}}, {{template "state" .State}}, {{- /* end tpl */ -}} 
  },
  ]] .. state_template)
  -- Use wezterm.run_child_process to run
  local exit, out, err = wezterm.run_child_process(cmd)
  assert(exit, string.format("Did not run docker container command successfully: %q", err))
  local containers = assert(load(string.format("return {%s}", out)), "Invalid lua syntax returned from command")

  -- the output is a table of tables
  -- each table in the root table is a container
  -- the structure is {id,name,command,status,running}
  return containers()
end

function docker_state(id)
  -- not sure how to handle stopped containers yet...
  -- all = all and true or false -- if including all set the param flag

  local cmd = {
    "/usr/bin/docker", -- path to docker util
    "container", -- we run container subcommand
    "ls", -- list containers
    "--filter",
    "id=" .. id,
  }
  table.insert(cmd, "--format") -- we are gonna specify a format so we can parse easie
  table.insert(cmd, [[
    {{- /* here we define the format in a go template */ -}}
      {{template "state" .State}}
    {{- /* end tpl */ -}} 
  ]] .. state_template)
  -- Use wezterm.run_child_process to run
  local exit, out, err = wezterm.run_child_process(cmd)
  assert(exit, string.format("Did not run docker container command successfully: %q", err))
  local status = out

  -- the output is a table of tables
  -- each table in the root table is a container
  -- the structure is {id,name,command,status,running}
  return status
end

function make_docker_fixup_func(id)
  return function(cmd)
    cmd.args = cmd.args or { default_shell }
    local wrapped = {
      "docker",
      "exec",
      "-it",
      id,
    }
    for _, arg in ipairs(cmd.args) do
      table.insert(wrapped, arg)
    end

    cmd.args = wrapped
    return cmd
  end
end

function get_state_icon(st)
  if st > 0 then
    TAG = ROUNDCAP(STYLE({ BG("#2f3239"), FG("#7baf00") }), STYLE({ FG("#2f3239"), BG("#7baf00") }))
    return TAG(" 省 RUNNING ")
  end
  if st < 0 then
    TAG = ROUNDCAP(STYLE({ BG("#2f3239"), FG("#fdb292") }), STYLE({ BG("#2f3239"), BG("#fdb292") }))
    return TAG(" C CREATED ")
  end
  TAG = ROUNDCAP(STYLE({ BG("#2f3239"), FG("#eb746b") }), STYLE({ BG("#2f3239"), BG("#eb746b") }))
  return TAG("    EXITED ")
end

-- ︰︱︲︳︴︵︶︷︸︹︺︻︼︽︾︿﹀﹁﹂﹃﹄﹅﹆﹇﹈﹉﹊﹋﹌﹍﹎﹏🯁🯂🯃       🮲🮳🬫🬛     🬸🬴      🬜🬪     🮹🮺      🬕🬷       🬲🬨     🬛🬤   🬥🬶    🬺🬬    🬻🬝     🬝🬻  🬴🬸  🬱🬊     🬍🬖    🬍🬚    🬱🬵     🬚🬩    🬕🬘🬡    🬡🬲🬵🬮🬰
function make_label(container, state)
  local id, name, entrypoint, status, _ = table.unpack(container)

  local appender, printer = NEW_FORMATTER(true)

  local IDTXT = WRAP_STYLE("<", ">")
  local NAMETXT = WRAP_STYLE(ROUND_THIN_LEFT, ROUND_THIN_RIGHT, STYLE({ FG("#7baf00") }))
  local CMDTXT = STYLE({ BG("#4e5157"), FG("#eb746b") })
  local SPACETXT = STYLE({})
  local TESTTXT = STYLE({})
  local STATUSTXT = STYLE({ FG("#b97490") })
  local state_ico = get_state_icon(tonumber(state))

  appender(state_ico)
  appender(IDTXT(id, STYLE({ FG("#027bad"), BL(true) })))
  appender(NAMETXT(" " .. name .. " ", STYLE({ FG("#7baf00") })))
  appender(wezterm.format(TESTTXT("SHITS")))
  appender(wezterm.format(CMDTXT(entrypoint)))
  appender(wezterm.format(STATUSTXT(status)))

  return printer(" ")
end

function make_docker_label_func(id, container)
  local id, name, entrypoint, status, state = table.unpack(container)
  return function(ed_id)
    local current_status = docker_state(id)

    -- local label = string.format("Docker Container: (%s) %s `%s` [%s]", id, name, entrypoint, status)
    -- TODO: query the container state and show info about
    -- whether it is running or stopped.
    -- If it stopped, you may wish to change the color to red
    -- to make it stand out
    return make_label(container, current_status)
  end
end

function make_docker_exec_domain(container)
  local id, name, entrypoint, status, state = table.unpack(container)
  local ed_id = string.format("docker-%s", id)
  return ed_id, make_docker_fixup_func(id), make_docker_label_func(id, container)
end

local exec_domains = {}
local docker_containers = assert(docker_list(false), "Failed fetching docker containers.")
for _, container in ipairs(docker_containers) do
  local ed_id, fixup_func, label_func = make_docker_exec_domain(container)
  table.insert(exec_domains, wezterm.exec_domain(ed_id, fixup_func, label_func))
end

return {
  exec_domains = exec_domains,
}
