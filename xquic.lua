local X = {}
local ffi = require'ffi'
local midi = require "luamidi"

ffi.cdef"void Sleep(int ms);"

function X.sleep(s)
  ffi.C.Sleep(s*1000)
end

local function on(port, note, vel, channel, root)
  if note then
    if type(note) == "number" then
      note = note + root
      midi.sendMessage(port, 144, note, vel, channel)
    elseif type(note) == "table" then
      for i = 1, #note do
        note[i] = note[i] + root
        midi.sendMessage(port, 144, note[i], vel, channel)
      end
    end
  end
end

local function off(port, note, channel, root)
  if note then
    if type(note) == "number" then
      note = note + root
      midi.sendMessage(port, 128, note, 0, channel)
    elseif  type(note) == "table" then
      for j = 1, #note do
        midi.sendMessage(port, 128, note[j], 0, channel)
      end
    end
  end
end

function X.seq(a, ch, root)
  local i = 1
  local size = #a
  return function ()
    while true do
      on(1, a[i], 70, ch, root)
      coroutine.yield()
      off(1, a[i], ch, root)
      i = i + 1
      if i > size then break end
    end
  end
end

function X.init(file)
  while true do
    local luna = xpcall(
    function () return require(file) end,
    function ()
      print "something is wrong"
      X.sleep(1)
    end)
    package.loaded[file] = nil
  end
end

return X
