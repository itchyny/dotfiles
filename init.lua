hs.pathwatcher.new(os.getenv("HOME") .. "/.files/init.lua", hs.reload):start()

local function alert(str)
  hs.alert.show(str)
end

local function remap(mods, key, fn)
  return hs.hotkey.bind(mods, key, fn, nil, fn)
end

local function jp()
  hs.eventtap.keyStroke({}, 'kana', 0)
end

local function eng()
  hs.eventtap.keyStroke({}, 'eisu', 0)
end

remap({'ctrl'}, '[', function() eng() hs.eventtap.keyStroke({}, 'escape', 0) end)
esc = hs.hotkey.bind({}, 'escape', function()
  esc:disable()
  eng()
  hs.eventtap.event.newKeyEvent({}, 'escape', true):post()
  hs.timer.delayed.new(0.1, function() esc:enable() end):start()
end, nil, nil)

mapFnCtrlTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(e)
  local key = hs.keycodes.map[e:getKeyCode()]
  local hasFnFlag = e:getFlags()['fn']
  if (hasFnFlag and ((string.len(key) == 1 and 'a' <= key and key <= 'z') or key == 'space' or key == '[' or key == ']')) then
    hs.eventtap.keyStroke({'ctrl'}, key, 0)
    return ''
  end
end)
mapFnCtrlTap:start()

local lastModifier
storeLastModifier = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(e)
  lastModifier = hs.keycodes.map[e:getKeyCode()]
end)
storeLastModifier:start()
remap({'cmd'}, 'space', function()
  if lastModifier == 'cmd' then
    eng()
  elseif lastModifier == 'rightcmd' then
    jp()
  end
  lastModifier = nil
end)

hs.alert.show("Config loaded")
