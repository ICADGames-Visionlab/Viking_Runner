

--[[ 

Requires vector of maps V with each map having:
  - image: The image of the plane
  - speed: Speed of the moving map (tiles per second)

The order is important, the deepest maps first
  
  example code:
  
  (GLOBAL)
  local parallaxBackground
  
  (LOAD)
  local planoDeep = {
    love.graphics.newImage("planoDeep.png"),
    speed = love.graphics.getWidth()/2
  }
  local planoBackground = {
    love.graphics.newImage("planoBackground.png"),
    speed = love.graphics.getWidth()/5
  }
  parallaxBackground = {planoDeep, planoBackground}
  
  (UPDATE)
  -- IF YOU WANT TO MOVE WITH THE DEFAULT SPEED, DOESN NOT NEED THE PARAMETER mov
  parallax_update(dt, parallaxBackground)
  -- MOV is to change somehow the SPEED, for example, make the parallax move 50% slower -> mov = 0.5
  parallax_update(dt, p, 0.5)
  
  (DRAW)
  parallax_draw(parallaxBackground)
]]

local updateWithVel

function parallax_new(listOfMaps)
  for i,v in ipairs(listOfMaps) do
    v.width = v.image:getWidth()
  end
  return {list = listOfMaps}
end

function parallax_update(dt, p, mov)
  if mov == nil then move = 1 end
  for i,v in ipairs(p.list) do
    v.position = v.position + v.speed*mov*dt
    if v.position > v.width then
      v.position = v.position%v.width
    end
  end
end

function parallax_draw(p)
  for i,v in ipairs(p.list) do
    local pos = v.position
    love.graphics.draw(v.image, -pos, 0)
    love.graphics.draw(v.image, v.width-pos, 0)
  end
end