dgBossIdleState = {}

function dgBossIdleState.load()
  dgBossIdleState.verticalSpeed=love.graphics.getHeight()
  idleState.sheet = love.graphics.newImage()
  dgBossIdleState.places = {200,400}
  dgBossIdleState.movTime = 0.8
end

function dgBossIdleState.start(boss,time)
  dgBossIdleState.boss = boss
  dgBossIdleState.time=time
  dgBossIdleState.goTo = 1
end

function dgBossIdleState.goNext()
  local lastInd = dgBossIdleState.goTo
  local ind = (lastInd+1)%(#dgBossIdleState.places)+1
  dgBossIdleState.goTo = ind
  dgBossIdleState.velocity = (dgBossIdleState.places[ind]-dgBossIdleState.places[lastInd])/dgBossIdleState.movTime
end

function dgBossIdleState.update(dt)
  local dg = dgBossIdleState.boss
  dgBossIdleState.timer = dgBossIdleState.timer-dt
  if dgBossIdleState.timer<0 then
    dg.endState()
  else
    dg.y = dg.y + dgBossIdleState.velocity*dt
    if math.sign(dgBossIdleState.velocity) == math.sign(dg.y-dgBossIdleState.places[dgBossIdleState.goTo]) then
      dgBossIdleState.goNext()
    end
  end
end

function dgBossIdleState.draw()
end

function math.sign(v)
  if v>0 then return 1 else return -1 end
end