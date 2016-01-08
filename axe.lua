require "contact"

axe = {}

function axe.load()
  axe.image = love.graphics.newImage("/Assets/Enemies/mapleDragon.png")
  axe.width = 72
  axe.height = 72
  axe.quad = love.graphics.newQuad(0,0,axe.width,axe.height,axe.image:getWidth(),axe.image:getHeight())
  --axe.instance = nil
  axe.speed = love.graphics.getWidth()*0.6
  axe.rotSpeed = math.pi
  axe.limit = 1
  axe.list = {}
end

function axe.spawn(x,y)
  local quant = #axe.list
  if quant<axe.limit then
    table.insert(axe.list,{x=x,y=y,rot=0})
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
  for i,v in ipairs(axe.list) do
    v.x = v.x + axe.speed*dt
    if v.x>love.graphics.getWidth() then
      axe.remove(i)
    else
      v.rot = v.rot + axe.rotSpeed*dt
      axe.checkContact(i,v)
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
        v.replace(w)
      end
    end
  end
end

function axe.draw()
  for i,v in ipairs(axe.list) do
    love.graphics.draw(axe.image,axe.quad,v.x+axe.width/2,v.y+axe.height/2,v.rot,1,1,axe.width/2,axe.height/2)
    if configuration.debugBoundingBox then
      love.graphics.rectangle("line",v.x,v.y,axe.width,axe.height)
    end
  end
end