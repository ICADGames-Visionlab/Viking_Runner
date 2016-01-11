platform = {}

function platform.load()
  platform.image = love.graphics.newImage("/Assets/Background/Plataforma.png")
  platform.list = {}
  platform.imgW = platform.image:getWidth()
  platform.imgH = platform.image:getHeight()
  --platform.color = {0,0,0}
end

function platform.generate(x,y,width,height)
  table.insert(platform.list, {x=x, y=y, width=width, height=height})
end

function platform.update(dt)
  for i,v in ipairs(platform.list) do
    
  end
end

function platform.draw()
  for i,v in ipairs(platform.list) do
    love.graphics.draw(platform.image,v.x,v.y,0,v.width/platform.imgW,v.height/platform.imgH)
  end
end

function platform.removePlatforms()
  while #platform.list>0 do
    table.remove(platform.list,1)
  end
end