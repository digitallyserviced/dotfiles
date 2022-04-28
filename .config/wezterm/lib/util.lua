local M = {}

---Round float to nearest int
---@param x number Float
---@return number
function M.round(x)
  return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

---Clamp value between the min and max values.
---@param value number
---@param min number
---@param max number
function M.clamp(value, min, max)
  if value < min then
    return min
  elseif value > max then
    return max
  end
  return value
end

function M.get_separator()
  return "/"
end

function M.join_paths(...)
  local separator = M.get_separator()
  return table.concat({ ... }, separator)
end

function M.exists(path)
  local f = io.open(path, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

function M.ensure_dir(path)
  os.execute(string.format("mkdir %s %s", M.is_windows and "" or "-p", path))
end

local function vim_cache_home()
  if M.s_windows then
    return M.join_paths(vim.fn.expand("%localappdata%"), "Temp", "nvim")
  end
  local xdg = os.getenv("XDG_CACHE_HOME")
  local root = xdg or vim.fn.expand("$HOME/.cache/nvim")
  return M.join_paths(root, "nvim")
end

return M
