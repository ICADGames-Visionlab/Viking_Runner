require "dgBossIdleState"
require "dgFireAtState"
require "dgArcFireAtState"
require "dgFlyAtState"
require "contact"

dragonBoss = {}

local idleStateId=1
local fireAttackStateId=2
local arcFireAttackStateId=3
local flyAttackStateId=4
local isRaged=false
local state

function dragonBoss.load()
  dragonBoss.states = {}
  loadState(idleStateId,dgBossIdleState)
  loadState(fireAttackStateId,dgFireAtState)
  loadState(arcFireAttackStateId,dgArcFireAtState)
  loadState(flyAttackStateId,dgFlyAtState)
  local img = love.graphics.newImage("/Assets/Boss/boss_sheet_fly.png")
  local sWidth = img:getWidth()
  local sHeight = img:getHeight()
  local eachW = sWidth/8
  local eachH = sHeight
  dragonBoss.imgHeight = 260--100
  dragonBoss.scale = dragonBoss.imgHeight/eachH
  dragonBoss.scaleX = dragonBoss.scale
  dragonBoss.scaleY = dragonBoss.scale
  dragonBoss.imgWidth = dragonBoss.scale*eachW
  dragonBoss.width = 1*dragonBoss.imgWidth
  dragonBoss.height = 1*dragonBoss.imgHeight
  dragonBoss.scaleW = 1
  dragonBoss.scaleH = 1
  dragonBoss.maxLife = 30
  local quads = animations.loadQuads(8,8,eachW,eachH,sWidth,sHeight)
  for i=1, 7 do
    quads[i+8] = quads[8-i]
  end
  local fly = {image=img,offset={x=0,y=0},quads=quads,aComp=animComp.newAnim(15,1)}
  dragonBoss.fly = fly
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
  class.load()
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
  love.graphics.draw(sp.image, sp.quads[sp.aComp.curr_frame], dragonBoss.x, dragonBoss.y, 0, dragonBoss.scaleX, dragonBoss.scaleY, sp.offset.x, sp.offset.y)
  state.draw()
  dragonBoss.drawUI()
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
  local id = love.math.random()>0.5 and flyAttackStateId or arcFireAttackStateId
  dragonBoss.changeState(id)
  --dragonBoss.changeState(flyAttackStateId)--arcFireAttackStateId)
end