require "player"
require "enemy"
require "conf"
require "bullet"

function love.load()
  stage.load()
  player.load()
  enemies.load()
  bullet.load()
end

function love.keypressed(key)
  player.keypressed(key)
end

function love.update(dt)
  stage.update(dt)
  player.update(dt)
  enemies.update(dt)
  bullet.update(dt)
end

function love.draw()
  stage.draw()
  player.draw()
  enemies.draw()
  bullet.draw()
end