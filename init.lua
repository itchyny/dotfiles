-- Watch Hammerspoon configuration and reload it automatically
configreloader = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/init.lua", function()
  hs.timer.delayed.new(0.1, hs.reload):start()
end):start()

local function remap(mods, key, fn)
  return hs.hotkey.bind(mods, key, fn, nil, fn)
end

local function eisu()
  hs.eventtap.keyStroke({}, 'eisu', 0)
end

local function kana()
  hs.eventtap.keyStroke({}, 'kana', 0)
end

remap({'ctrl'}, '[', function()
  eisu()
  hs.eventtap.keyStroke({}, 'escape', 0)
end)
esc = hs.hotkey.bind({}, 'escape', function()
  esc:disable()
  eisu()
  hs.eventtap.event.newKeyEvent({}, 'escape', true):post()
  hs.timer.delayed.new(0.1, function() esc:enable() end):start()
end, nil, nil)
ctrls = hs.hotkey.bind({'ctrl'}, 's', function()
  ctrls:disable()
  eisu()
  hs.eventtap.event.newKeyEvent({'ctrl'}, 's', true):post()
  hs.timer.delayed.new(0.1, function() ctrls:enable() end):start()
end, nil, nil)

mapFnCtrlTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(e)
  local key = hs.keycodes.map[e:getKeyCode()]
  local hasFnFlag = e:getFlags().fn
  if (hasFnFlag and ((string.len(key) == 1 and 'a' <= key and key <= 'z') or key == 'space' or key == 'tab' or key == '[' or key == ']')) then
    local modifiers = {'ctrl'}
    if e:getFlags().shift then
      table.insert(modifiers, 'shift')
    end
    hs.eventtap.keyStroke(modifiers, key, 0)
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
    eisu()
  elseif lastModifier == 'rightcmd' then
    kana()
  end
  lastModifier = nil
end)

function flagEquals(flags, modifiers)
  local set = {}
  for _, k in ipairs(modifiers) do set[k] = true end
  for _, k in ipairs({'fn', 'cmd', 'ctrl', 'alt', 'shift'}) do
    if set[k] ~= flags[k] then return false end
  end
  return true
end
backslashModifier = hs.eventtap.new({hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp}, function(e)
  local key = hs.keycodes.map[e:getKeyCode()]
  if key == 'yen' then
    if flagEquals(e:getFlags(), {'alt'}) then
      e:setFlags({})
    elseif flagEquals(e:getFlags(), {}) then
      e:setFlags({alt=true})
    end
  elseif key == 'underscore' then
    if flagEquals(e:getFlags(), {}) then
      e:setKeyCode(hs.keycodes.map['yen'])
      e:setFlags({alt=true})
    end
  end
end)
backslashModifier:start()

hs.alert.show("Config loaded")
