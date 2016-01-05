require "player"
require "enemy"
require "conf"

function love.load()
  stage_load()
  player.load()
  enemies.load()
end

function love.keypressed(key)
  player.keypressed(key)
end

function love.update(dt)
  stage_update(dt)
  player.update(dt)
  enemies.update(dt)
end

function love.draw()
  stage_draw()
  player.draw()
  enemies.draw()
end