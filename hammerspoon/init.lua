-- Tmux shortcuts: ;1–;9, ;c, ;x, ;r
-- Dead-key approach: ';' is consumed and held. If a trigger follows,
-- the action fires. Otherwise ';' is re-injected via return value
-- (bypasses the tap). No synthetic keystrokes = macOS won't disable the tap.

local tmux = "/opt/homebrew/bin/tmux"
local function tmuxRun(args) hs.task.new(tmux, nil, args):start() end

local triggers = {}
for i = 1, 9 do
  triggers[tostring(i)] = function() tmuxRun({"select-window", "-t", ":" .. i}) end
end
triggers["c"] = function() tmuxRun({"new-window"}) end
triggers["x"] = function() tmuxRun({"kill-window"}) end
triggers["r"] = function()
  tmuxRun({"set-option", "-w", "automatic-rename", "off"})
  tmuxRun({"command-prompt", "-I", "#W", "rename-window '%%'"})
end

local pending = false
local timer = nil
local function semiEvent(down)
  return hs.eventtap.event.newKeyEvent({}, ";", down)
end

local tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
  local flags = event:getFlags()
  if flags.cmd or flags.ctrl or flags.alt then
    if pending then
      pending = false
      if timer then timer:stop(); timer = nil end
      return true, { semiEvent(true), semiEvent(false), event:copy() }
    end
    return false
  end

  local c = event:getCharacters()
  if not c or #c ~= 1 then
    if pending then
      pending = false
      if timer then timer:stop(); timer = nil end
    end
    return false
  end

  if c == ";" and not pending then
    pending = true
    if timer then timer:stop() end
    timer = hs.timer.doAfter(0.3, function()
      if pending then
        pending = false
        tap:stop()
        hs.eventtap.keyStroke({}, ";", 0)
        tap:start()
      end
    end)
    return true
  end

  if pending then
    pending = false
    if timer then timer:stop(); timer = nil end
    if triggers[c] then
      triggers[c]()
      return true
    end
    return true, { semiEvent(true), semiEvent(false), event:copy() }
  end

  return false
end)

tap:start()

-- Safety net: re-enable if macOS disables the tap
local function ensureTap()
  if not tap:isEnabled() then tap:stop(); tap:start() end
end

hs.timer.new(5, ensureTap):start()

hs.application.watcher.new(function(_, e)
  if e == hs.application.watcher.activated then ensureTap() end
end):start()

hs.caffeinate.watcher.new(function(e)
  if e == hs.caffeinate.watcher.systemDidWake
    or e == hs.caffeinate.watcher.screensDidUnlock
    or e == hs.caffeinate.watcher.screensDidWake then
    hs.timer.doAfter(1, ensureTap)
  end
end):start()
