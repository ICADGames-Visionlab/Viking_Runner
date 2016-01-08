require "contact"

bullet = {}

function bullet.load()
  bullet.image = love.graphics.newImage("/Assets/Enemies/bulletBill.png")
  bullet.velocity = -love.graphics.getWidth()*0.5
  bullet.list = {}
  bullet.width = 144
  bullet.height = 72
  
  originalWidth = bullet.image:getWidth()
  originalHeight = bullet.image:getHeight()
  bullet.sw = bullet.width / originalWidth
  bullet.sh = bullet.height / originalHeight
  --bullet.s = bullet.sw>bullet.sh and bullet.sw or bullet.sh
end

function bullet.randomSpawn()
  randomNumber = love.math.random()
  bulletPos = randomNumber>0.5 and 0 or 1
  rnd = 302 + 200*bulletPos
  table.insert(bullet.list, {x=love.graphics.getWidth(),y=rnd})
  audio.playBullet()
end

function bullet.update(dt)
  for i,v in ipairs(bullet.list) do
    v.x = v.x + bullet.velocity*dt
  end
  if player.invTime==0 then
    bullet.checkContact()
  end
end

function bullet.checkContact()
  local p = player
  for i,v in ipairs(bullet.list) do
    if(v.x+bullet.width<0) then
      table.remove(bullet.list,i)
      bullet.randomSpawn()
    elseif contact.isInRectContact(p.x,p.y,p.width,p.height,v.x,v.y,bullet.width,bullet.height) then
      player.reset()
      table.remove(bullet.list,i)
      bullet.randomSpawn()
    end
  end
end

function bullet.draw(dt)
  for i,v in ipairs(bullet.list) do
    love.graphics.draw(bullet.image,v.x,v.y,0,bullet.sw, bullet.sh)
    if configuration.debugBoundingBox then
      love.graphics.rectangle("line",v.x,v.y,bullet.width,bullet.height)
    end
  end
end