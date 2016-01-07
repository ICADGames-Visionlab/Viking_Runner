require "conf"
require "menu"
require "game"

local state = game

function love.load()
  --menu.load()
  game.load()
end

function love.keypressed(key)
  state.keypressed(key)
end

function love.update(dt)
  state.update(dt)
end

function love.draw()
  state.draw()
end