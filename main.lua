require "conf"
require "audio"
require "menu"
require "game"

local state = game

function love.load()
  --menu.load()
  audio.load()
  game.load()
end

function love.keypressed(key)
  state.keypressed(key)
end

function love.mousepressed(x,y,button)
  state.mousepressed(x,y,button)
end

function love.update(dt)
  state.update(dt)
end

function love.startGame(data)
  state = game
  game.prepareBackgrounds(data)
end

function love.draw()
  state.draw()
end