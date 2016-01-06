bullet = {}

function bullet.load()
  bullet.image = love.graphics.newImage()
  bullet.velocity = -love.graphics.getWidth()/3
  bullet.list = {}
  bullet.width = 72
  bullet.height = 72
end

function bullet.randomSpawn()
  rnd = 282 + 100*love.math.random()%2
  table.insert(bullet.list, {x=love.graphics.getWidth(),y=rnd})
end

function bullet.update(dt)
  for i,v in ipairs(bullet.list) do
    v.x = v.x + bullet.velocity*dt
    if(v.x+bullet.width<0) then
      table.remove(i)
      bullet.randomSpawn()
    end
  end
end

function bullet.draw(dt)
  for i,v in ipairs(bullet.list) do
    love.graphics.draw(bullet.image,v.x,v.y,0)
  end
end