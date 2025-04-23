local sounds = {}

-- Music
sounds["music_dungeon_passive"] = love.audio.newSource("graphics/sounds/skia/Dewdrop Maze.wav","static")
sounds["music_dungeon_passive"]:setVolume(0.1)
sounds["music_dungeon_active"] = love.audio.newSource("graphics/sounds/timbeek/8Bit_Adventure.wav","static")
sounds["music_dungeon_active"]:setVolume(0.1)

sounds["attack1"] = love.audio.newSource("graphics/sounds/kronbits/Impact_Punch.wav","static")
sounds["miss"] = love.audio.newSource("graphics/sounds/leohpaz/Slash.wav","static")

-- SFX
return sounds