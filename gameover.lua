gameover = {}

local loadFullImgData

--5333,3000
--860,2072
--3642,2072

function gameover.load()
  gameover.elements = {}
  gameover.showTime = 1
  gameover.aniTime = 1
  local w = love.graphics.getWidth()
  local h = love.graphics.getHeight()
  gameover.title = loadFullImgData("title.png")
  gameover.title.origin = {x=0,y=-gameover.title.height}
  gameover.axeShield = loadFullImgData("axeShield.png")
  gameover.axeShield.origin = {x=0,y=h}
  gameover.continueB = loadFullImgData("Continue.png")
  gameover.continueB.origin = {x=-gameover.continueB.width,y=0}
  gameover.exitB = loadFullImgData("Exit.png")
  gameover.exitB.origin = {x=w,y=0}
  for i,v in ipairs(gameover.elements) do
    calculateSpeed(v)
  end
  local pW = w/5333
  local pH = h/3000
  gameover.selector = {
    {x=860*pW,y=2072*pH},
    {x=3620*pW,y=2072*pH}
  }
end

function calculateSpeed(ele)
  ele.speed = {x=-ele.origin.x/gameover.aniTime,y=-ele.origin.y/gameover.aniTime}
end

function gameover.start()
  gameover.selector.ind = 1
  gameover.timer = gameover.showTime
  gameover.backImage = love.graphics.newImage(love.graphics.newScreenshot())
  for i,v in ipairs(gameover.elements) do
    v.x = v.origin.x
    v.y = v.origin.y
  end
  gameover.backAlpha = 255
  gameover.hasShow = false
end

function loadFullImgData(string)
  local img = love.graphics.newImage("/Assets/Tela_GameOver/" .. string)
  local h = love.graphics.getHeight()
  local scale = h/img:getHeight()
  local v = {image=img, width = img:getWidth()*scale, height = h, scale = scale}
  table.insert(gameover.elements,v)
  return v
end

function gameover.keypressed(key)
  if gameover.timer==0 then
    local sel = gameover.selector.ind
    if key == "return" then
      if sel == 1 then gameover.goToGame() else gameover.goToMenu() end
    elseif key == "right" or key == "left" then
      gameover.selector.ind = sel==1 and 2 or 1
    end
  end
end

function gameover.goToGame()
  gameover.quit()
  love.startGame({back1Pos=0, back2Pos=0})
end

function gameover.goToMenu()
  gameover.quit()
  love.returnToMenu()
end

function gameover.quit()
  audio.leaveGameover()
end

function gameover.mousepressed(x,y,button)
end

function gameover.update(dt)
  if gameover.timer > 0 then
    gameover.timer = gameover.timer - dt
    if gameover.timer <= 0 then
      if not gameover.hasShow then
        gameover.hasShow = true
        gameover.timer = gameover.aniTime
        gameover.backAlpha = 0
      else
        gameover.timer = 0
        for i,v in ipairs(gameover.elements) do
          v.x = 0
          v.y = 0
        end
      end
    elseif gameover.hasShow then
      for i,v in ipairs(gameover.elements) do
        v.x = v.x+v.speed.x*dt
        v.y = v.y+v.speed.y*dt
      end
    else
      gameover.backAlpha = gameover.timer/gameover.showTime*255
    end
  end
end

function gameover.draw()
  local ax = menu.selector
  local sel = gameover.selector[gameover.selector.ind]
  love.graphics.draw(ax.image,sel.x-ax.width,sel.y-ax.height/2,0,ax.s,ax.s)
  love.graphics.setColor(255,255,255,gameover.backAlpha)
  love.graphics.draw(gameover.backImage)
  love.graphics.setColor(255,255,255)
  for i,v in ipairs(gameover.elements) do
    love.graphics.draw(v.image,v.x,v.y,0,v.scale,v.scale)
  end
end