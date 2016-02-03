menu = {}
local loadBackgrounds, loadBackground, contains
local play=1
local controls=2

function menu.load()
  menu.backgrounds = loadBackgrounds({"segundo_plano.png","primeiro_plano.png"})
  local w = love.graphics.getWidth()
  --menu.backgrounds[1].speed = w/9
  --menu.backgrounds[2].speed = w/3
  menu.backgrounds[1].speed = w/12
  menu.backgrounds[2].speed = w/4
  menu.animating = false
  menu.alphaVel = 160
  menu.fadeOutTime = 1
  local img = love.graphics.newImage("/Assets/Tela_Intro/Placa_Intro.png")
  local bHeight = menu.backgrounds[1].height
  local h = 0.6944*bHeight
  local s = h/img:getHeight()
  local w = s*img:getWidth()
  menu.placa = {image=img,x=(love.graphics.getWidth()-w)/2,firstY = -h, secondY = 0,width=w,height=h,scale=s}
  img = love.graphics.newImage("/Assets/Tela_Intro/Start_Game.png")
  h = 240/3004*bHeight
  s = h/img:getHeight()
  w = s*img:getWidth()
  menu.buttons = {}
  table.insert(menu.buttons,{image=img,x=(love.graphics.getWidth()-w)/2,y=0.7034*bHeight,width=w,height=h,s=s})
  img = love.graphics.newImage("/Assets/Tela_Intro/Controls.png")
  w = s*img:getWidth()
  table.insert(menu.buttons,{image=img,x=(love.graphics.getWidth()-w)/2,y=2442/3004*bHeight,width=w,height=h,s=s})
  img = love.graphics.newImage("/Assets/Tela_Intro/Axe_Selection.png")
  menu.selector = {dist=70*s,image=img,width=s*img:getWidth(),height=s*img:getHeight(),s=s}
end

function menu.start()
  menu.alpha = 255
  menu.placa.y = menu.placa.secondY
  putSelector(play)
end

function putSelector(ind)
  local v = menu.selector
  local b = menu.buttons[ind]
  v.ind=ind
  v.x=b.x-v.dist-v.width
  v.y=b.y+(b.height-v.height)/2
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
  if menu.isAnimating then return false end
  if key=="down" then
    putSelector(menu.selector.ind%#menu.buttons+1)
  elseif key=="up" then
    local q = #menu.buttons
    putSelector((menu.selector.ind-2+q)%q+1)
  elseif key=="return" then
    didEnter()
  end
end

function didEnter()
  local v = menu.selector.ind
  if v==play then
    menu.playGame()
  elseif v==controls then
    
  end
end

function menu.mousepressed(x,y,button)
  if not menu.animating then
    for i,v in ipairs(menu.buttons) do
      if contains(v,x,y) then
        menu.playGame()
        audio.playMenuStart()
      end
    end
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
    menu.alpha = menu.alpha - 255/menu.fadeOutTime*dt
    menu.placa.y = menu.placa.y - menu.placa.height/menu.fadeOutTime*dt
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
  local v=menu.placa
  love.graphics.draw(v.image,v.x,v.y,0,v.s,v.s)
  --Draw buttons (can be animated)
  love.graphics.setColor(255,255,255,menu.alpha)
  for i,v in ipairs(menu.buttons) do
    love.graphics.draw(v.image,v.x,v.y,0,v.s,v.s)
  end
  v = menu.selector
  love.graphics.draw(v.image,v.x,v.y,0,v.s,v.s)
  love.graphics.setColor(255,255,255)
end

function contains(button,x,y)
  return not (x<button.x or x>button.x+button.width or y<button.y or y>button.y+button.height)
end