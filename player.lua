require "stage"
require "axe"
require "shield"
require "contact"
require "animations"
require "stage"

player = {}
run = 0
local jump = 1
local death = 2
local state = 0
local localGravity = -1100
floor = 615

function player.load()
  player.runSheet = love.graphics.newImage("/Assets/Character/VikingRunningSheet.png")
  player.armSheet = love.graphics.newImage("/Assets/Character/VikingRunningArm.png")
  player.armThrowingSheet = love.graphics.newImage("/Assets/Character/VikingThrowingAxe.png")
  player.axeComp = animComp.newAnim(12,0.1,false)
  player.axeComp.finished = true
  player.armOffset = {x=80,y=33}
  local jumpSheet = love.graphics.newImage("/Assets/Character/VikingJumpingSheet.png")
  --player.jumpSheet = love.graphics.newImage("/Assets/Character/jump.png")
  player.sprites = {}
  player.isJumping = false
  aw = player.runSheet:getWidth()
  ah = player.runSheet:getHeight()
  --w = aw/5
  --h = ah/2
  w = aw/12
  h = ah
  player.scale = 0.7
  player.imgWidth = w*player.scale
  player.imgHeight = h*player.scale
  player.width = player.scale*81--85*player.scale
  player.height = player.scale*153--152*player.scale
  player.sprites[run] = {}
  player.sprites[run].sheet = player.runSheet
  player.sprites[run].quads={}
  player.offset = {x=65,y=33}
  for i=0,11 do
    table.insert(player.sprites[run].quads,love.graphics.newQuad(i*w,0,w,h,aw,ah))
  end
  aw = jumpSheet:getWidth()
  ah = jumpSheet:getHeight()
  w = aw/7
  h = ah/8
  player.sprites[jump] = {}
  player.sprites[jump].quads = {}
  player.sprites[jump].width = w
  player.sprites[jump].height = h
  player.sprites[jump].sheet = jumpSheet
  player.jumpForce = 700
  player.sprites[jump].quads = animations.loadQuads(51,7,w,h,aw,ah)
  --[[for i=1,51 do
    local ind = i-1
    player.sprites[jump].quads[i] = love.graphics.newQuad((ind%7)*w,math.floor(ind/7)*h,w,h,aw,ah)
  end
  ]]
  player.sprites[jump].comp = animComp.newAnim(51,4*player.jumpForce/(-localGravity),false)
  
  local img = love.graphics.newImage("/Assets/Character/deathSheet.png")
  aw = img:getWidth()
  ah = img:getHeight()
  w = aw/7
  h = ah/5
  player.deathTime = 1.3
  player.sprites[death] = {
    sheet = img,
    quads = animations.loadQuads(34,7,w,h,aw,ah),
    aComp = animComp.newAnim(34, player.deathTime, false)
    }
  
  player.jumpKey = "space"
  player.rightKey = "right"
  player.leftKey = "left"
  player.attackKey = "a"
  player.moveDownKey = "down"
  
  player.sprites[run].time = 0.7--1.5/1.4
  player.curr_frame = 1;
  player.timer = 0
  player.velocity = stage.maxV;
  player.xVel = 0
  player.yVel = 0
  player.velForce = 0.4
  player.jumpRotSpeed = 0.6*2*math.pi
  player.jumpRot = 0
  player.invTime = 0
  player.invLimit = 2
  player.blinkTime = 0.1
  axe.load(player.scale)
  shield.load(player)
  --45,124
  player.axeLoc = {x=(-player.offset.x+8)*player.scale,y=(-player.offset.y+80)*player.scale}
  --animations.load()
end

function player.start()
  player.y = floor-player.height
  player.x=0
  state = run
  player.timer = 0
  player.invTime = 0
  shield.equip()
  animComp.restart(player.sprites[death].aComp)
end

function player.quit()
  axe.removeAll()
end

