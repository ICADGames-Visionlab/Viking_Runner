require "dragon"

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
    end
  end
  dragon.update(dt)
end

function enemies.draw()
  for i,v in ipairs(enemies) do
    for j,w in ipairs(v.list) do
      love.graphics.draw(v.spriteSheet,v.quads[w.anim.curr_frame],w.x,282+w.y,0,1,1)
    end
  end
end
