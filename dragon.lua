require "animComp"

dragon = {}
dragon.list = {}
dragon.qFrame = 9

function dragon.load()
  dragon.spriteSheet = love.graphics.newImage("/Assets/Enemies/neteDragon.png")
  dragon.quads = {}
  local aw = dragon.spriteSheet:getWidth()
  local ah = dragon.spriteSheet:getHeight()
  local w = aw/5
  local h = ah
  for i=1, 5 do
    dragon.quads[i] = love.graphics.newQuad((i-1)*w,0,w,h,aw,ah)
  end
  for i=1, 4 do
    dragon.quads[i+5] = dragon.quads[6-i]
  end
  dragon.height = 90
  dragon.scale = dragon.height/h
  dragon.width = dragon.scale*w
  dragon.swapTime = 1.5
  dragon.moveTime = 0.5
  dragon.yDist = 180
  dragon.speedY = dragon.yDist/dragon.moveTime
  dragon.speedX = love.graphics.getWidth()/5
end

function dragon.spawn()
  local y,sign,floor
  if love.math.random()>0.5 then
    y=0
    sign = 1
    floor = false
  else
    y=dragon.yDist
    sign = -1
    floor = true
  end
  table.insert(dragon.list,{anim=animComp.newAnim(dragon.qFrame, 0.8), timer=0, floor=floor, move=0, y=y, x=love.graphics.getWidth()+dragon.width,speedY=dragon.speedY*sign})
end

--function dragon.doubleSpawn()
  --table.insert(dragon.list,{anim=animComp.newAnim(dragon.qFrame, 0.8), timer=0, floor=false, move=0, y=0, x=love.graphics.getWidth()+dragon.width,speedY=dragon.speedY})
  --table.insert(dragon.list,{anim=animComp.newAnim(dragon.qFrame, 0.8), timer=0, floor=true, move=0, y=dragon.yDist, x=love.graphics.getWidth()+dragon.width,speedY=-dragon.speedY})
--end

function dragon.doubleSpawn(quant)
  local w = love.graphics.getWidth()
  if quant == nil then quant=1 end
  for i=1, quant do
    local x = w+i*dragon.width
    table.insert(dragon.list,{anim=animComp.newAnim(dragon.qFrame, 0.8), timer=0, floor=false, move=0, y=0, x=love.graphics.getWidth()+dragon.width+i*dragon,speedY=dragon.speedY})
  table.insert(dragon.list,{anim=animComp.newAnim(dragon.qFrame, 0.8), timer=0, floor=true, move=0, y=dragon.yDist, x=love.graphics.getWidth()+dragon.width,speedY=-dragon.speedY})
  end
end

  
function dragon.update(dt)
  for i,v in ipairs(dragon.list) do
    v.timer = v.timer+dt
    if v.timer>dragon.swapTime then
      v.timer = 0
      v.move = dragon.moveTime
      if not v.floor then v.moveTo = dragon.yDist else v.moveTo = 0 end
    end
    if v.move>0 then
      v.move = v.move-dt
      v.y = v.y+v.speedY*dt
      if v.move<=0 then
        v.floor = not v.floor;
        v.y = v.moveTo
        v.speedY = v.speedY*-1
      end
    end
    v.x = v.x - dragon.speedX*dt
    if v.x+dragon.width<0 then
      dragon.remove(i)
    end
  end
end

function dragon.remove(i)
  table.remove(dragon.list,i)
end

function dragon.die(i,v)
  animations.createSplash(v.x+dragon.width/2,302+v.y+dragon.height/2)
  audio.playDragonDeath()
  dragon.remove(i)
end