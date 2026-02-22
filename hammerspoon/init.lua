-- Tmux window switching via keyboard triggers
-- Type ;;1 through ;;9 anywhere to switch to that tmux window

local function switchTmuxWindow(n)
  hs.execute("/opt/homebrew/bin/tmux select-window -t :" .. n, true)
end

local buffer = ""
local BUFFER_SIZE = 5

local keyWatcher = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
  local flags = event:getFlags()
  if flags.cmd or flags.ctrl or flags.alt then
    buffer = ""
    return false
  end

  local char = event:getCharacters()
  if not char or #char ~= 1 then return false end

  buffer = buffer .. char
  if #buffer > BUFFER_SIZE then
    buffer = buffer:sub(-BUFFER_SIZE)
  end

  -- Trigger: ;1 through ;9
  local windowNum = buffer:match(";([1-9])$")
  if windowNum then
    buffer = ""
    local n = tonumber(windowNum)
    hs.timer.doAfter(0.02, function()
      for _ = 1, 2 do -- delete 2 chars: ;N
        hs.eventtap.keyStroke({}, "delete", 0)
      end
      hs.timer.doAfter(0.05, function()
        switchTmuxWindow(n)
      end)
    end)
  end

  -- Trigger: ;c — new tmux window
  if buffer:match(";c$") then
    buffer = ""
    hs.timer.doAfter(0.02, function()
      for _ = 1, 2 do -- delete 2 chars: ;c
        hs.eventtap.keyStroke({}, "delete", 0)
      end
      hs.timer.doAfter(0.05, function()
        hs.execute("/opt/homebrew/bin/tmux new-window", true)
      end)
    end)
  end

  -- Trigger: ;x — close current tmux window
  if buffer:match(";x$") then
    buffer = ""
    hs.timer.doAfter(0.02, function()
      for _ = 1, 2 do -- delete 2 chars: ;x
        hs.eventtap.keyStroke({}, "delete", 0)
      end
      hs.timer.doAfter(0.05, function()
        hs.execute("/opt/homebrew/bin/tmux kill-window", true)
      end)
    end)
  end

  -- Trigger: ;r — rename current tmux window
  if buffer:match(";r$") then
    buffer = ""
    hs.timer.doAfter(0.02, function()
      for _ = 1, 2 do -- delete 2 chars: ;r
        hs.eventtap.keyStroke({}, "delete", 0)
      end
      hs.timer.doAfter(0.05, function()
        hs.execute("/opt/homebrew/bin/tmux set-window-option automatic-rename off", true)
        hs.eventtap.keyStroke({"ctrl"}, "b", 0)
        hs.eventtap.keyStroke({}, ",", 0)
      end)
    end)
  end

  return false
end)

keyWatcher:start()
