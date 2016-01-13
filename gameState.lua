gameState = {}

function gameState.load(stage)
  gameState.stage = stage
end

function gameState.start()
  
end

function gameState.update(dt)
  local stage = gameState.stage
  if stage.position >= stage.width then
    stage.screen = stage.screen+1
    stage.position = stage.position - stage.width
    w = stage.width
    h = stage.height
    sw = w*0.25
    sh = h*0.05
    platform.generate(w*1.125,stage.platformHeight,sw,sh)
    platform.generate(w*1.625,stage.platformHeight,sw,sh)
    local n = love.math.random()
    if n>0.7 then
      powerup.spawn(w*1.125+(sw-powerup.width)/2,stage.platformHeight-powerup.height,powerup.width,powerup.height)
      n = n-0.7
    end
    if n>0.21 then
      powerup.spawn(w*1.625+(sw-powerup.width)/2,stage.platformHeight-powerup.height,powerup.width,powerup.height)
    end
  end
  if stage.screen == 10 then
    stage.startBoss()
  end
end

function gameState.draw()
  
end

function gameState.newScreen()
  
end