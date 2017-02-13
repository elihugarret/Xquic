Rx = require 'rx'

local ffi = require'ffi'

timer_resolution = 1/16

ffi.cdef[[
void Sleep(int ms);
int poll(struct pollfd *fds, unsigned long nfds, int timeout);
]]


function sleep(s)
  ffi.C.poll(nil, 0, s*1000)
end

local function log(message)
  print('[' .. string.format('%.2f', scheduler.currentTime) .. '] ' .. message)
end


function seq(a)
  local i = 1
  local size
  return function ()
    while true do
      log(a[i])
      coroutine.yield(1 / #a)
      log(a[i] .. '_off')
      i = i + 1
      if i > #a then break end
    end
  end
end

function init(file)
  while true do
    local luna = xpcall(
    function () return require(file) end,
    function ()
      print "YOU SCREWED IT!!"
      sleep(1)
    end)
    package.loaded[file] = nil
  end
end

init"reactive"
