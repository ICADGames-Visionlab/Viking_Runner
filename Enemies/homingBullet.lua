homingBullet = {}
local angleSpeed = math.pi/4

function homingBullet.register(bullet)
end

function homingBullet.update(dt, v,class)
  local dx = player.x+player.width/2-(v.x+class.width)
  local dy = -(player.y+player.height/2-(v.y+class.height))
  local pAngle = math.atan2(dy,dx)
  local dist = angleDist(v.angle,pAngle)
  local mov = angleSpeed*dt
  if math.abs(dist) < mov then
    v.angle = pAngle
  else
    v.angle = v.angle + math.sign(dist)*mov
  end
  v.vel.x = math.cos(v.angle)*class.velocity
  v.vel.y = -math.sin(v.angle)*class.velocity
end

function angleDist(from,to)
  local dist = to-from
  local s = math.sign(dist)
  if dist*s <= math.pi then
    return dist
  else
    return -math.pi*2*s + dist
  end
end

function math.sign(v)
  if v>0 then return 1 else return -1 end
end