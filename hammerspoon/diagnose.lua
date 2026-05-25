-- Keyboard diagnostic: logs every keyDown + flagsChanged event with full detail.
-- Load from Hammerspoon console:    dofile(os.getenv("HOME") .. "/.dotfiles/hammerspoon/diagnose.lua")
-- Stop later with:                   diagnoseStop()
-- Press the same binding on Mac keyboard and Glove80, then compare the output.

if _G.diagnoseTap then _G.diagnoseTap:stop() end

local types = hs.eventtap.event.types
local props = hs.eventtap.event.properties

local function fmtFlags(f)
  local parts = {}
  for k, v in pairs(f) do if v then parts[#parts+1] = k end end
  table.sort(parts)
  return "{" .. table.concat(parts, ",") .. "}"
end

_G.diagnoseTap = hs.eventtap.new(
  { types.keyDown, types.flagsChanged },
  function(e)
    local etype = e:getType()
    local keyCode = e:getKeyCode()
    local chars   = e:getCharacters(true) or ""
    local flags   = e:getFlags()
    local rawFlags = e:getRawEventData().CGEventData.flags
    local kbType   = e:getProperty(props.keyboardEventKeyboardType)
    local src      = e:getProperty(props.eventSourceUnixProcessID)
    local typeName = (etype == types.keyDown) and "keyDown" or "flagsChanged"

    print(string.format(
      "[diag] %-12s keyCode=%-3d chars=%q flags=%s rawFlags=0x%08x kbType=%s srcPID=%s",
      typeName, keyCode, chars, fmtFlags(flags), rawFlags, tostring(kbType), tostring(src)
    ))
    return false
  end
)
_G.diagnoseTap:start()

function _G.diagnoseStop()
  if _G.diagnoseTap then _G.diagnoseTap:stop(); _G.diagnoseTap = nil end
  print("[diag] stopped")
end

print("[diag] started — press your binding on both keyboards, then call diagnoseStop()")
