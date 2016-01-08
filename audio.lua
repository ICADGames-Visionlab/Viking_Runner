audio={}
time = 10
switchMusic = true

function audio.load()
  --audio.stageMusic = love.audio.newSource("/Assets/Music/God Hand - Rock a Bay.mp3")
  audio.stageMusic = love.audio.newSource("/Assets/Music/Sonic - DX.mp3")
  audio.bossMusic = love.audio.newSource("/Assets/Music/God Hand - Devil May Sly.mp3")
  audio.musicPlaying = nil
  timer = 0
  audio.pJumpSound = love.audio.newSource("/Assets/Sfx/Pulo.wav","static")
  audio.pRunSound = love.audio.newSource("/Assets/Sfx/corrida.mp3","static")
  audio.pRunSound:setLooping(true)
  audio.pAttSound = love.audio.newSource("/Assets/Sfx/Machado.wav")
  audio.pAttSound:setVolume(0.5)
  --etc
end

function audio.play(music)
  if audio.musicPlaying ~= nil then
    love.audio.stop(audio.musicPlaying)
  end
  audio.musicPlaying = music
	music:setLooping(true)
  music:setVolume(0.3)
	love.audio.play(music)
end

function audio.playPlayerJump()
  love.audio.stop(audio.pRunSound)
  audio.playSfx(audio.pJumpSound)
end
function audio.playPlayerRun()
  love.audio.stop(audio.pJumpSound)
  audio.playSfx(audio.pRunSound)
end
function audio.playPlayerAttack()
  audio.playSfx(audio.pAttSound)
end

function audio.playSfx(sfx)
  if sfx:isPlaying() then
    love.audio.stop(sfx)
  end
  love.audio.play(sfx)
end

function audio.update(dt)
  --audio.switchTest(dt)
end

function audio.switchTest(dt)
  if switchMusic then
  timer = timer + dt
  if timer >= time then
    switchMusic = false
    audio.play(audio.bossMusic)
  end
  end
end