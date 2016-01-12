require "dragon"
require "player"

enemies = {}
dragonId = 1

function enemies.load()
  loadEnemy(dragonId, dragon)
end

function loadEnemy(id, class)
  enemies[id] = class
  class.load()
end

function enemies.quit()
  for i,v in ipairs(enemies) do
    table.removeAll(v.list)
  end
end

function enemies.update(dt)
  for i,v in ipairs(enemies) do
    for j,w in ipairs(v.list) do
      animComp.update(dt, w.anim)
      enemies.collision(w, v, player)
    end
  end
  for i,v in ipairs(enemies) do
    v.update(dt)
  end
end

function enemies.draw()
  --love.graphics.setColor(70,70,150)
  for i,v in ipairs(enemies) do
    for j,w in ipairs(v.list) do
      love.graphics.draw(v.spriteSheet,v.quads[w.anim.curr_frame],w.x,302+w.y,0,v.scale,v.scale)
      if configuration.debugBoundingBox then
        love.graphics.rectangle("line",w.x,290+w.y,v.width,v.height)
      end
    end
  end
  --love.graphics.setColor(255,255,255)
end

function enemies.collision(enemy, class, player)
  if (player.invTime>0) then return false end
  if(player.x>enemy.x) then compx=class.width else compx=player.width end
  py = player.y
  ey = 290 + enemy.y
  if(py>ey) then compy=class.height else compy=player.height
  end
	if (math.abs(player.x - enemy.x)<= compx and
	math.abs(py - ey)<= compy) then--and player.invTime==0 then
		player.reset()
  end
end