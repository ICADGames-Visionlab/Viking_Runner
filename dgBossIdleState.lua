dgBossIdleState = {}
local didShot

function dgBossIdleState.load()
  dgBossIdleState.verticalSpeed=love.graphics.getHeight()/2
  --idleState.sheet = love.graphics.newImage()
  dgBossIdleState.places = {100,500}
  dgBossIdleState.movTime = 1.3
end

function dgBossIdleState.start(boss,time)
  dgBossIdleState.boss = boss
  dgBossIdleState.timer=time
  dgBossIdleState.startMovement()
  boss.curr_sprite = boss.fly
  animComp.restart(boss.fly.aComp)
  didShot=false
end

function dgBossIdleState.startMovement()
  dgBossIdleState.goTo = #dgBossIdleState.places
  dgBossIdleState.goNext()
end

function dgBossIdleState.goNext()
  local lastInd = dgBossIdleState.goTo
  local ind = (lastInd)%(#dgBossIdleState.places)+1
  dgBossIdleState.goTo = ind
  dgBossIdleState.velocity = (dgBossIdleState.places[ind]-dgBossIdleState.places[lastInd])/dgBossIdleState.movTime
end

function dgBossIdleState.update(dt)
  local dg = dgBossIdleState.boss
  dgBossIdleState.timer = dgBossIdleState.timer-dt
  if dgBossIdleState.timer<0 then
    dg.newActionState()
  else
    dg.y = dg.y + dgBossIdleState.velocity*dt
    if math.sign(dgBossIdleState.velocity) == math.sign(dg.y-dgBossIdleState.places[dgBossIdleState.goTo]) then
      dgBossIdleState.goNext()
    end
  end
  if dg.isRaged then
    if dg.fly.aComp.curr_frame == math.floor((dg.fly.aComp.qFrames+1)/2) then
      if not didShot then
        didShot = true
        bullet.spawn(dg.x,dg.y)
      end
    else
      didShot = false
    end
  end
end

function dgBossIdleState.draw()
  
end

function math.sign(v)
  if v>0 then return 1 else return -1 end
end