gameState = {}

local first

function gameState.load(stage)
  gameState.stage = stage
end

function gameState.start()
  first = true
end

function gameState.update(dt, changeScreen)
  local stage = gameState.stage
  if changeScreen then
  if first then
    first = false
  else
    stage.screen = stage.screen+1
    stage.generatePlatforms(true)
    stage.spawnEnemy()
  end
  end
  if stage.screen == 10 then
    gameState.quit()
    stage.startBoss()
  end
end

function gameState.quit()
  enemies.quit()
  bullet.quit()
end

function gameState.draw()
end

function gameState.newScreen()
  
end