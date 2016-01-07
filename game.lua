require "player"
require "enemy"
require "bullet"

game = {}

function game.load()
  stage.load()
  player.load()
  enemies.load()
  bullet.load()
  --dialog.load()
  --dText = dialog.newDialogText("Hey man, come right here\nim gonna punch you in the face",0,0)
end

function game.keypressed(key)
  player.keypressed(key)
end
function game.mousepressed(x,y,button)
end

function game.update(dt)
  stage.update(dt)
  player.update(dt)
  enemies.update(dt)
  bullet.update(dt)
  --dialog.updateText(dt,dText)
end

function game.draw()
  stage.draw()
  player.draw()
  enemies.draw()
  bullet.draw()
  --dialog.drawText(dText)
end

function game.prepareBackgrounds(data)
  stage.prepareBackgrounds(data)
end