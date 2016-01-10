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
  table.insert(dragon.list,{anim=animComp.newAnim(dragon.qFrame, 0.8), timer=0, floor=false, move=0, y=0, x=love.graphics.getWidth()+dragon.width})
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
      v.y = v.y+dragon.speedY*dt
      if v.move<=0 then
        v.floor = not v.floor;
        v.y = v.moveTo
        dragon.speedY = dragon.speedY*-1
      end
    end
    v.x = v.x - dragon.speedX*dt
    if v.x+dragon.width<0 then
      dragon.replace(v)
    end
  end
end

function dragon.replace(v)
  animations.createSplash(v.x+dragon.width/2,302+v.y+dragon.height/2)
  v.x = love.graphics.getWidth()
  audio.playDragonDeath()
end