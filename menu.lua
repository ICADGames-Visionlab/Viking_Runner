menu = {}

function menu.load()
  menu.backgrounds = loadBackgrounds({"Back1","Back2"})
  local w = love.graphics.getWidth()
  menu.backgrounds[1].speed = w/9
  menu.backgrounds[2].speed = w/3
end

function loadBackgrounds(strings)
  vv={}
  for i,v in ipairs(strings) do
    vv[i]=loadBackground(v)
  end
  return vv
end
function loadBackground(string)
  local img = love.graphics.newImage("/Assets/Background/" .. string)
  v = {x=0,y=0,image=img,width=img:getWidth(),height=img:getHeight(),s=love.graphics.getHeight()/img:getHeight()}
  return v
end

function menu.update(dt)
  for i,v in ipairs(menu.backgrounds) do
    v.x = v.x+v.speed*dt
  end
end

function menu.draw()
  for i,v in ipairs(menu.backgrounds) do
    local p = -v.x
    love.graphics.draw(v.image,p,v.y,0,v.s,v.s)
    love.graphics.draw(v.image,p+v.width,v.y,0,v.s,v.s)
  end
end