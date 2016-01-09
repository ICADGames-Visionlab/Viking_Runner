require "stage"
require "player"
require "enemy"
require "bullet"
require "animations"

game = {}

function game.load()
  stage.load()
  player.load()
  enemies.load()
  bullet.load()
  --dialog.load()
  --dText = dialog.newDialogText("Hey man, come right here\nim gonna punch you in the face",0,0)
  game.startTime = 2
  game.startAnim = animComp.newAnim(12,player.sprites[run].time)
  animations.load()
end

function game.keypressed(key)
  if not(game.startTime>0) then
    player.keypressed(key)
  end
end

function game.mousepressed(x,y,button)
end

function game.update(dt)
  stage.update(dt)
  if game.startTime>0 then game.startUpdate(dt) else player.update(dt) end
  enemies.update(dt)
  bullet.update(dt)
  --dialog.updateText(dt,dText)
  animations.update(dt)
end

function game.draw()
  stage.draw()
  if game.startTime>0 then game.startDraw() else player.draw() end
  enemies.draw()
  bullet.draw()
  --dialog.drawText(dText)
  animations.draw()
end

function game.startUpdate(dt)
  game.startTime = game.startTime-dt
  if game.startTime<0 then
    game.startTime = 0
    game.start()
  end
  player.x = -player.imgWidth+(1-game.startTime/2)*2*player.imgHeight
  animComp.update(dt,game.startAnim)
end

function game.startDraw()
  local sprite = player.sprites[run]
  love.graphics.draw(sprite.sheet, sprite.quads[game.startAnim.curr_frame],player.x,player.y,0,player.scale,player.scale,player.offset.x,player.offset.y)
  shield.draw()
end

function game.prepareBackgrounds(data)
  stage.prepareBackgrounds(data)
  player.x = -player.width
end

function game.startAnimation()
end

function game.start()
  stage.start()
end