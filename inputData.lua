local keyboard = {up='up',left='left',right='right',down='down',confirm='enter',attack='a',jump='space'}
function keyboard.isPressing(actionKey)
  return love.keyboard.isDown(keyboard[actionKey])
end
function keyboard.getDirection()
  local x,y
  if love.keyboard.isDown(keyboard.down) then y=1
  elseif love.keyboard.isDown(keyboard.up) then y=-1
  else y=0 end
  if love.keyboard.isDown(keyboard.right) then x=1
  elseif love.keyboard.isDown(keyboard.left) then x=-1
  else x=0 end
  return {x=x,y=y}
end

local joystick = {up='dpup',left='dpleft',right='dpright',down='dpdown',confirm='start',attack='x',jump='a'}
function joystick.isPressing(actionKey,axis)
  return inputData.joy:isGamepadDown(joystick[actionKey])
end
function joystick.getDirection()
  local x,y = inputData.joy:getAxis(1),inputData.joy:getAxis(2)
  if x>=0.4 then x=1 elseif x<=-0.4 then x=-1 else x=0 end
  if y>=0.4 then y=1 elseif y<=-0.4 then y=-1 else y=0 end
  return {x=x,y=y}
end

inputData = {
  curr = nil,
  joy = nil
}

function inputData.start()
  inputData.joy = love.joystick.getJoysticks()[1]
  if inputData.joy == nil then inputData.curr = keyboard else inputData.curr = joystick end
end

function inputData.isPressing(actionKey)
  return inputData.curr.isPressing(actionKey)
end

function inputData.getDirection()
  return inputData.curr.getDirection()
end