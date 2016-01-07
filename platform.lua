platform = {}

function platform.load()
  platform.list = {}
end

function platform.generate(x,y,width,height)
  table.insert(platform.list, {x=x, y=y, width=width, height=height})
end

function platform.update(dt)
  for i,v in ipairs(platform.list) do
    
  end
end

function platform.draw()
end

function platform.removePlatforms()
  while #platform.list>0 do
    table.remove(platform.list,1)
  end
end