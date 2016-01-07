contact = {}

--function contact.isInRectContact(a,b,ca,cb)
--  return contact.isInRectXRange(a,b,ca,cb) and contact.isInRectYRange(a,b,ca,cb)
--end

function contact.isInRectContact(ax,ay,aw,ah,bx,by,bw,bh)
  local a = {x=ax,y=ay,width=aw,height=ah}
  local b = {x=bx,y=by,width=bw,height=bh}
  return contact.isInRectXRange(a,b) and contact.isInRectYRange(a,b)
end

function contact.isInRectXRange(a,b)
  if a.x < b.x then
    if a.x+a.width > b.x then
      return true
    end
  elseif a.x<b.x+b.width then
    return true
  end
  return false
end

function contact.isInRectYRange(a,b)
  if a.y < b.y then
    if a.y+a.height > b.y then
      return true
    end
  elseif a.y<b.y+b.height then
    return true
  end
  return false
end