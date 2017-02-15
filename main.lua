Rx = require'rx'
x = require"xquic"
_ = false
timer_resolution = 1/16

prog = coroutine.wrap(function () 
  local p = {0, -5}
  while true do
    for i = 1, #p do
      coroutine.yield(p[i])
    end
  end
end)

x.init"uj"
