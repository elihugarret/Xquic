ix = Rx.CooperativeScheduler.create()
local _prog = prog()

local b = x.new{
  0, 7, 7, _,   {0, 3, 12}, _, 7, 3,   0, 7, 7, 3,   0, _, 7, _,
  0, _, 7, 12,           0, _, 7, _,   0, _, 7, _,   0, 7, 7, _,
  0, _, 7, _,            0, 7, 7, _,   0, _, 7, _,   0, _, 7, _,
  0, _, 7, _,            0, _, 7, 7,   0, _, 7, _,   0, 12, 7, 7,
}
b.channel = 2
b.root = 60 + _prog

ix:schedule(function () b:play() end, timer_resolution)

repeat
  ix:update(timer_resolution)
  if ix.currentTime > 64/16 then break end
  x.sleep(1/8)
until false

--os.exit()
