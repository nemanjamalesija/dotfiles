-- Tmux shortcuts: ;1–;9, ;c, ;x, ;r
-- Dead-key approach: ';' is consumed and held. If a trigger follows,
-- the action fires. Otherwise ';' is re-injected via return value
-- (bypasses the tap). No synthetic keystrokes = macOS won't disable the tap.

-- Enable the `hs` CLI so we can query Hammerspoon state from a terminal
-- (e.g. `hs -c "return tap:isEnabled()"`). Pure introspection, no behavior change.
require("hs.ipc")

-- Module-scope refs kept alive for the life of the Hammerspoon Lua state.
local recheckTimer, appWatcher, sleepWatcher

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
  -- macOS may disable the tap under load or after secure-input apps misbehave.
  -- Re-enable immediately when it sends the disabled event; isEnabled() polling
  -- can lag and leave the tap dead until next reload.
  local etype = event:getType()
  if etype == hs.eventtap.event.types.tapDisabledByTimeout
    or etype == hs.eventtap.event.types.tapDisabledByUserInput then
    print(string.format("[%s] eventtap disabled (type=%d) — re-enabling", os.date(), etype))
    pending = false
    if timer then timer:stop(); timer = nil end
    tap:start()
    return false
  end

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

-- Safety net: re-enable if macOS disables the tap. Also reset any stale
-- `pending` state, in case a stuck flag (not just a dead tap) is what
-- broke things — that scenario is silent and isEnabled() wouldn't catch it.
local function ensureTap()
  if not tap:isEnabled() then
    print(string.format("[%s] ensureTap: tap was disabled, cycling", os.date()))
    pending = false
    if timer then timer:stop(); timer = nil end
    tap:stop()
    tap:start()
  end
end

-- Retain refs at module scope. hs.timer / hs.*.watcher userdata that goes
-- out of scope can be garbage-collected, killing the safety net silently.
recheckTimer = hs.timer.new(5, ensureTap)
recheckTimer:start()

appWatcher = hs.application.watcher.new(function(_, e)
  if e == hs.application.watcher.activated then ensureTap() end
end)
appWatcher:start()

sleepWatcher = hs.caffeinate.watcher.new(function(e)
  if e == hs.caffeinate.watcher.systemDidWake
    or e == hs.caffeinate.watcher.screensDidUnlock
    or e == hs.caffeinate.watcher.screensDidWake then
    hs.timer.doAfter(1, ensureTap)
  end
end)
sleepWatcher:start()

-- Theme reload: when ~/.theme-mode changes (via `tt`/`theme`),
-- reload Ghostty config without racing whatever app is focused,
-- and restart borders so it re-reads the new accent color.
local home = os.getenv("HOME")

local function reloadGhostty()
  local app = hs.application.find("com.mitchellh.ghostty")
  if not app then return end
  app:activate()
  hs.timer.doAfter(0.05, function()
    hs.eventtap.keyStroke({"cmd", "shift"}, ",", 0)
  end)
end

-- JankyBorders supports live config updates: re-invoking `borders` with
-- new options sends them to the running daemon over its socket — no
-- restart, no Accessibility re-grant, no visible blink. bordersrc just
-- reads ~/.theme-mode and re-issues the options.
local function reloadBorders()
  hs.task.new("/bin/bash", nil, {home .. "/.config/borders/bordersrc"}):start()
end

hs.pathwatcher.new(home .. "/.theme-mode", function()
  reloadGhostty()
  reloadBorders()
end):start()

-- App switcher: Cmd+Alt+<n> launches or focuses the bound app.
-- hs.hotkey is a native CGEventHotKey — only the specific combos are
-- intercepted, so this is far lighter than the tmux dead-key tap.
local apps = {
  ["1"] = "com.mitchellh.ghostty",
  ["2"] = "com.google.Chrome",
  ["3"] = "com.microsoft.teams2",
  ["4"] = "com.sublimemerge",
}

local appHotkeys = {}
for key, bundleID in pairs(apps) do
  appHotkeys[#appHotkeys + 1] = hs.hotkey.bind({"alt", "cmd"}, key, function()
    for _, app in ipairs(hs.application.runningApplications()) do
      if app:bundleID() ~= bundleID and #app:visibleWindows() > 0 then
        app:hide()
      end
    end
    hs.application.launchOrFocusByBundleID(bundleID)
  end)
end

-- Dock toggle is handled natively by macOS' Cmd+Opt+D (symbolic hotkey 52,
-- "Turn Dock Hiding On/Off") — smooth animation, no Dock restart needed.
-- Intentionally not bound here to avoid intercepting it.

-- Minimize focused window. Native Cmd+M does the same, this is for
-- muscle-memory consistency with the other Alt+Cmd+<key> bindings above.
local minimizeHotkey = hs.hotkey.bind({"alt", "cmd"}, "m", function()
  local win = hs.window.focusedWindow()
  if win then win:minimize() end
end)
