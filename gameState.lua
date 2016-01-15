gameState = {}

function gameState.load(stage)
  gameState.stage = stage
end

function gameState.start()
  
end

function gameState.update(dt, changeScreen)
  local stage = gameState.stage
  if changeScreen then
    stage.screen = stage.screen+1
    stage.generatePlatforms(true)
  end
  if stage.screen == 2 then
    stage.startBoss()
  end
end

function gameState.draw()
  
end

function gameState.newScreen()
  
end