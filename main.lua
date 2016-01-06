require "player"
require "enemy"
require "conf"
require "bullet"

function love.load()
  stage_load()
  player.load()
  enemies.load()
  bullet.load()
end

function love.keypressed(key)
  player.keypressed(key)
end

function love.update(dt)
  stage_update(dt)
  player.update(dt)
  enemies.update(dt)
  bullet.update(dt)
end

function love.draw()
  stage_draw()
  player.draw()
  enemies.draw()
  bullet.draw()
end