require "dgBossIdleState"
require "dgFireAtState"
require "dgArcFireAtState"
require "contact"

dragonBoss = {}

local idleStateId=1
local fireAttackStateId=2
local arcFireAttackStateId=3
local isRaged=false
local animationComponent
local state

function dragonBoss.load()
  dragonBoss.states = {}
  loadState(idleStateId,dgBossIdleState)
  loadState(fireAttackStateId,dgFireAtState)
  loadState(arcFireAttackStateId,dgArcFireAtState)
  changeState(idleStateId)
  dragonBoss.x=0
  dragonBoss.y=0
  dragonBoss.width = 100
  dragonBoss.height = 100
  dragonBoss.scaleW = 1
  dragonBoss.scaleH = 1
  dragonBoss.life = 30
  dragonBoxx.maxLife = 30
end

function dragonBoss.state(player)
  dragonBoss.target = player
end

function loadState(id,class)
  dragonBoss.states[id] = class
  class.load()
end

function dragonBoss.update(dt)
  state.update(dt)
  animComp.update(dt,animationComponent)
  dragonBoss.contact()
end

function dragonBoss.contact()
  if contact.isInRectContact(target.x,target.y,target.width,dragonBoss.x,dragonBoss.y,dragonBoss.width,dragonBoss.height) then
    target.reset()
  end
end

function changeState(toStateId)
  state = dragonBoss.states[toStateId]
  animationComponent = animComp.newAnim(state.qFrames,state.time)
end

function dragonBoss.draw()
  love.graphics.setColor(255,50,50)
  love.graphics.rectangle("fill",50,20,(love.graphics.getWidth()-100)*dragonBoss.life/dragonBoss.maxLife,60)
  love.graphics.setColor(255,255,255)
  love.graphics.draw(state.sheet,state.quads[animationComponent.curr_frame],dragonBoss.x,dragonBoss.y)
end

function dragonBoss.endState()
end