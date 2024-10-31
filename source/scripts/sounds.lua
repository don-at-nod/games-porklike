local pd <const> = playdate

sounds = {
	bad = "sound/bad.wav",
	badvase = "sound/badvase.wav", -- 59
	chest = "sound/chest.wav", -- 61
	door = "sound/door.wav", -- 62
	walk = "sound/walk.wav" -- 63
}

class('Sound').extends()

function Sound:play(sound)
	s = pd.sound.sampleplayer.new(sounds[sound])
	s:play()
end