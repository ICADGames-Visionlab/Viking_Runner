require "conf"
require "audio"
require "Screens/menu"
require "Game/game"
require "Screens/gameover"
--require "PUC_Logo/PUC_Logo"
require "RPG_Full_Logo/RPG_Logo"
require "inputData"

--io.stdout:setvbuf("no")

local gameState = RPG_Logo--PUC_Logo
local goToState

function love.load()
  menu.load()
  audio.load()
  game.load()
  gameover.load()
  RPG_Logo.load(1.2,1.5,1.2,love.returnToMenu)--PUC_Logo.load(1,1,1,1,love.returnToMenu)
  audio.play(audio.stageMusic)
  gameState.start()
  inputData.start()
end

function love.keypressed(key)
  gameState.keypressed(key)
end

function love.gamepadpressed(joy,but)
  if gameState.gamepadpressed ~= nil then gameState.gamepadpressed(joy,but) end
end

function love.mousepressed(x,y,button)
  gameState.mousepressed(x,y,button)
end

function love.update(dt)
  gameState.update(dt)
end

function love.startGame(data)
  goToState(game,data)
end

function love.returnToMenu()
  goToState(menu,data)
end

function love.gameover()
  goToState(gameover)
end

function goToState(s,data)
  gameState = s
  --gameState.start(data)
  gameState.start(data)
end

function love.draw()
  gameState.draw()
end