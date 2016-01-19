require "contact"

axe = {}

function axe.load(scale)
  axe.image = love.graphics.newImage("/Assets/Character/axe.png")
  axe.s = scale*1.2--*60/72
  axe.width = axe.s*72
  axe.height = axe.s*72
  
  axe.quad = love.graphics.newQuad(0,0,72,72,axe.image:getWidth(),axe.image:getHeight())
  --axe.instance = nil
  axe.speed = love.graphics.getWidth()*0.6
  axe.rotSpeed = -math.pi*3/2
  axe.limit = 100
  axe.list = {}
  axe.maxCooldown = 1.3
  axe.minCooldown = 0.65
  axe.cooldown = axe.maxCooldown
  axe.timer = 0
  axe.powerTimer = 0
  --DO START TO REFRESH COOLDOWN
end

function axe.speedPowerup()
  axe.powerTimer = 5
  axe.cooldown = axe.minCooldown
  axe.timer = axe.timer - (axe.maxCooldown-axe.minCooldown)
end

function axe.removeAll()
  table.removeAll(axe.list)
end

function axe.spawn(x,y)
  local quant = #axe.list
  if quant<axe.limit and axe.timer<=0 then
    table.insert(axe.list,{x=x,y=y,rot=math.pi/2})
    axe.timer = axe.cooldown
    return true
  end
  return false
  --[[
  if axe.instance == nil then
    axe.instance = {x=x, y=y, rot=0}
  end
  ]]
end

function axe.update(dt)
  if axe.timer>0 then
    axe.timer = axe.timer-dt
  end
  for i,v in ipairs(axe.list) do
    v.x = v.x + axe.speed*dt
    if v.x>love.graphics.getWidth() then
      axe.remove(i)
    else
      v.rot = v.rot + axe.rotSpeed*dt
      axe.checkContact(i,v)
    end
  end
  if axe.powerTimer > 0 then
    axe.powerTimer = axe.powerTimer-dt
    if axe.powerTimer < 0 then
      axe.powerTimer = 0
      axe.cooldown = axe.maxCooldown
    end
  end
end

function axe.remove(i)
  table.remove(axe.list,i)
end

function axe.checkContact(ind,a)
  for i,v in ipairs(enemies) do
    for j,w in ipairs(v.list) do
      if contact.isInRectContact(a.x,a.y,axe.width,axe.height,w.x,290+w.y,v.width,v.height) then
        axe.remove(ind)
        v.die(j,w)
      end
    end
  end
end

function axe.draw()
  for i,v in ipairs(axe.list) do
    love.graphics.draw(axe.image,axe.quad,v.x+axe.width/2,v.y+axe.height/2,v.rot,axe.s,axe.s,axe.width/2,axe.height/2)
    if configuration.debugBoundingBox then
      love.graphics.rectangle("line",v.x,v.y,axe.width,axe.height)
    end
  end
end