require "contact"

axe = {}

function axe.load()
  axe.image = love.graphics.newImage("/Assets/Enemies/mapleDragon.png")
  axe.width = 72
  axe.height = 72
  axe.quad = love.graphics.newQuad(0,0,axe.width,axe.height,axe.image:getWidth(),axe.image:getHeight())
  axe.instance = nil
  axe.speed = love.graphics.getWidth()*0.6
end

function axe.spawn(x,y)
  if axe.instance == nil then
    axe.instance = {x=x, y=y, rot=0}
  end
end

function axe.update(dt)
  if axe.instance ~= nil then
    axe.instance.x = axe.instance.x + axe.speed*dt
    if axe.instance.x>love.graphics.getWidth() then
      axe.remove()
    else
      axe.checkContact()
    end
  end
end

function axe.remove()
  axe.instance = nil
end

function axe.checkContact()
  local a = axe.instance
  for i,v in ipairs(enemies) do
    for j,w in ipairs(v.list) do
      if contact.isInRectContact(a.x,a.y,axe.width,axe.height,w.x,302+w.y,v.width,v.height) then
        axe.remove()
        v.replace(w)
      end
    end
  end
end

function axe.draw()
  v = axe.instance
  if v ~= nil then
    love.graphics.draw(axe.image,axe.quad,v.x,v.y,v.rot)
  end
end