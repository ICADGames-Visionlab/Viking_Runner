require "contact"

powerup = {}

local pType = {strength=1,shield=2,axe=3}

function powerup.load()
  powerup.list = {}
  powerup.types = {}
  powerup.width=72
  powerup.height=72
  powerup.color = {255,40,40,255}
  loadPowerup("powerup-Strength.png")
  loadPowerup("powerup-Shield.png")
  loadPowerup("powerup-Speed.png")
  --powerup-Shield
end

function loadPowerup(string)
  local img = love.graphics.newImage("/Assets/Character/" .. string)
  table.insert(powerup.types,{image=img,scale = powerup.height/img:getHeight()})
end

function powerup.spawn(x,y)
  
  local type = love.math.random(1,3)
  table.insert(powerup.list,{x=x,y=y,width=powerup.width,height=powerup.height,type = type})
end

function powerup.update(dt)
  for i,v in ipairs(powerup.list) do
    
  end
end

function powerup.acquire(i,v)
  local t = v.type
  if t==pType.shield then
    shield.reset()
  elseif t==pType.axe then
    axe.speedPowerup()
  end
  table.remove(powerup.list,i)
  audio.playPowerup()
end

function powerup.draw()
  --love.graphics.setColor(255,40,40,255)
  for i,v in ipairs(powerup.list) do
    local t = powerup.types[v.type]
    love.graphics.draw(t.image,v.x,v.y,0,t.scale,t.scale)
  end
  --love.graphics.setColor(255,255,255)
end