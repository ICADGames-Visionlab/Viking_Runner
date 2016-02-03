dgArcFireAtState = {}

local numFire = 5
local maxNumFire = 5
local timeout = 0.6
local steps = {hide=0,attack=1,back=2}
local getOutTime = 1
local shotTime = 1 --1.3
local fireAngle = math.pi/8
local timer=0
local trueAngle

function dgArcFireAtState.load()
  --dgArcFireAtState.sheet = love.graphics.newImage()
  --dgArcFireAtState.quads = {}
  dgArcFireAtState.shots = {}
end

function dgArcFireAtState.start(boss)
  dgArcFireAtState.shots.width = bullet.width--100
  dgArcFireAtState.shots.height = bullet.height--100
  dgArcFireAtState.boss = boss
  boss.curr_sheet = boss.fly
  startHide()
end

function prepareShots()
  local w = love.graphics.getWidth()
  local y = love.graphics.getHeight()+dgArcFireAtState.shots.height
  local dx = y*math.tan(fireAngle)
  local speedX = -dx/shotTime
  local speedY = y/shotTime
  y = -dgArcFireAtState.shots.height
  if love.math.random()>0.5 then
    preparePatternShots(speedX, speedY, dx, y, 10)
  else
    for i=1, numFire do
      local x = love.math.random()*(w-dgArcFireAtState.shots.width)+dgArcFireAtState.shots.width/2
        table.insert(dgArcFireAtState.shots,{speedX=speedX,timer=timeout*i,isReady=false,x=x+dx,y=y,speedY=speedY,aComp=animComp.newAnim(6,0.7)})
    end
  end
end
--Make first shot of random to target player
function preparePatternShots(speedX, speedY, dx, y, quant)
  local start = dgArcFireAtState.shots.width
  local final = love.graphics.getWidth()-dgArcFireAtState.shots.width/2
  local dist = (final-start)/quant
  for i=1, quant do
    table.insert(dgArcFireAtState.shots,{speedX=speedX,timer=timeout*i,isReady=false,x=dx+(i-1)*dist,y=y,speedY=speedY,aComp=animComp.newAnim(6,0.7)})
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
  audio.playDgScream()
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
          table.remove(dgArcFireAtState.shots,i)
        elseif contact.isInRectContact(p.x,p.y,p.width,p.height,v.x,v.y,dgArcFireAtState.shots.width,dgArcFireAtState.shots.height) then
          p.reset()
        end
      end
      --Mark stage
    else
      --Timeout
      v.timer = v.timer-dt
      if v.timer<0 then
        v.isReady=true
        v.timer = timeout
      end
    end
  end
  print(#dgArcFireAtState.shots)
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
    print("hide")
    updateHide(dt)
  elseif s==steps.attack then
    print("attack")
    updateAttack(dt)
  else
    print("show")
    updateShow(dt)
  end
end

function dgArcFireAtState.draw()
  local angle = -(math.pi/2-fireAngle)
  --love.graphics.setColor(255,50,50)
  for i,v in ipairs(dgArcFireAtState.shots) do
    if v.isReady then
      --angle = -(math.pi/2-math.atan((stage.velocity-v.speedX)/v.speedY))
      love.graphics.draw(bullet.image,bullet.quads[v.aComp.curr_frame],v.x,v.y,angle,bullet.scale,bullet.scale,bullet.offset.x,bullet.offset.y)
      --love.graphics.rectangle("fill",v.x,v.y,dgArcFireAtState.shots.width,dgArcFireAtState.shots.height)
    end
  end
  --love.graphics.setColor(255,255,255)
end