scheduler = Rx.CooperativeScheduler.create()

local tb = {
  1, 2, 3, 4, 1, 2, 3, 4,
  1, 2, 3, 4, 1, 2, 3, 4,
  1, 2, 3, 4, 1, 2, 3, 4,
  1, 2, 3, 4, 1, 2, 3, 4,
}

scheduler:schedule(seq(tb), timer_resolution)

while scheduler.currentTime <= (32/16) do
  scheduler:update(timer_resolution)
  sleep(1/16)
end
