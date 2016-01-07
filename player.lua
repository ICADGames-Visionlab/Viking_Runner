require "stage"
require "axe"
require "shield"
require "contact"

player = {}
local run = 0
local jump = 1
local state = 0
local localGravity = -1100
--floor = 378
floor = 478

function player.load()
  player.runSheet = love.graphics.newImage("/Assets/Character/run.png")
  player.jumpSheet = love.graphics.newImage("/Assets/Character/jump.png")
  player.sprites = {}
  player.isJumping = false
  aw = player.runSheet:getWidth()
  ah = player.runSheet:getHeight()
  w = aw/5
  h = ah/2
  player.width = w*0.35
  player.height = h*0.35
  player.sprites[run] = {}
  player.sprites[run].sheet = player.runSheet
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
  aw = player.jumpSheet:getWidth()
  ah = player.jumpSheet:getHeight()
  w = aw/4
  h = ah/2
  player.sprites[jump] = {}
  player.sprites[jump].quads = {}
  player.sprites[jump].width = w
  player.sprites[jump].height = h
  player.sprites[jump].sheet = player.jumpSheet
  for i=1,8 do
    local ind = i-1
    player.sprites[jump].quads[i] = love.graphics.newQuad((ind%4)*w,math.floor(ind/4)*h,w,h,aw,ah)
  end
  player.sprites[jump].comp = animComp.newAnim(8,0.6)
  
  player.jumpKey = " "
  player.rightKey = "right"
  player.leftKey = "left"
  player.attackKey = "a"
  player.moveDownKey = "down"
  --for i=0, 10 do
    --x = i%5
    --y = math.floor(i/5) --* 370/h
    --player.sprites[run].quads[i] = love.graphics.newQuad(x*w,y*h,w,h,aw,ah)
    --player.sprites[run].quads[i] = love.graphics.newQuad(0,0,500,500)
    --love.graphics.newQuad(
  --end
  player.sprites[run].time = 1--1.5/1.4
  player.curr_frame = 1;
  player.timer = 0
  player.velocity = stage.velocity;
  player.xVel = 0
  player.yVel = 0
  player.velForce = 0.4
  player.jumpForce = 650
  player.jumpRotSpeed = 0.6*2*math.pi
  player.jumpRot = 0
  player.y = floor
  player.x = 0
  player.hasShield = false
  player.invTime = 0
  player.invLimit = 2
  player.blinkTime = 0.1
  axe.load()
  shield.load(player)
  audio.playPlayerRun()
end

function player.keypressed(key)
  if key==player.jumpKey then
    player.jump()
  elseif key==player.attackKey then
    player.attack()
  elseif key==player.moveDownKey then
    player.moveDown()
  end
end

function player.jump()
  if not player.isJumping then
    audio.playPlayerJump()
    player.isJumping = true
    player.yVel = player.jumpForce
    animComp.restart(player.sprites[jump].comp)
    player.jumpRot = 0
    state = jump
  end
end

function player.attack()
  axe.spawn(player.x,player.y)
end

function player.moveDown()
  if not player.isJumping and player.y>0 then
    player.fall()
  end
end

function player.fall()
  player.y = player.y+1
  player.isJumping = true
  player.yVel = -40
  animComp.restart(player.sprites[jump].comp)
  player.jumpRot = 0
  state = jump
end

function player.reachFloor()
  player.isJumping = false
  state = run
  audio.playPlayerRun()
end

function player.update(dt)
  player.processMovement(dt)
  player.processJump(dt)
  player.processInvencibility(dt)
  player.processContact(dt)
  axe.update(dt)
end

function player.processContact(dt)
  local c = stage.elements[powerupId]
  for i,v in ipairs(c.list) do
    if contact.isInRectContact(player.x,player.y,player.width,player.height,v.x,v.y,c.width,c.height) then
      powerup.acquire(i)
      shield.reset()
    end
  end
end

function player.processInvencibility(dt)
  if player.invTime>0 then
    player.invTime = player.invTime - dt
    if player.invTime < 0 then
      player.invTime = 0
    end
  end
end

function player.processMovement(dt)
  if love.keyboard.isDown(player.leftKey) then
    player.xVel = 1-player.velForce
  elseif love.keyboard.isDown(player.rightKey) then
      player.xVel = 1+player.velForce
  else
    player.xVel = 1
  end
  if player.xVel ~= 1 then
    player.x = player.x + player.velocity*(player.xVel - 1)*dt
    if player.x < 0 then
      player.x = 0
      player.xVel = 1
    elseif player.x + player.width > stage.width then
      player.x = stage.width - player.width
      player.xVel = 1
    end
  end
  if state == run then
    sprite = player.sprites[state]
    tpf = sprite.time/player.xVel / 10
    player.timer = player.timer + dt
    if(player.timer>tpf) then
      player.timer = player.timer - tpf
      player.curr_frame = player.curr_frame+1
      if player.curr_frame > 10 then
        player.curr_frame = 1
      end
    end
  end
end

function player.processJump(dt)
  if player.isJumping then
    player.yVel = player.yVel + localGravity*dt
    player.y = player.y - player.yVel*dt
    py = player.y
    feet = py+player.height
    pHeight = stage.platformHeight+20
    if player.y>floor then
      player.y=floor
      player.reachFloor()
    elseif player.yVel<0 and feet + player.yVel*dt<=pHeight then
      if feet>pHeight then
        local plats = stage.elements[platformId].list
        for i,v in ipairs(plats) do
          --if math.abs(center-(v.x+v.width)) < (player.width+v.width)/2 then
          if inContact(player,v) then
            player.y = pHeight - player.height
            player.standingOn = v
            player.reachFloor()
          end
        end
      end
    end
  elseif player.y<floor then --player not jumping
    local v = player.standingOn
    --if math.abs(player.x+(player.width-v.width)/2-v.x)>(player.width*0.7+v.width)/2 then
    if not inContact(player,player.standingOn) then
      player.fall()
    end
  end
  if player.isJumping then
    animComp.update(dt,player.sprites[jump].comp)
    player.jumpRot = player.jumpRot + player.jumpRotSpeed*dt
  end
end

function player.gotHit()
  shield.hit()
end

function player.reset()
  if player.invTime==0 then
    if shield.exists() then
      shield.hit()
    else
      player.x = 0
      player.y = floor
      player.xVel = 0
      player.yVel = 0
      shield.equip()
    end
    player.invTime = player.invLimit
  end
end

function player.draw()
  sprite = player.sprites[state]
  --love.graphics.draw(sprite.sheet, sprite.quads[player.curr_frame], 20,20,0,1,1)
  
  if player.invTime==0 or math.floor((player.invLimit-player.invTime)/player.blinkTime)%2==1 then
    if not player.isJumping then
      love.graphics.draw(sprite.sheet, sprite.quads[player.curr_frame],player.x,player.y,0,0.35,0.35)
    else
      local s = player.width/sprite.width
      love.graphics.draw(sprite.sheet, sprite.quads[sprite.comp.curr_frame],player.x,player.y,0,s,s)
    end
  end
  if configuration.debugBoundingBox then
    love.graphics.rectangle("line", player.x,player.y, player.width, player.height)
  end
  axe.draw()
  shield.draw()
end

function inContact(p,v)
  if p.x<v.x then
    if p.x+p.width>v.x then
      return true
    end
  elseif p.x<v.x+v.width then
    return true
  end
  return false
end