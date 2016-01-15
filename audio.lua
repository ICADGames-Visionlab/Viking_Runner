audio={}
time = 10
switchMusic = true

function audio.load()
  --audio.stageMusic = love.audio.newSource("/Assets/Music/God Hand - Rock a Bay.mp3")
  --audio.stageMusic = love.audio.newSource("/Assets/Music/Sonic - DX.mp3")
  audio.stageMusic = love.audio.newSource("/Assets/Music/VRFASE22.ogg")
  audio.bossMusic = love.audio.newSource("/Assets/Music/God Hand - Devil May Sly.mp3")
  audio.gameoverMusic = love.audio.newSource("/Assets/Music/Gameovermusica.wav")
  audio.musicPlaying = nil
  timer = 0
  audio.pRunSound = love.audio.newSource("/Assets/Sfx/corrida.mp3","static")
  audio.pJumpSound = love.audio.newSource("/Assets/Sfx/Pulo2.wav","static")
  audio.pAttSound = love.audio.newSource("/Assets/Sfx/Machado.wav")
  audio.pAttSound:setVolume(0.3)
  audio.bulletSound = love.audio.newSource("/Assets/Sfx/Projetil.wav")
  audio.bulletSound:setVolume(0.3)
  audio.menuStartSound = love.audio.newSource("/Assets/Sfx/Select.wav")
  audio.menuStartSound:setVolume(0.5)
  audio.dragonDeathSound = love.audio.newSource("/Assets/Sfx/Dragonite.mp3")
  audio.dragonDeathSound:setVolume(1)
  audio.powerupSound = love.audio.newSource("/Assets/Sfx/Powerup2.wav")
  audio.powerupSound:setVolume(0.5)
  audio.fireloopSound = love.audio.newSource("/Assets/Sfx/fireloop.wav")
  audio.fireloopSound:setVolume(0.3)
  audio.fireloopSound:setLooping(true)
  audio.shieldSound = love.audio.newSource("/Assets/Sfx/shieldBreak.wav")
  audio.shieldSound:setVolume(0.4)
  audio.dragonScream = love.audio.newSource("/Assets/Sfx/DgScream.mp3")
  audio.dragonScream:setVolume(0.5)
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
  return
  --audio.playSfx(audio.pRunSound)
end
function audio.playPlayerAttack()
  audio.playSfx(audio.pAttSound)
end
function audio.playBullet()
  audio.playSfx(audio.bulletSound)
  audio.playFire()
end
function audio.playMenuStart()
  audio.playSfx(audio.menuStartSound)
end
function audio.playDragonDeath()
  audio.playSfx(audio.dragonDeathSound)
end
function audio.playPowerup()
  audio.playSfx(audio.powerupSound)
end
function audio.playFire()
  audio.playSfx(audio.fireloopSound)
end
function audio.stopFire()
  love.audio.stop(audio.fireloopSound)
end
function audio.playShield()
  audio.playSfx(audio.shieldSound)
end
function audio.enterGameover()
  audio.play(audio.gameoverMusic)
end
function audio.playBossMusic()
  audio.play(audio.bossMusic)
end
function audio.leaveGameover()
  audio.play(audio.stageMusic)
end
function audio.playDgScream()
  audio.playSfx(audio.dragonScream)
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