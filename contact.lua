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
  return a.x < b.x+b.width and b.x<a.x+a.width
end

function contact.isInRectYRange(a,b)
  return a.y < b.y+b.height and b.y<a.y+a.height
end