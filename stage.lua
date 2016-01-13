require "platform"
require "powerup"
require "gameState"
require "dragonBoss"
stage = {}
background = {}
platformId = 1
powerupId = 2

function stage.load()
  stage.sprite = love.graphics.newImage("/Assets/Background/primeiro_plano.png")
  background = {}
  background.image = love.graphics.newImage("/Assets/Background/segundo_plano.png")
  background.position = 0
  --background.image = love.graphics.newImage()
  stage.width = love.graphics.getWidth()
  stage.height = love.graphics.getHeight()
  background.width = stage.width
  background.height = stage.height
  stage.scaleX = stage.width / stage.sprite:getWidth()
  stage.scaleY = stage.height / stage.sprite:getHeight()
  stage.maxV = stage.width/3
  stage.velocity = stage.maxV
  background.maxV = stage.velocity/3
  background.velocity = background.maxV
  stage.position = 0;
  stage.elements = {}
  stage.platformHeight = 0.55*stage.height+20
  loadElement(platformId, platform)
  loadElement(powerupId, powerup)
  gameState.load(stage)
  dragonBoss.load()
end

function loadElement(id, class)
  stage.elements[id] = class
  class.load()
end

function stage.prepareBackgrounds(data)
  background.velocity = background.maxV
  stage.velocity = stage.maxV
  background.position = data.back1Pos
  stage.position = data.back2Pos
  audio.playPlayerRun()
end

function stage.start()
  stage.screen = 1
  stage.curr_step = gameState
end

function stage.startBoss()
  stage.curr_step = dragonBoss
  stage.curr_step.start(player)
end

function stage.testSpawn()
  bullet.randomSpawn()
  dragon.spawn()
end

function stage.quit()
  for i,v in ipairs(stage.elements) do
    table.removeAll(v.list)
  end
end

function stage.update(dt)
  local mov = stage.velocity*dt
  stage.position = stage.position + mov
  background.position = background.position + background.velocity*dt
  if background.position >= background.width then
    background.position = background.position - background.width
  end
  stage.curr_step.update(dt)
  
  for i,v in ipairs(stage.elements) do
    for j,w in ipairs(v.list) do
      w.x = w.x - mov
      if(w.x+w.width<0) then
        table.remove(v.list,j)
      end
    end
  end
end

function stage.draw()
  local point = -stage.position
  local backPoint = -background.position
  love.graphics.draw(background.image,backPoint,0)
  love.graphics.draw(background.image,backPoint+background.width,0)
  love.graphics.draw(stage.sprite,point,0,0,stage.scaleX,stage.scaleY)
  love.graphics.draw(stage.sprite,point+stage.width,0,0,stage.scaleX,stage.scaleY)
  --love.graphics.draw(stage.sprite,0,0,0,love.graphics.getWidth(),love.graphics.getHeight())
  
  for i,v in ipairs(stage.elements) do
    v.draw()
    --[[
    if v.color ~= nil then
      love.graphics.setColor(v.color)
      for j,w in ipairs(v.list) do
        love.graphics.rectangle("fill", w.x,w.y,w.width,w.height)
      end
      love.graphics.setColor(255,255,255)
    else
      for j,w in ipairs(v.list) do
        love.graphics.draw(v.image,w.x,w.y,0,w.width/v.imgW,w.height/v.imgH)
      end
    end
    ]]
  end
  stage.curr_frame.draw()
end