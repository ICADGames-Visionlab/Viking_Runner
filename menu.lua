menu = {}

function menu.load()
  menu.backgrounds = loadBackgrounds({"segundo_plano.png","primeiro_plano.png"})
  local w = love.graphics.getWidth()
  --menu.backgrounds[1].speed = w/9
  --menu.backgrounds[2].speed = w/3
  menu.backgrounds[1].speed = w/4
  menu.backgrounds[2].speed = w/2
  local img = love.graphics.newImage("/Assets/play.png")
  local w = img:getWidth()
  local h = img:getHeight()
  menu.playButton = {image=img,x=(love.graphics.getWidth()-w)/2,y=(love.graphics.getHeight()-h)/2,width=img:getWidth(),height=img:getHeight()}
  menu.animating = false
  menu.alpha = 255
  menu.alphaVel = 160
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

function menu.keypressed(key)
end

function menu.mousepressed(x,y,button)
  if not menu.animating and contains(menu.playButton,x,y) then
    menu.playGame()
  end
end

function menu.playGame()
  menu.animating = true
end

function menu.update(dt)
  for i,v in ipairs(menu.backgrounds) do
    v.x = v.x+v.speed*dt
    if v.x>v.width then
      v.x = v.x-v.width
    end
  end
  if menu.animating then
    menu.alpha = menu.alpha - menu.alphaVel*dt
    if menu.alpha<0 then
      data = {back1Pos=menu.backgrounds[1].x,back2Pos=menu.backgrounds[2].x}
      love.startGame(data)
      menu.animating = false
    end
  end
end

function menu.draw()
  for i,v in ipairs(menu.backgrounds) do
    local p = -v.x
    love.graphics.draw(v.image,p,v.y,0,v.s,v.s)
    love.graphics.draw(v.image,p+v.width,v.y,0,v.s,v.s)
  end
  --Draw buttons (can be animated)
  love.graphics.setColor(255,255,255,menu.alpha)
  local v=menu.playButton
  --love.graphics.rectangle("fill",v.x,v.y,v.width,v.height)
  love.graphics.draw(v.image,v.x,v.y)
  love.graphics.setColor(255,255,255)
end

function contains(button,x,y)
  return not (x<button.x or x>button.x+button.width or y<button.y or y>button.y+button.height)
end