require "player"
require "enemy"
require "conf"

gotKey = false

function love.load()
  stage_load()
  player.load()
end

function love.keypressed(key)
  player.keypressed(key)
  print("space")
  gotKey = true
end

function love.update(dt)
  stage_update(dt)
  player.update(dt)
end

function love.draw()
  stage_draw()
  player.draw()
  if player.isJumping then
    gotKey = false
    love.graphics.print("SPACE",0,0)
  end
end