function player.keypressed(key)
  if state==death then
    return
  end
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
  if axe.spawn(player.x+player.axeLoc.x,player.y+player.axeLoc.y) then
    animComp.restart(player.axeComp)
    audio.playPlayerAttack()
  end
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
  if state ~= death then
    player.processMovement(dt)
    player.processJump(dt)
    player.processInvencibility(dt)
    player.processContact(dt)
    if not player.axeComp.finished then
      animComp.update(dt,player.axeComp)
    end
  else
    player.updateDeath(dt)
  end
  axe.update(dt)
  --animations.update(dt)
end

function player.updateDeath(dt)
  local comp = player.sprites[death].aComp
  if not comp.finished then
    animComp.update(dt,comp)
    if player.y+player.height<floor then
      --player.fallVel = player.fallVel - localGravity
      player.y=player.y+player.fallVel*dt
      if player.y+player.height>floor then
        player.y = floor-player.height
      end
    end
    if comp.finished then
      player.dTimer = 2
    end
  else
    player.dTimer = player.dTimer - dt
    if player.dTimer < 0 then
      game.returnToMenu()
    end
  end
end

function player.processContact(dt)
  local c = stage.elements[powerupId]
  for i,v in ipairs(c.list) do
    if contact.isInRectContact(player.x,player.y,player.width,player.height,v.x,v.y,c.width,c.height) then
      powerup.acquire(i,v)
      --shield.reset()
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
      if player.curr_frame > 12 then
        player.curr_frame = 1
      end
    end
  elseif state == jump then
    animComp.update(dt,player.sprites[jump].comp)
  end
end

function player.processJump(dt)
  if player.isJumping then
    player.yVelN = player.yVel + localGravity*dt
    local dist = (player.yVel+player.yVelN)*dt/2
    player.yVel = player.yVelN
    player.y = player.y - dist--player.yVel*dt
    py = player.y
    feet = py+player.height
    pHeight = stage.platformHeight
    if player.y+player.height>floor then
      player.y=floor-player.height
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
  elseif player.y+player.height<floor then --player not jumping
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
      player.die()
    end
    player.invTime = player.invLimit
  end
end

function player.die()
  animations.createSplash(player.x,player.y)
  --player.x = 0
  --player.y = floor-player.height
  player.fallVel = (floor-(player.y+player.height))/(player.deathTime*19.5/34)
  player.xVel = 0
  player.yVel = 0
  --shield.equip()
  state = death
  stage.velocity = 0
  background.velocity = 0
 --player
 audio.enterGameover()
end

function player.draw()
  sprite = player.sprites[state]
  --love.graphics.draw(sprite.sheet, sprite.quads[player.curr_frame], 20,20,0,1,1)
  local go = false
  if state == death then
    love.graphics.draw(sprite.sheet, sprite.quads[sprite.aComp.curr_frame],player.x,player.y,0,player.scale,player.scale,player.offset.x,player.offset.y)
  elseif player.invTime==0 or math.floor((player.invLimit-player.invTime)/player.blinkTime)%2==1 then
    local frame = state==run and player.curr_frame or sprite.comp.curr_frame
    love.graphics.draw(sprite.sheet, sprite.quads[frame],player.x,player.y,0,player.scale,player.scale,player.offset.x,player.offset.y)
    local run = player.sprites[run]
    if not player.axeComp.finished then
      go = true
    else
      love.graphics.draw(player.armSheet, run.quads[player.curr_frame],player.x,player.y,0,player.scale,player.scale,player.armOffset.x,player.armOffset.y)
    end
    shield.draw()
    if go then
      love.graphics.draw(player.armThrowingSheet, run.quads[player.axeComp.curr_frame],player.x,player.y,0,player.scale,player.scale,player.armOffset.x,player.armOffset.y)
    end
  end
  if configuration.debugBoundingBox then
    love.graphics.rectangle("line", player.x,player.y, player.width, player.height)
  end
  axe.draw()
  --animations.draw()
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