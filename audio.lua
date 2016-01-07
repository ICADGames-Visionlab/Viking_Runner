audio={}
time = 10
switchMusic = true

function audio.load()
  audio.stageMusic = love.audio.newSource("/Assets/Music/God Hand - Rock a Bay.mp3")
  audio.bossMusic = love.audio.newSource("/Assets/Music/God Hand - Devil May Sly.mp3")
  audio.musicPlaying = nil
  timer = 0
  audio.pJumpSound = love.audio.newSource("/Assets/Sfx/Pulo.wav")
  audio.pRunSound = love.audio.newSource("/Assets/Sfx/corrida.mp3")
  audio.pRunSound:setLooping(true)
  audio.pAttSound = love.audio.newSource("/Assets/Sfx/Machado.wav")
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
  love.audio.play(audio.pJumpSound)
end
function audio.playPlayerRun()
  love.audio.stop(audio.pJumpSound)
  love.audio.play(audio.pRunSound)
end
function audio.playPlayerAttack()
  love.audio.play(audio.pAttSound)
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