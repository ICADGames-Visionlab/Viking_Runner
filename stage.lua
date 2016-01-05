stage = {}

function stage_load()
  stage.sprite = love.graphics.newImage("/Assets/Background/test.png")
  stage.width = love.graphics.getWidth()
  stage.height = love.graphics.getHeight()
  stage.scaleX = stage.width / stage.sprite:getWidth()
  stage.scaleY = stage.height / stage.sprite:getHeight()
  stage.velocity = stage.width/3
  stage.position = 0;
end

function stage_update(dt)
  stage.position = stage.position + stage.velocity*dt
end

function stage_draw()
  point = -(stage.position % stage.width)
  love.graphics.draw(stage.sprite,point,0,0,stage.scaleX,stage.scaleY)
  love.graphics.draw(stage.sprite,point+stage.width,0,0,stage.scaleX,stage.scaleY)
  --love.graphics.draw(stage.sprite,0,0,0,love.graphics.getWidth(),love.graphics.getHeight())
  
end