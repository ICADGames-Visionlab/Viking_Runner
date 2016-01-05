require "dragon"
require "player"

enemies = {}

function enemies.load()
  enemies[1] = dragon
  for i,v in ipairs(enemies) do
    v.load()
  end
end

function enemies.update(dt)
  for i,v in ipairs(enemies) do
    for j,w in ipairs(v.list) do
      animComp.update(dt, w.anim)
      enemies.collision(w, v, player)
    end
  end
  dragon.update(dt)
end

function enemies.draw()
  for i,v in ipairs(enemies) do
    for j,w in ipairs(v.list) do
      love.graphics.draw(v.spriteSheet,v.quads[w.anim.curr_frame],w.x,282+w.y,0,1,1)
      love.graphics.rectangle("line",w.x,282+w.y,72,72)
    end
  end
end

function enemies.collision(enemy, class, player)
  if(player.x>enemy.x) then compx=class.width else compx=player.width end
  py = floor - player.y
  ey = 282 + enemy.y
  if(py>ey) then compy=class.height else compy=player.height end
	if (math.abs(player.x - enemy.x)<= compx and
	math.abs(py - ey)<= compy) then--and player.invTime==0 then
		player.x=0
		player.y=0
    --[[
    player.life = player.life-1
    if player.life==0 then
      player.dead=true
      player.bombQuant=0
      if checkdead() then
        menu.tipo=1
        menu.show=true
        menu.status=true
        endTable(boss.shadow)
      end
    else
      player.invTime = invTime
    end
    ]]
	end
 end