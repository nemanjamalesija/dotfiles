-- Enable the `hs` CLI for terminal introspection. Pure observability.
require("hs.ipc")

-- Module-scope refs kept alive for the life of the Hammerspoon Lua state
-- (otherwise Lua GC collects them and watchers/timers stop firing silently).
local themeWatcher

--[[ Disabled for now — kept in case I want the ';' dead-key back later.
-- Tmux shortcuts: ;1–;9, ;c, ;x, ;r
-- Dead-key approach: ';' is consumed and held. If a trigger follows,
-- the action fires. Otherwise ';' is re-injected via return value
-- (bypasses the tap). No synthetic keystrokes = macOS won't disable the tap.

local sleepWatcher

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

-- Sleep-recovery: if macOS disables the tap during sleep and the disabled
-- event isn't delivered before we wake, this catches it. Also clears any
-- stuck `pending` flag — that's a silent failure isEnabled() wouldn't show.
local function ensureTap()
  if not tap:isEnabled() then
    print(string.format("[%s] ensureTap: tap was disabled, cycling", os.date()))
    pending = false
    if timer then timer:stop(); timer = nil end
    tap:stop()
    tap:start()
  end
end

sleepWatcher = hs.caffeinate.watcher.new(function(e)
  if e == hs.caffeinate.watcher.systemDidWake
    or e == hs.caffeinate.watcher.screensDidUnlock
    or e == hs.caffeinate.watcher.screensDidWake then
    hs.timer.doAfter(1, ensureTap)
  end
end)
sleepWatcher:start()
]]

-- Theme-change side-effect: when `tt` writes ~/.theme-mode, re-issue
-- borders options to the running daemon (live update over its socket —
-- no restart, no blink). Ghostty reload is handled by `tt` itself.
local home = os.getenv("HOME")

local function reloadBorders()
  hs.task.new("/bin/bash", nil, {home .. "/.config/borders/bordersrc"}):start()
end

themeWatcher = hs.pathwatcher.new(home .. "/.theme-mode", reloadBorders)
themeWatcher:start()

-- App switcher: Alt+Cmd+<n> launches or focuses the bound app, then defers
-- to macOS' native "Hide Others" (Cmd+Alt+H) to clear everything else.
-- Avoids Ctrl-based modifiers entirely so it can never collide with tmux's
-- `Ctrl+B → N` workflow. hs.hotkey is a native CGEventHotKey — only the
-- specific combos are intercepted, so this is far lighter than the tmux
-- dead-key tap.
local apps = {
  ["1"] = "com.mitchellh.ghostty",
  ["2"] = "com.google.Chrome",
  ["3"] = "com.microsoft.teams2",
  ["4"] = "com.sublimemerge",
}

local appHotkeys = {}
for key, bundleID in pairs(apps) do
  local function activate()
    hs.application.launchOrFocusByBundleID(bundleID)
    hs.eventtap.keyStroke({"cmd", "alt"}, "h", 0)
  end
  -- Bind both the top-row digit and the keypad digit: some external keyboards
  -- (e.g. Glove80 with ZMK) emit KP_N* keycodes for the number row.
  appHotkeys[#appHotkeys + 1] = hs.hotkey.bind({"alt", "cmd"}, key, activate)
  appHotkeys[#appHotkeys + 1] = hs.hotkey.bind({"alt", "cmd"}, "pad" .. key, activate)
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

-- Croatian diacritics on Alt+Cmd+<key>, uppercase on Shift+Alt+Cmd+<key>.
-- Lua's string.upper is byte-based and won't uppercase multi-byte UTF-8,
-- so the uppercase forms are spelled out explicitly.
local croatian = {
  y = { "č", "Č" },
  u = { "ć", "Ć" },
  i = { "ž", "Ž" },
  o = { "š", "Š" },
  p = { "đ", "Đ" },
}

local croatianHotkeys = {}
for key, pair in pairs(croatian) do
  local lower, upper = pair[1], pair[2]
  croatianHotkeys[#croatianHotkeys + 1] = hs.hotkey.bind({"alt", "cmd"}, key, function()
    hs.eventtap.keyStrokes(lower)
  end)
  croatianHotkeys[#croatianHotkeys + 1] = hs.hotkey.bind({"shift", "alt", "cmd"}, key, function()
    hs.eventtap.keyStrokes(upper)
  end)
end
