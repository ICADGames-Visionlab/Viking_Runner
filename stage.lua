require "platform"
stage = {}
platformId = 1

function stage.load()
  stage.sprite = love.graphics.newImage("/Assets/Background/test.png")
  stage.width = love.graphics.getWidth()
  stage.height = love.graphics.getHeight()
  stage.scaleX = stage.width / stage.sprite:getWidth()
  stage.scaleY = stage.height / stage.sprite:getHeight()
  stage.velocity = stage.width/3
  stage.position = 0;
  stage.elements = {}
  stage.platformHeight = 0.55*stage.height+20
  loadElement(platformId, platform)
end

function loadElement(id, class)
  stage.elements[id] = class
  class.load()
end

function stage.update(dt)
  local mov = stage.velocity*dt
  stage.position = stage.position + mov
  if stage.position >= stage.width then
    stage.position = stage.position - stage.width
    w = stage.width
    h = stage.height
    sw = w*0.25
    sh = h*0.05
    platform.generate(w*1.125,stage.platformHeight,sw,sh)
    platform.generate(w*1.625,stage.platformHeight,sw,sh)
  end
  for i,v in ipairs(stage.elements) do
    for j,w in ipairs(v.list) do
      w.x = w.x - mov
      if(w.x+w.width<0) then
        table.remove(v.list,j)
      end
    end
  end
end

function stage.draw()
  point = -stage.position
  love.graphics.draw(stage.sprite,point,0,0,stage.scaleX,stage.scaleY)
  love.graphics.draw(stage.sprite,point+stage.width,0,0,stage.scaleX,stage.scaleY)
  --love.graphics.draw(stage.sprite,0,0,0,love.graphics.getWidth(),love.graphics.getHeight())
  love.graphics.setColor(0,0,0)
  for i,v in ipairs(stage.elements) do
    for j,w in ipairs(v.list) do
      love.graphics.rectangle("fill", w.x,w.y,w.width,w.height)
    end
  end
  love.graphics.setColor(255,255,255,255)
end