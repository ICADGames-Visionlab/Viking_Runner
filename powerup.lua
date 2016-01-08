require "contact"

powerup = {}

function powerup.load()
  powerup.list = {}
  powerup.width=72
  powerup.height=72
  powerup.color = {255,40,40,255}
end

function powerup.spawn(x,y)
  table.insert(powerup.list,{x=x,y=y,width=powerup.width,height=powerup.height})
end

function powerup.update(dt)
  for i,v in ipairs(powerup.list) do
    
  end
end

function powerup.acquire(i)
  table.remove(powerup.list,i)
  audio.playPowerup()
end

function powerup.draw()
  love.graphics.setColor(255,40,40,255)
  for i,v in ipairs(powerup.list) do
    love.graphics.rectangle("fill",v.x,v.y,powerup.width,powerup.height)
  end
  love.graphics.setColor(255,255,255)
end