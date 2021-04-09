remap = hs.hotkey.bind

-- Watch Hammerspoon configuration and reload it automatically
configreloader = hs.pathwatcher.new(os.getenv('HOME') .. '/.config/hammerspoon/init.lua', function()
  hs.timer.delayed.new(0.1, hs.reload):start()
end):start()

-- Swap : and ;
colon = remap({'shift'}, ';', function()
  colon:disable()
  semicolon:disable()
  hs.eventtap.keyStroke({}, ';', 0)
  hs.timer.delayed.new(0.1, function() colon:enable(); semicolon:enable() end):start()
end, nil, nil)
semicolon = remap({}, ';', function()
  colon:disable()
  semicolon:disable()
  hs.eventtap.keyStroke({'shift'}, ';', 0)
  hs.timer.delayed.new(0.1, function() colon:enable(); semicolon:enable() end):start()
end, nil, nil)

-- Switch to eisu mode on escape keys
remap({'ctrl'}, '[', function()
  hs.eventtap.keyStroke({}, 'eisu', 0)
  hs.eventtap.keyStroke({}, 'escape', 0)
end)
esc = remap({}, 'escape', function()
  esc:disable()
  hs.eventtap.keyStroke({}, 'eisu', 0)
  hs.eventtap.event.newKeyEvent({}, 'escape', true):post()
  hs.timer.delayed.new(0.1, function() esc:enable() end):start()
  cmd = false
  rightcmd = false
end, nil, nil)
-- and on saving
ctrls = remap({'ctrl'}, 's', function()
  ctrls:disable()
  hs.eventtap.keyStroke({}, 'eisu', 0)
  hs.eventtap.event.newKeyEvent({'ctrl'}, 's', true):post()
  hs.timer.delayed.new(0.1, function() ctrls:enable() end):start()
end, nil, nil)

-- Change fn key to control key for some keys
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
end):start()

-- Switch input modes on [cmd|rightcmd]-space
local cmd = false
local rightcmd = false
storeLastModifier = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(e)
  local modifier = hs.keycodes.map[e:getKeyCode()]
  if modifier == 'cmd' then
    cmd = not cmd
  elseif modifier == 'rightcmd' then
    rightcmd = not rightcmd
  end
end):start()
remap({'cmd'}, 'space', function()
  if cmd then
    hs.eventtap.keyStroke({}, 'eisu', 0)
  elseif rightcmd then
    hs.eventtap.keyStroke({}, 'kana', 0)
  end
end)

-- Initialize grid
hs.grid.GRIDWIDTH = 2
hs.grid.GRIDHEIGHT = 2
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0

-- Disable animation
hs.window.animationDuration = 0

-- Resize and move windows
local mods_win = {'cmd', 'ctrl'}
remap(mods_win, 'h', function() hs.grid.resizeWindowThinner().pushWindowLeft() end)
remap(mods_win, 'l', function() hs.grid.resizeWindowThinner().pushWindowRight() end)
remap(mods_win, 'k', function() hs.grid.resizeWindowShorter().pushWindowUp() end)
remap(mods_win, 'j', function() hs.grid.resizeWindowShorter().pushWindowDown() end)
remap(mods_win, 'f', function() hs.window.focusedWindow():toggleFullScreen() end)
remap(mods_win, 'return', hs.grid.maximizeWindow)

-- Launch or focus on applications
local mods_app = {'cmd', 'shift'}
remap(mods_app, 'f', function () hs.application.launchOrFocus('Finder') end)
remap(mods_app, 'c', function () hs.application.launchOrFocus('Google Chrome') end)
remap(mods_app, 'a', function () hs.application.launchOrFocus('Safari') end)
remap(mods_app, 'd', function () hs.application.launchOrFocus('iTerm') end)
remap(mods_app, 's', function () hs.application.launchOrFocus('Slack') end)

hs.alert.show('Config loaded')
