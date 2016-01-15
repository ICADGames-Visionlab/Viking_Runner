require "stage"
require "player"
require "enemy"
require "bullet"
require "animations"

game = {}
game.isPaused = false

local loadModule

function game.load()
  game.pauseImg = love.graphics.newImage("/Assets/Tela_Intro/Pause.png")
  game.modules = {}
  loadModule(stage)
  loadModule(player)
  loadModule(enemies)
  loadModule(bullet)
  loadModule(animations)
end

function loadModule(mod)
  mod.load()
  table.insert(game.modules,mod)
end

function game.start(data)
  game.startTime = 2
  game.startAnim = animComp.newAnim(12,player.sprites[run].time)
  player.start()
  stage.start()
  game.prepareBackgrounds(data)
end

function game.keypressed(key)
  if key=="escape" or key=="return" then
    game.isPaused = not game.isPaused
  elseif not game.isPaused and not(game.startTime>0) then
    player.keypressed(key)
  end
end

function game.mousepressed(x,y,button)
end

function game.update(dt)
  if not game.isPaused then
    stage.update(dt)
    if game.startTime>0 then
      game.startUpdate(dt)
    else
      player.update(dt)
      enemies.update(dt)
      bullet.update(dt)
      animations.update(dt)
    end
  end
end

function game.draw()
  stage.draw()
  if game.startTime>0 then game.startDraw() else
    player.draw()
    enemies.draw()
    bullet.draw()
    animations.draw()
    game.pauseDraw()
  end
end

function game.startUpdate(dt)
  game.startTime = game.startTime-dt
  if game.startTime<0 then
    game.startTime = 0
    game.startAction()
  end
  player.x = -player.imgWidth+(1-game.startTime/2)*2*player.imgHeight
  animComp.update(dt,game.startAnim)
end

function game.startDraw()
  local sprite = player.sprites[run]
  love.graphics.draw(sprite.sheet, sprite.quads[game.startAnim.curr_frame],player.x,player.y,0,player.scale,player.scale,player.offset.x,player.offset.y)
  love.graphics.draw(player.armSheet, sprite.quads[game.startAnim.curr_frame],player.x,player.y,0,player.scale,player.scale,player.armOffset.x,player.armOffset.y)
  shield.draw()
  game.pauseDraw()
end

function game.prepareBackgrounds(data)
  stage.prepareBackgrounds(data)
  player.x = -player.imgWidth
end

function game.startAnimation()
  
end

function game.startAction()
  stage.testSpawn()
end

function game.pauseDraw()
  if game.isPaused then
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    love.graphics.setColor(0,0,0,100)
    love.graphics.rectangle("fill",0,0,w,h)
    love.graphics.setColor(255,255,255)
    love.graphics.draw(game.pauseImg,0,0,0,w/game.pauseImg:getWidth(),h/game.pauseImg:getHeight())
  end
end

function game.returnToMenu()
  game.quit()
  --love.returnToMenu()
  love.gameover()
end

function game.goToGameover()
  
end

function game.quit()
  for i,v in ipairs(game.modules) do
    v.quit()
  end
end

function table.removeAll(t)
  while #t>0 do
    table.remove(t,1)
  end
end