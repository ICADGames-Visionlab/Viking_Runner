require "dgBossIdleState"
require "dgFireAtState"
require "dgArcFireAtState"
require "dgFlyAtState"
require "dgBossDeathState"
require "dgSummonState"
require "contact"

dragonBoss = {}

local idleStateId=1
local fireAttackStateId=2
local arcFireAttackStateId=3
local flyAttackStateId=4
local deathStateId=5
local summonStateId=6
local isRaged=false
local state

function dragonBoss.load()
  dragonBoss.states = {}
  loadState(idleStateId,dgBossIdleState)
  loadState(fireAttackStateId,dgFireAtState)
  loadState(arcFireAttackStateId,dgArcFireAtState)
  loadState(flyAttackStateId,dgFlyAtState)
  loadState(deathStateId,dgBossDeathState)
  loadState(summonStateId,dgSummonState)
  local img = love.graphics.newImage("/Assets/Boss/boss_sheet_fly.png")
  local sWidth = img:getWidth()
  local sHeight = img:getHeight()
  local eachW = sWidth/8
  local eachH = sHeight
  dragonBoss.imgHeight = 280--100
  dragonBoss.scale = dragonBoss.imgHeight/eachH
  dragonBoss.scaleX = dragonBoss.scale
  dragonBoss.scaleY = dragonBoss.scale
  dragonBoss.imgWidth = dragonBoss.scale*eachW
  local hitBoxScale = {x=1,y=1}
  dragonBoss.width = hitBoxScale.x*dragonBoss.imgWidth
  dragonBoss.orWidth = hitBoxScale.x*eachW
  dragonBoss.height = hitBoxScale.y*dragonBoss.imgHeight
  dragonBoss.orHeight = hitBoxScale.y*eachH
  dragonBoss.scaleW = 1
  dragonBoss.scaleH = 1
  dragonBoss.maxLife = 30
  local quads = animations.loadQuads(8,8,eachW,eachH,sWidth,sHeight)
  for i=1, 8 do
    quads[i+8] = quads[9-i]
  end
  local fly = {image=img,offset={x=0,y=0},quads=quads,aComp=animComp.newAnim(16,1)}
  local dImg = love.graphics.newImage("/Assets/Boss/boss_dead.png")
  local dW = dImg:getWidth()
  local dH = dImg:getHeight()
  local uniQuad = love.graphics.newQuad(0,0,dW,dH,dW,dH)
  local death = {image=love.graphics.newImage("/Assets/Boss/boss_dead.png"),offset=fly.offset,quads={uniQuad},aComp=animComp.newAnim(1,50)}
  dragonBoss.fly = fly
  dragonBoss.death = death
  img = love.graphics.newImage("/Assets/Boss/boss_sheet_rasante.png")
  sWidth = img:getWidth()
  sHeight = img:getHeight()
  eachW = sWidth/8
  eachH = sHeight
  dragonBoss.rasante = {image = img, offset={x=0,y=0},quads=animations.loadQuads(8,8,eachW,eachH,sWidth,sHeight),aComp=animComp.newAnim(8,1,false)}
end


function dragonBoss.start(player)
  dragonBoss.isRaged = false
  dragonBoss.target = player
  dragonBoss.life = dragonBoss.maxLife
  dragonBoss.x=love.graphics.getWidth()-dragonBoss.imgWidth
  dragonBoss.y=(love.graphics.getHeight()-dragonBoss.imgHeight)/2
  dragonBoss.changeState(idleStateId,6)
  audio.playBossMusic()
  dragonBoss.life = dragonBoss.maxLife
end

function loadState(id,class)
  dragonBoss.states[id] = class
  class.load(dragonBoss)
end

function dragonBoss.update(dt, changeScreen)
  if changeScreen then
    stage.generatePlatforms(true)
  end
  state.update(dt)
  animComp.update(dt,dragonBoss.curr_sprite.aComp)
  dragonBoss.contact()
end

function dragonBoss.contact()
  local target = dragonBoss.target
  if contact.isInRectContact(target.x,target.y,target.width,target.height,dragonBoss.x,dragonBoss.y,dragonBoss.width,dragonBoss.height) then
    target.reset()
  end
  for i,v in ipairs(axe.list) do
    if contact.isInRectContact(v.x,v.y,axe.width,axe.height,dragonBoss.x,dragonBoss.y,dragonBoss.width,dragonBoss.height) then
      animations.createSplash(v.x,v.y)
      table.remove(axe.list,i)
      dragonBoss.life = dragonBoss.life-1
      if dragonBoss.life<=dragonBoss.maxLife/2 then
        dragonBoss.isRaged = true
        if dragonBoss.life==0 then
          dragonBoss.die()
        end
      end
    end
  end
end

function dragonBoss.changeState(toStateId, time)
  state = dragonBoss.states[toStateId]
  state.start(dragonBoss, time)
end

function dragonBoss.draw()
  local sp = dragonBoss.curr_sprite
  love.graphics.draw(sp.image, sp.quads[sp.aComp.curr_frame], dragonBoss.x+dragonBoss.width/2, dragonBoss.y+dragonBoss.height/2, 0, dragonBoss.scaleX, dragonBoss.scaleY, sp.offset.x+dragonBoss.orWidth/2, sp.offset.y+dragonBoss.orHeight/2)
  state.draw()
  dragonBoss.drawUI()
  if configuration.debugBoundingBox then
    love.graphics.rectangle("line",dragonBoss.x,dragonBoss.y,dragonBoss.width,dragonBoss.height)
  end
end

function dragonBoss.drawUI()
  local w = love.graphics.getWidth()/2
  love.graphics.setColor(100,0,0,120)
  love.graphics.rectangle("fill",0,0,w,30)
  love.graphics.setColor(255,0,0,120)
  love.graphics.rectangle("fill",0,0,dragonBoss.life/dragonBoss.maxLife*w,30)
  love.graphics.setColor(255,255,255)
  love.graphics.setNewFont(30)
  love.graphics.print("Dragon Boss",0,30)
end

function dragonBoss.endState()
  dragonBoss.changeState(idleStateId,6)
end

function dragonBoss.newActionState()
  local chance = 1/3
  local r = love.math.random()
  local id = r>2*chance and flyAttackStateId or r>chance and arcFireAttackStateId or deathStateId
  dragonBoss.changeState(id)
  --dragonBoss.changeState(flyAttackStateId)--arcFireAttackStateId)
end

function dragonBoss.die()
  dragonBoss.changeState(deathStateId)
end