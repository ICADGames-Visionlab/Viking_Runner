bullet = {}

function bullet.load()
  bullet.image = love.graphics.newImage("/Assets/Enemies/bulletBill.png")
  bullet.velocity = -love.graphics.getWidth()*0.4
  bullet.list = {}
  bullet.width = 144
  bullet.height = 72
  bullet.randomSpawn()
  
  originalWidth = bullet.image:getWidth()
  originalHeight = bullet.image:getHeight()
  bullet.sw = bullet.width / originalWidth
  bullet.sh = bullet.height / originalHeight
  --bullet.s = bullet.sw>bullet.sh and bullet.sw or bullet.sh
end

function bullet.randomSpawn()
  randomNumber = love.math.random()
  bulletPos = randomNumber>0.5 and 0 or 1
  rnd = 282 + 100*bulletPos
  table.insert(bullet.list, {x=love.graphics.getWidth(),y=rnd})
end

function bullet.update(dt)
  for i,v in ipairs(bullet.list) do
    v.x = v.x + bullet.velocity*dt
    if(v.x+bullet.width<0) then
      table.remove(bullet.list,i)
      bullet.randomSpawn()
    end
  end
end

function bullet.draw(dt)
  for i,v in ipairs(bullet.list) do
    love.graphics.draw(bullet.image,v.x,v.y,0,bullet.sw, bullet.sh)
  end
end