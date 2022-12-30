-- Watch Hammerspoon configuration and reload it automatically
reloadConfiguration = hs.pathwatcher.new(os.getenv('HOME') .. '/.config/hammerspoon/init.lua', function()
  hs.timer.doAfter(0.1, hs.reload)
end):start()

-- Swap colon and semicolon
swapColonAndSemicolon = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(e)
  if hs.keycodes.map[e:getKeyCode()] == ';' then
    remappingColonAndSemicolon = not remappingColonAndSemicolon
    if remappingColonAndSemicolon then
      hs.eventtap.event.newKeyEvent(hs.keycodes.map.shift, not e:getFlags().shift):post()
      hs.eventtap.event.newKeyEvent(';', true):post()
      return true
    end
  end
end):start()

-- Switch to the eisu mode on the escape key
switchToEisuOnEscape = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(e)
  if hs.keycodes.map[e:getKeyCode()] == 'escape' then
    hs.eventtap.keyStroke({}, 'eisu', 0)
  end
end):start()

-- Remap C-[ to the escape key
hs.hotkey.bind({'ctrl'}, '[', function(e)
  hs.eventtap.keyStroke({}, 'escape', 0)
end, nil, nil)

-- Switch input modes on [cmd|rightcmd]-space
saveCmdAndRightcmd = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(e)
  if hs.keycodes.map[e:getKeyCode()] == 'cmd' then
    cmd = not cmd
  elseif hs.keycodes.map[e:getKeyCode()] == 'rightcmd' then
    rightcmd = not rightcmd
  end
end):start()
hs.hotkey.bind({'cmd'}, 'space', function()
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
hs.hotkey.bind(mods_win, 'h', function() hs.grid.resizeWindowThinner().pushWindowLeft() end)
hs.hotkey.bind(mods_win, 'l', function() hs.grid.resizeWindowThinner().pushWindowRight() end)
hs.hotkey.bind(mods_win, 'k', function() hs.grid.resizeWindowShorter().pushWindowUp() end)
hs.hotkey.bind(mods_win, 'j', function() hs.grid.resizeWindowShorter().pushWindowDown() end)
hs.hotkey.bind(mods_win, 'f', function() hs.window.focusedWindow():toggleFullScreen() end)
hs.hotkey.bind(mods_win, 'return', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local sf = win:screen():frame()
  local size = win:size()
  size.w = sf.w - math.max(sf.w - 2048, 0) / 2
  size.h = sf.h - math.max(sf.h - 1260, 0) / 2
  f.x = sf.x + (sf.w - size.w) / 1.3
  f.y = sf.y + (sf.h - size.h) / 2
  win:setTopLeft(f)
  win:setSize(size)
end)
hs.hotkey.bind(mods_win, '=', function() resize(100, 100) end)
hs.hotkey.bind(mods_win, '-', function() resize(-100, -100) end)
function resize(x, y)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local sf = win:screen():frame()
  if f.x > sf.x then
    f.x = math.max(f.x - x, sf.x)
  end
  if f.y > sf.y then
    f.y = math.max(f.y - y, sf.y)
  end
  win:setTopLeft(f)
  local size = win:size()
  size.w = size.w + x
  size.h = size.h + y
  win:setSize(size)
end

-- Launch or focus on applications
local mods_app = {'cmd', 'shift'}
hs.hotkey.bind(mods_app, 'f', function() hs.application.launchOrFocus('Finder') end)
hs.hotkey.bind(mods_app, 'c', function() hs.application.launchOrFocus('Google Chrome') end)
hs.hotkey.bind(mods_app, 'a', function() hs.application.launchOrFocus('Safari') end)
hs.hotkey.bind(mods_app, 'd', function() hs.application.launchOrFocus('iTerm') end)
hs.hotkey.bind(mods_app, 'j', function() hs.application.launchOrFocus('IntelliJ IDEA') end)
hs.hotkey.bind(mods_app, 's', function() hs.application.launchOrFocus('Slack') end)
hs.hotkey.bind(mods_app, 'z', function() hs.application.launchOrFocus('zoom.us') end)

hs.alert.show('Config loaded')
