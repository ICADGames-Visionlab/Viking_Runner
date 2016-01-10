animComp = {}

function animComp.newAnim(qFrames, animTime, doRepeat)
  local anim = {}
  anim.time = animTime
  anim.capTime = animTime / qFrames
  anim.qFrames = qFrames
  anim.canRepeat = (doRepeat==nil or doRepeat==true)
  animComp.restart(anim)
  return anim;
end

function animComp.update(dt, anim)
  anim.curr_time = anim.curr_time + dt
  if anim.curr_time > anim.capTime then
    anim.curr_time = anim.curr_time - anim.capTime
    anim.curr_frame = anim.curr_frame+1
    if anim.curr_frame > anim.qFrames then
      if not anim.canRepeat then
        anim.curr_frame = anim.qFrames
        anim.finished = true
        return -1
      else
        anim.curr_frame = 1
      end
    end
  end
  return anim.curr_frame
end

function animComp.restart(anim)
  anim.curr_frame = 1
  anim.curr_time = 0
  anim.finished = false
end