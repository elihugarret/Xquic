sch = Rx.CooperativeScheduler.create()
local _
local tb = {
  0, _, 0, 2,   0, 0, 2, 0,   0, 0, 0, 0,   0, 0, 0, 0,
  0, 0, 0, 0,   0, 0, _, 0,   0, 0, 0, 0,   0, 0, 0, 0,
  0, 0, 0, 2,   0, _, 0, 0,   0, 0, 0, 0,   0, 0, 0, 0,
  0, 0, 0, 0,   0, 0, 0, 0,   0, 0, 0, 0,   0, 0, 0, 0,
}

sch:schedule(x.seq(tb, 2, 60), timer_resolution)
sch:schedule(x.seq(tb, 0, 60), timer_resolution)

while sch.currentTime <= 64/16 do
  sch:update(timer_resolution)
  x.sleep(1/8)
end

--os.exit()
