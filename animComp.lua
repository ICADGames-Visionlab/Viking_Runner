animComp = {}

function animComp.newAnim(qFrames, animTime, doRepeat)
  local anim = {}
  anim.curr_frame = 1
  anim.time = animTime
  anim.capTime = animTime / qFrames
  anim.curr_time = 0
  anim.qFrames = qFrames
  anim.canRepeat = (doRepeat==nil or doRepeat==true)
  return anim;
end

function animComp.update(dt, anim)
  anim.curr_time = anim.curr_time + dt
  if anim.curr_time > anim.capTime then
    anim.curr_time = anim.curr_time - anim.capTime
    anim.curr_frame = anim.curr_frame+1
    if anim.curr_frame > anim.qFrames then
      anim.curr_frame = 1
      if not anim.canRepeat then
        return -1
      end
    end
  end
  return anim.curr_frame
end

function animComp.restart(anim)
  anim.curr_frame = 1
  anim.curr_time = 0
end