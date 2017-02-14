sch = Rx.CooperativeScheduler.create()

local tb = {
 60, 60, 0, 72, 60, 60, 60, 60,
 60, 60, 60, 60, 60, 60, 60, 60,
 60, 60, 60, 60, 60, 60, 60, 60,
 60, 60, 70, 60, 60, 60, 60, 60,
 60, 60, 0, 72, 60, 60, 60, 60,
 60, 60, 60, 60, 60, 60, 60, 60,
 60, 60, 60, 60, 60, 60, 60, 60,
 60, 60, 70, 60, 60, 60, 60, 60,
}

sch:schedule(x.seq(tb, 2), timer_resolution)
sch:schedule(x.seq(tb, 0), timer_resolution)

while sch.currentTime <= 32/16 do
  sch:update(timer_resolution)
  x.sleep(1/8)
end

--os.exit()
