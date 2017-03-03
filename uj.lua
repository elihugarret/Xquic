ix = Rx.CooperativeScheduler.create()

local _prog = prog()

local beat = x.new{
  0, 2, 2, 3,  {0, 1}, 2, 2, _,  0, 4, _, 2,  {0, 1}, _, 3, _,  
  0, _, 2, _,  {0, 1}, 2, _, 3,  0, 6, 4, _,  {0, 1}, 3, 2, 6,
  0, 2, _, 2,  {0, 1}, _, 3, 2,  0, _, 2, 4,  {0, 1}, 2, 2, _,
  0, 2, 2, _,  {0, 1}, 3, _, 2,  0, 2, _, _,  {0, 1}, 2, 2, _,
  } --:replace({0}, {2})

local synth = x.new{
  0, 7, _, _,   {0, 3, 12}, _, 7, 3,   0, 7, 7, 3,   0, _, 7, _,
  0, 3, 7, 12,           0, _, _, 2,   _, _, 7, _,   _, 7, 7, _,
  0, 3, _, _,   {0, 2, 12}, 7, 7, _,   0, _, 7, _,   _, _, 7, _,
  0, _, 7, _,            0, _, 7, 7,   0, 2, 7, _,   0, 12, _, 7,
}

local piano = x.new{
  0, _, 0, _,  {0, 3, 7}, _, 2, 0,  5, 0, _, _,   0, 2, _, _,
  0, _, 0, _,  {0, 3, 7}, _, 2, 0,  5, 0, 12, _,   0, 2, 12, _,
  0, _, 0, _,  {0, 5, 7}, _, _, 0,  _, 0, 12, _,   12, _, 12, _,
  {0, 3, 7}, _, _, _,  {0, 5, 7}, _, _, _,  {-2, 3}, _, _, _,  {-2, 3, 12}, _, _, _,
}--:fill()

beat.channel = 4
beat.root = 48
synth.channel = 2
synth.root = 60 + _prog
piano.channel = 0
piano.root = 60 + _prog

ix:schedule(function () beat:play() end, timer_resolution)
ix:schedule(function () synth:play() end, timer_resolution)
ix:schedule(function () piano:play() end, timer_resolution)

repeat
  ix:update(timer_resolution)
  if ix.currentTime > 64/16 then break end
  x.sleep(1/8)
until false

--os.exit()
