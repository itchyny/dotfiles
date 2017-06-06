hs.pathwatcher.new(os.getenv("HOME") .. "/.files/init.lua", hs.reload):start()
hs.alert.show("Config loaded")

local function alert(str)
  hs.alert.show(str)
end

local function remap(mods, key, fn)
  return hs.hotkey.bind(mods, key, fn, nil, fn)
end

local function jp()
  hs.eventtap.keyStroke({}, 0x68, 0)
end

local function eng()
  hs.eventtap.keyStroke({}, 0x66, 0)
end

remap({'ctrl'}, '[', function() eng() hs.eventtap.keyStroke({}, 'escape', 0) end)
remap({'ctrl'}, ']', function() eng() hs.eventtap.keyStroke({}, 'escape', 0) end)
remap({'ctrl'}, 'j', function() hs.eventtap.keyStroke({}, 'return', 0) end)

local handler = function(e)
  local key = hs.keycodes.map[e:getKeyCode()]
  local hasFnFlag = e:getFlags()['fn']
  if (hasFnFlag and ((string.len(key) == 1 and 'a' <= key and key <= 'z') or key == 'space' or key == '[' or key == ']')) then
    hs.eventtap.keyStroke({'ctrl'}, key, 0)
    return ''
  end
end

eventtap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, handler)
eventtap:start()
