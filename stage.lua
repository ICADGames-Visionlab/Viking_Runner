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
  stage.curr_step.start()
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
  if stage.position >= stage.width then
    stage.position = stage.position - stage.width
    didChange = true
  else didChange = false end
  stage.curr_step.update(dt, didChange)
  
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
  
  for i,v in ipairs(stage.elements) do
    v.draw()
  end
  stage.curr_step.draw()
  love.graphics.print(stage.screen,0,0,10,10)
end

function stage.generatePlatforms(withPowerup)
  w = stage.width
  h = stage.height
  sw = w*0.25
  sh = h*0.05
  local nRand = love.math.random()
  local platA, platB = false,false
  if nRand > 0.5 then
    platform.generate(w*1.125,stage.platformHeight,sw,sh)
    nRand = nRand-0.5
    platA = true
  end
  if nRand>0.25 then
    platform.generate(w*1.625,stage.platformHeight,sw,sh)
    platB = true
  end
  local n = love.math.random()
  if n>0.8 then
    local height = platA and stage.platformHeight or floor
    powerup.spawn(w*1.125+(sw-powerup.width)/2,height-powerup.height,powerup.width,powerup.height)
    n = n-0.2
  end
  if n>0.64 then
    local height = platB and stage.platformHeight or floor
    powerup.spawn(w*1.625+(sw-powerup.width)/2,height-powerup.height,powerup.width,powerup.height)
  end
end

function stage.spawnEnemy()
  dragon.spawn()
  bullet.randomSpawn()
end