local X = {}
local ffi = require'ffi'
local midi = require "luamidi"

ffi.cdef"void Sleep(int ms);"

function X.sleep(s)
  ffi.C.Sleep(s*1000)
end

local function on(port, note, vel, channel)
  if type(note) ~= "number" then
    midi.sendMessage(port, 144, note, vel, channel)
  end
end

local function off(port, note, channel)
  if type(note) ~= "number" then
    midi.sendMessage(port, 128, note, 0, channel)
  end
end

function X.seq(a, ch, root)
  local i = 1
  local size
  return function ()
    local note = a[i] + root
    while true do
      on(1, a[i], 70, ch)
      coroutine.yield(1 / #a)
      off(1, a[i], ch)
      i = i + 1
      if i > #a then break end
    end
  end
end

function X.init(file)
  while true do
    local luna = xpcall(
    function () return require(file) end,
    function ()
      print "YOU SCREWED IT!!"
      X.sleep(1)
    end)
    package.loaded[file] = nil
  end
end

return X
