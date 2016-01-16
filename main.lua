require "conf"
require "audio"
require "menu"
require "game"
require "gameover"
require "PUC_Logo/PUC_Logo"

--io.stdout:setvbuf("no")

local gameState = PUC_Logo
local goToState

function love.load()
  menu.load()
  audio.load()
  game.load()
  gameover.load()
  PUC_Logo.load(1,1,1,1,love.returnToMenu)
  audio.play(audio.stageMusic)
  gameState.start()
end

function love.keypressed(key)
  gameState.keypressed(key)
end

function love.mousepressed(x,y,button)
  gameState.mousepressed(x,y,button)
end

function love.update(dt)
  gameState.update(dt)
end

function love.startGame(data)
  print("starting")
  goToState(game,data)
end

function love.returnToMenu()
  goToState(menu,data)
end

function love.gameover()
  goToState(gameover)
end

function goToState(s,data)
  print("goingToState")
  gameState = s
  --gameState.start(data)
  gameState.start(data)
end

function love.draw()
  gameState.draw()
end