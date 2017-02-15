ix = Rx.CooperativeScheduler.create()
local _prog = prog()

local a = {
 0, 2, 2, _,   {0, 1, 7}, _, 2, 3,   0, 2, 2, 3,   {0, 1, 7}, _, 2, _,
 0, _, 2, _,   {0, 1, 7}, _, 2, _,   0, _, 2, _,   {0, 1, 7}, 2, 2, _,
 0, _, 2, _,   {0, 1, 7}, 2, 2, _,   0, _, 2, _,   {0, 1, 7}, _, 2, _,
 0, _, 2, _,   {0, 1, 7}, _, 2, 3,   0, _, 2, _,   {0, 1, 7}, _, 2, 2,
}

local b = {
 0, 7, 7, _,   {0, 3, 12}, _, 7, 3,   0, 7, 7, 3,   0, _, 7, _,
 0, _, 7, 12,   0, _, 7, _,   0, _, 7, _,   0, 7, 7, _,
 0, _, 7, _,   0, 7, 7, _,   0, _, 7, _,   0, _, 7, _,
 0, _, 7, _,   0, _, 7, 7,   0, _, 7, _,   0, 12, 7, 7,
}

ix:schedule(x.seq(a, 4, 48), timer_resolution)
ix:schedule(x.seq(b, 2, 60 + _prog), timer_resolution)

repeat 
  ix:update(timer_resolution)
  if ix.currentTime > 64/16 then break end
  x.sleep(1/8)
until false

--os.exit()
