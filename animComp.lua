animComp = {}

function animComp.newAnim(qFrames, animTime)
  anim = {}
  anim.curr_frame = 1
  anim.time = animTime
  anim.capTime = animTime / qFrames
  anim.curr_time = 0
  anim.qFrames = qFrames
  return anim;
end

function animComp.update(dt, anim)
  anim.curr_time = anim.curr_time + dt
  if anim.curr_time > anim.capTime then
    anim.curr_time = anim.curr_time - anim.capTime
    anim.curr_frame = anim.curr_frame+1
    if anim.curr_frame > anim.qFrames then anim.curr_frame = 1 end
  end
  return anim.curr_frame
end