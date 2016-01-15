dgFlyAtState = {}
local timeToMove = 1.2
local timeToAttack = 1.2
local timeToShow = 1
local timeout = 0.5
local isTimingout
local maxMoves = 6
local nMoves = 5
local invert = 1
local ind

local step = {start=1,move=2,show=3}
local curr_step
local startStart, startMove, startShow
local startUpdate, moveUpdate, showUpdate
local moveTo
local vel
local timer
local isGoing
local curr_move

function dgFlyAtState.load()
  dgFlyAtState.lanes = {200,400}
end

function dgFlyAtState.start()
  dragonBoss.curr_sprite = dragonBoss.rasante
  animComp.restart(dragonBoss.curr_sprite.aComp)
  startStart()
end

function dgFlyAtState.update(dt)
  if curr_step == step.start then
    startUpdate(dt)
  elseif curr_step == step.move then
    moveUpdate(dt)
  else
    showUpdate(dt)
  end
end

function startStart()
  curr_step = step.start
  ind = love.math.random()>0.5 and 1 or 2
  local place = dgFlyAtState.lanes[ind]
  moveTo = place
  vel = (moveTo-dragonBoss.y)/timeToMove
  timer = timeToMove
end

function startUpdate(dt)
  dragonBoss.y = dragonBoss.y+vel*dt
  timer = timer - dt
  if timer < 0 then
    dragonBoss.y = moveTo
    startMove()
  end
end

function startMove()
  curr_step = step.move
  curr_move = 1
  invert = 1
  beginMove()
end

function beginMove()
  if invert == 1 then
    moveTo = -dragonBoss.imgWidth
  else
    moveTo = love.graphics.getWidth()+dragonBoss.imgWidth
  end
  timer = timeToAttack
  vel = (moveTo - dragonBoss.x)/timeToAttack
  isTimingout = false
end

function moveUpdate(dt)
  if isTimingout then
    timer = timer-dt
    if timer<0 then
      if curr_move < nMoves then
        curr_move = curr_move + 1
        invert = -invert
        dragonBoss.scaleX = invert*dragonBoss.scale
        ind = ind%(#dgFlyAtState.lanes)+1
        dragonBoss.y = dgFlyAtState.lanes[ind]
        beginMove()
      else
        startShow()
      end
    end
  else
    dragonBoss.x = dragonBoss.x + vel*dt
    timer = timer-dt
    if timer<0 then
      dragonBoss.x = moveTo
      timer = timeout
      isTimingout = true
    end
  end
end

function startShow()
  curr_step = step.show
  dragonBoss.curr_sprite = dragonBoss.fly
  local w = love.graphics.getWidth()
  dragonBoss.x = w+dragonBoss.imgWidth
  moveTo = w-dragonBoss.imgWidth
  vel = (moveTo - dragonBoss.x)/timeToShow
  timer = timeToShow
  dragonBoss.scaleX = dragonBoss.scale
end

function showUpdate(dt)
  dragonBoss.x = dragonBoss.x+vel*dt
  timer = timer-dt
  if timer<0 then
    dragonBoss.x = moveTo
    dragonBoss.endState()
  end
end

function dgFlyAtState.draw()
  
end