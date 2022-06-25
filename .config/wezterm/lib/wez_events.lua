return function ()
  local E = {}
  local count = 1

  local handlers = {
    "window-config-reloaded",
    "update-right-status",
    "open-uri",
    "format-tab-title",
    "format-window-title"
  }

  local event_handlers = {}

  for _, event in ipairs(handlers) do
    event_handlers[event] = {}
  end

  E.idx = function ()
    count = count+1
    return count
  end

  E.on = function (event, fn, desc)
    local id = E.idx()
    desc = desc or string.format("%s-%s", event, id)
    assert(event_handlers[event], "Unknown event " .. event)
    -- wezterm.log_info(string.format("%s binding %s",event, desc))
    local handler = {}
    handler.desc = desc
    handler.fn = function (...)
      return fn(table.unpack({...}))
    end
    table.insert(event_handlers[event], handler)
  end

  for _, event in ipairs(handlers) do
    wezterm.on(event, function (...)
      -- wezterm.log_info(string.format("%s called", event))
      for _, handler in ipairs(event_handlers[event]) do
        -- wezterm.log_info(string.format("calling %s", handler.desc))
        local ok = handler.fn(table.unpack({...}))
        if not ok then
          local t = _G.debug and wezterm.log_error(string.format("Event %s handler %s failed with : %s", event, handler.desc, msg))
        else
          local t = _G.debug and wezterm.log_info(string.format("Event %s handler %s sucess: %s", event, handler.desc, msg))
        end
        return ok
      end
      return nil
    end)
  end

  return E
end
