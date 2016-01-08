dgArcFireAtState = {}

local numFire = 1
local maxNumFire = 5
local timeout = 0.5
local steps = {hide=0,attack=1,back=2}
local getOutTime = 1
local shotTime = 1
local fireAngle = math.pi/9
local timer=0

function dgArcFireAtState.load()
  dgArcFireAtState.sheet = love.graphics.newImage()
  dgArcFireAtState.quads = {}
  dgArcFireAtState.shots = {}
  dgArcFireAtState.shots.width = 100
  dgArcFireAtState.shots.height = 100
end

function dgArcFireAtState.start(boss)
  dgArcFireAtState.boss = boss
  startHide()
end

function prepareShots()
  local w = love.graphics.getWidth()
  local y = love.graphics.getHeight()+dgArcFireAtState.shots.height
  local dx = y/math.tan(fireAngle)
  local speedX = -dx/shotTime
  local speedY = y/shotTime
  for i=1, numFire do
    local x = love.math.random()*(w-dgArcFireAtState.shots.width)+dgArcFireAtState.shots.width/2
      table.insert(dgArcFireAtState.shots,{speedX=speedX,timer=timeout*i,isReady=false,x=x+dx,y=y,speedY=speedY})
  end
end

function startHide()
  local dg = dgArcFireAtState.boss
  dgArcFireAtState.destLoc = love.graphics.getWidth()+dg.width
  dgArcFireAtState.vel = (dgArcFireAtState.destLoc-dg.x)/getOutTime
  dgArcFireAtState.actualStep = steps.hide
end

function updateHide(dt)
  local dg = dgArcFireAtState.boss
  dg.x = dg.x + dgArcFireAtState.vel*dt
  if dg.x>dgArcFireAtState.destLoc then
    startAttack()
  end
end

function startAttack()
  timer = timeout
  dgArcFireAtState.actualStep = steps.attack
  --audio
  --audio.playDragonScream()
  prepareShots()
end

function updateAttack(dt)
  local p = player
  local h = love.graphics.getHeight()
  for i,v in ipairs(dgArcFireAtState.shots) do
    --Droping stage
    if v.isReady then
      --Timeout
      if v.timer>0 then
        v.timer = v.timer-dt
      --Droping
      else
        v.x = v.x+v.speedX*dt
        v.y = v.y+v.speedY*dt
        if v.y>h then
          table.remove(dgArcFireAtState,i)
        else contact.inInRectContact(p.x,p.y,p.width,p.height,v.x,v.y,dgArcFireAtState.shots.width,dgArcFireAtState.shots.height)
          p.reset()
        end
      end
      --Mark stage
    else
      --Timeout
      if v.timer>0 then
        v.timer = v.timer-dt
        if v.timer<0 then
          v.isReady=true
          v.timer = timeout
        end
      end
    end
  end
  if #dgArcFireAtState.shots==0 then
    startShow()
  end
end

function startShow()
  local dg = dgArcFireAtState.boss
  dgArcFireAtState.actualStep = steps.show
  dgArcFireAtState.destLoc = love.graphics.getWidth()-dg.width
  dgArcFireAtState.vel = (dgArcFireAtState.destLoc-dg.x)/getOutTime
end

function updateShow(dt)
  local dg = dgArcFireAtState.boss
  dg.x = dg.x+dgArcFireAtState.vel*dt
  if dg.x<dgArcFireAtState.destLoc then
    dg.x = dgArcFireAtState.destLoc
    dg.endState()
  end
end

function dgArcFireAtState.update(dt)
  local s = dgArcFireAtState.actualStep
  if s==steps.hide then
    updateHide(dt)
  elseif s==steps.attack then
    updateAttack(dt)
  else
    updateShow(dt)
  end
end

function dgArcFireAtState.draw()
  love.graphics.setColor(255,50,50)
  for i,v in ipairs(dgArcFireAtState.shots) do
    love.graphics.rectangle("fill",v.x,v.y,dgArcFireAtState.shots.width,dgArcFireAtState.shots.height)
  end
  love.graphics.setColor(255,255,255)
end