dgSummonState = {}
local timer
local time = 0.5

function dgSummonState.load(dragon)
  dgSummonState.dragon = dragon
end

function dgSummonState.start()
  timer = time
end

function dgSummonState.update(dt)
  timer = timer - dt
  if timer < 0 then
    dragon.doubleSpawn()
    dgSummonState.dragon.endState()
  end
end

function dgSummonState.draw()
  
end