require "stage"

player = {}
local run = 0
local state = 0
local localGravity = -600

function player.load()
  player.runSheet = love.graphics.newImage("/Assets/Character/run.png")
  player.sprites = {}
  player.isJumping = false
  aw = player.runSheet:getWidth()
  ah = player.runSheet:getHeight()
  w = aw/5
  h = ah/2
  player.sprites[run] = {}
  player.sprites[run].sheet = player.runSheet
  player.sprites[run].quads = {}
  player.sprites[run].quads = {
    love.graphics.newQuad(0,0,w,h,aw,ah),
    love.graphics.newQuad(w,23,w,h-23,aw,ah),
    love.graphics.newQuad(2*w,34,w,h-34,aw,ah),
    love.graphics.newQuad(3*w,43,w,h-43,aw,ah),
    love.graphics.newQuad(4*w,50,w,h-50,aw,ah),
    love.graphics.newQuad(0,h,w,h,aw,ah),
    love.graphics.newQuad(w,h,w,h,aw,ah),
    love.graphics.newQuad(2*w,h,w,h,aw,ah),
    love.graphics.newQuad(3*w,h,w,h,aw,ah),
    love.graphics.newQuad(4*w,h,w,h,aw,ah)
  }
  --for i=0, 10 do
    --x = i%5
    --y = math.floor(i/5) --* 370/h
    --player.sprites[run].quads[i] = love.graphics.newQuad(x*w,y*h,w,h,aw,ah)
    --player.sprites[run].quads[i] = love.graphics.newQuad(0,0,500,500)
    --love.graphics.newQuad(
  --end
  player.sprites[run].time = 1.5
  player.curr_frame = 1;
  player.timer = 0
  player.velocity = stage.velocity;
  player.yVel = 0
  player.jumpForce = 400
  player.y = 0
end

function player.keypressed(key)
  if key==" " then
    player.jump()
  end
end

function player.jump()
  if not player.isJumping then
    player.isJumping = true
    player.yVel = player.jumpForce
  end
end

function player.update(dt)
  sprite = player.sprites[state]
  tpf = sprite.time / 10
  player.timer = player.timer + dt
  if(player.timer>tpf) then
    player.timer = player.timer - tpf
    player.curr_frame = player.curr_frame+1
    if player.curr_frame > 10 then
      player.curr_frame = 1
    end
  end
  if player.isJumping then
    player.yVel = player.yVel + localGravity*dt
    player.y = player.y + player.yVel*dt
    if player.y<0 then
      player.y=0
      player.isJumping = false
    end
  end
end

function player.draw()
  sprite = player.sprites[state]
  --love.graphics.draw(sprite.sheet, sprite.quads[player.curr_frame], 20,20,0,1,1)
  love.graphics.draw(sprite.sheet, sprite.quads[player.curr_frame],0,378-player.y,0,0.35,0.35)
end