shield = {}

function shield.load(player)
  local img = love.graphics.newImage("/Assets/Character/shield.png")
  shield.img=img
  shield.colors = {{255,0,0,190},{255,255,0,190},{255,255,255,255}}
  shield.owner = player
  shield.x = player.width*0.6
  shield.y = player.height*0.4
  shield.width = player.width*0.4
  shield.height = 0.4*player.height
  shield.maxLife = 3
  shield.reset()
end

function shield.equip()
  shield.reset()
end
function shield.exists()
  return shield.life>0
end
function shield.update(dt)
  
end

function shield.draw(px,py)
  if shield.life>0 then
    local p = shield.owner
    love.graphics.setColor(shield.colors[shield.life])
    --if not p.isJumping then
      love.graphics.draw(shield.img,p.x,p.y,0,p.scale,p.scale,p.offset.x,p.offset.y)
    --end
    --love.graphics.rectangle("fill",p.x+shield.x,p.y+shield.y,shield.width,shield.height)
    love.graphics.setColor(255,255,255)
  end
end

function shield.hit()
  if shield.life>0 then
    shield.life = shield.life-1
  end
  audio.playShield()
end

function shield.reset()
  shield.life = shield.maxLife
end