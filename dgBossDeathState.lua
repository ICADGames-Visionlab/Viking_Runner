dgBossDeathState = {}
local vel
local time = 7
local timer
local expTime = 0.2
local expTimer

function dgBossDeathState.load(dragon)
  dgBossDeathState.dragon = dragon
end

function dgBossDeathState.start()
  local dg = dgBossDeathState.dragon
  dgBossDeathState.moveTo = love.graphics.getHeight() + dg.fly.offset.y
  vel = (dgBossDeathState.moveTo-dg.y)/time
  timer = time
  expTimer = expTime
  dg.curr_sprite = dg.death
  animComp.restart(dg.death.aComp)
end

function dgBossDeathState.update(dt)
  local dg = dgBossDeathState.dragon
  if timer>0 then
    timer = timer - dt
    expTimer = expTimer - dt
    dg.y = dg.y + vel*dt
    if timer<0 then
      dg.y = dgBossDeathState.moveTo
    elseif expTimer<0 then
      animations.createRandomExplosion(dg.x,dg.y,dg.width,dg.height,color.red)
      expTimer = expTime
    end
  end
end

function dgBossDeathState.draw()
  
end